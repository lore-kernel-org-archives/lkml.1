Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYJLTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYJLTXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYJLTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:23:25 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:37931 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988AbYJLTXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:23:24 -0400
Message-ID: <48F24EAE.6020108@suse.de>
Date: Sun, 12 Oct 2008 23:23:26 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810112140.16662.rjw@sisk.pl> <48F100CA.2050600@suse.de> <200810112254.09094.rjw@sisk.pl> <48F1BFD0.7040004@tuffmail.co.uk>
In-Reply-To: <48F1BFD0.7040004@tuffmail.co.uk>
Content-Type: multipart/mixed;
 boundary="------------000508050408010900030201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508050408010900030201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
>> On Saturday, 11 of October 2008, Alexey Starikovskiy wrote:
>>   
>>> Rafael J. Wysocki wrote:
>>>     
>>>>> No, we discussed this before -- we are outside of the transaction, thus 
>>>>> no GPE
>>>>> activity could interfere with ec_check_ibf0.
>>>>>         
>>>> Ok, this is in the process context and we don't really expect to get an
>>>> interrupt at this point, but what happens if the EC generates an event that's
>>>> not related to any transiaction.  Is that guaranteed to never happen?
>>>>       
>>> Interrupt handler in this case can't cause a change to status register, thus our 
>>> read of it will not be affected by interrupt.
>>>     
>> Ok, thanks.
>>
>> Alan, does the patch work for you?
>>
>> Rafael
>>   
> 
> Yes.  Two reboot cycles, three suspend/resume cycles each, and no error
> message.
> 
> I hope we have a better fix in mind though :-P.  The patch doesn't solve
> the unnecessary 500ms delay when this thing happens.

Something like this?

Regards,
Alex.

--------------000508050408010900030201
Content-Type: text/x-diff;
 name="2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.patch"

ACPI: EC: Check for IBF=0 once again after timeout

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---
 drivers/acpi/ec.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 69f5f78..5e7c9c5 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -300,6 +300,17 @@ static int ec_check_ibf0(struct acpi_ec *ec)
 	return (status & ACPI_EC_FLAG_IBF) == 0;
 }
 
+static int ec_wait_ibf0(struct acpi_ec *ec)
+{
+	unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
+	while (time_before(jiffies, delay)) {
+		if (wait_event_timeout(ec->wait, ec_check_ibf0(ec),
+					msecs_to_jiffies(1)))
+		return 0;
+	}
+	return -ETIME;
+}
+
 static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t,
 			       int force_poll)
 {
@@ -317,8 +328,7 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t,
 			goto unlock;
 		}
 	}
-	if (!wait_event_timeout(ec->wait, ec_check_ibf0(ec),
-				msecs_to_jiffies(ACPI_EC_DELAY))) {
+	if (ec_wait_ibf0(ec)) {
 		pr_err(PREFIX "input buffer is not empty, "
 				"aborting transaction\n");
 		status = -ETIME;

--------------000508050408010900030201--
