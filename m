Return-Path: <linux-kernel-owner+w=401wt.eu-S1765829AbYCSXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765829AbYCSXDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937400AbYCSVaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:30:15 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41110 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932443AbYCSVaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:30:11 -0400
Message-ID: <47E05408.7000003@suse.de>
Date: Wed, 19 Mar 2008 02:45:12 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation	patchset
 against -rc6)
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318232037.GA1670@elf.ucw.cz>
In-Reply-To: <20080318232037.GA1670@elf.ucw.cz>
Content-Type: multipart/mixed;
 boundary="------------050301030602030505050100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050301030602030505050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pavel Machek wrote:
> On Tue 2008-03-18 10:31:28, Linus Torvalds wrote:
>>
>> On Tue, 18 Mar 2008, Pavel Machek wrote:
>>> On Tue 2008-03-18 14:06:42, Pavel Machek wrote:
>>>> Confirmed, suspend slowness is in 2.6.25-rc6, too. It takes 15 seconds
>>>> to suspend/resume, while 2.6.24 takes 9. Thinkpad x60.
>>> IIRC 2.6.25-rc5 was "fast".
>> Can you bisect it? There's only 343 commits between -rc5 and -rc6, so it 
>> should not take too long to check which commit it is. Even if it should 
>> take 9 reboots to bisect it entirely, going just five or six will likely 
>> narrow it down sufficiently that we can probably guess fairly well what 
>> it's about.
> 
> Slowdown is fixed by this patch:
I think only this part is relevant here. But yes, I agree that the whole 
patch should be reverted.
> @@ -230,7 +227,6 @@ static int acpi_ec_wait(struct acpi_ec *
>  		while (time_before(jiffies, delay)) {
>  			if (acpi_ec_check_status(ec, event))
>  				goto end;
> -			msleep(5);
>  		}
>  	}
>  	pr_err(PREFIX "acpi_ec_wait timeout,"
Thanks,
Alex.

--------------050301030602030505050100
Content-Type: text/x-patch;
 name="x-rev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x-rev.patch"

ACPI: EC: Revert storm handler patch

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Patch have caused several new troubles, so just revert it for now.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/ec.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e7e197e..7222a18 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -129,7 +129,6 @@ static struct acpi_ec {
 	struct mutex lock;
 	wait_queue_head_t wait;
 	struct list_head list;
-	atomic_t irq_count;
 	u8 handlers_installed;
 } *boot_ec, *first_ec;
 
@@ -182,8 +181,6 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
 {
 	int ret = 0;
 
-	atomic_set(&ec->irq_count, 0);
-
 	if (unlikely(event == ACPI_EC_EVENT_OBF_1 &&
 		     test_bit(EC_FLAGS_NO_OBF1_GPE, &ec->flags)))
 		force_poll = 1;
@@ -230,7 +227,6 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
 		while (time_before(jiffies, delay)) {
 			if (acpi_ec_check_status(ec, event))
 				goto end;
-			msleep(5);
 		}
 	}
 	pr_err(PREFIX "acpi_ec_wait timeout,"
@@ -533,13 +529,6 @@ static u32 acpi_ec_gpe_handler(void *data)
 	struct acpi_ec *ec = data;
 
 	pr_debug(PREFIX "~~~> interrupt\n");
-	atomic_inc(&ec->irq_count);
-	if (atomic_read(&ec->irq_count) > 5) {
-		pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
-		acpi_disable_gpe(NULL, ec->gpe, ACPI_ISR);
-		clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
-		return ACPI_INTERRUPT_HANDLED;
-	}
 	clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
 	if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags))
 		wake_up(&ec->wait);

--------------050301030602030505050100--
