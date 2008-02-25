Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYBYWeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYBYWeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbYBYWeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:34:01 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:53922 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759519AbYBYWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:34:00 -0500
Message-ID: <47C34246.2020705@suse.de>
Date: Tue, 26 Feb 2008 01:33:42 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on
 thinkpad T61p
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>	 <47C31A1E.7080305@suse.de>	 <8f53421d0802251239h6b872d94w677995789990e31b@mail.gmail.com>	 <47C32A1D.8030604@suse.de> <8f53421d0802251301g247506e9jb341b9012dac71d7@mail.gmail.com>
In-Reply-To: <8f53421d0802251301g247506e9jb341b9012dac71d7@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030109050904080804010404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030109050904080804010404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael S. Tsirkin wrote:
> On Mon, Feb 25, 2008 at 10:50 PM, Alexey Starikovskiy
> <astarikovskiy@suse.de> wrote:
>> Michael S. Tsirkin wrote:
>>  > Did you guys stop accepting reports by mail?
>>  > I hope not.
>>  It is easier to track bug information in bugzilla.
>>  If you for some reason do not wish to create a bug report,
>>  I can do it for you. You only need to provide acpidump.
> 
> Great.
> 
>>  >> and attach acpidump?
>>  >
>>  > I'll see if I can get acpidump output - in which state do you want it?
>>  > Right after boot on the broken kernel?
>>  acpidump output does not change over time, you could get it even with some other kernel.
>>
>>
> 
> Attached is the acpidump output run under 2.6.23-rc3 + with reverted
> 37f9b4c7c612fcbeb8fb6faddaef4ccdb5350145
> (IOW - this is a working configuration).
Thanks, you've got round 10100 bug number.

Please check if the following patch on top of Linus git tree helps.

Regards,
Alex 

> 
> HTH,
> MST
> 


--------------030109050904080804010404
Content-Type: text/x-patch;
 name="ec-x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ec-x.patch"

ACPI: EC: fix regression

From: Alexey Starikovskiy <astarikovskiy@suse.de>


---

 drivers/acpi/ec.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index caf873c..d6f9956 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -129,7 +129,8 @@ static struct acpi_ec {
 	struct mutex lock;
 	wait_queue_head_t wait;
 	struct list_head list;
-	u8 handlers_installed;
+	u8 handlers_installed:1;
+	u8 from_ecdt:1;
 } *boot_ec, *first_ec;
 
 /* --------------------------------------------------------------------------
@@ -772,16 +773,18 @@ static int acpi_ec_add(struct acpi_device *device)
 
 	/* Check for boot EC */
 	if (boot_ec) {
-		if (boot_ec->handle == device->handle) {
-			/* Pre-loaded EC from DSDT, just move pointer */
-			ec = boot_ec;
-			boot_ec = NULL;
-			goto end;
-		} else if (boot_ec->handle == ACPI_ROOT_OBJECT) {
+		if (boot_ec->from_ecdt &&
+		    (boot_ec->handle == device->handle ||
+		     boot_ec->handle == ACPI_ROOT_OBJECT)) {
 			/* ECDT-based EC, time to shut it down */
 			ec_remove_handlers(boot_ec);
 			kfree(boot_ec);
 			first_ec = boot_ec = NULL;
+		} else if (boot_ec->handle == device->handle) {
+			/* Pre-loaded EC from DSDT, just move pointer */
+			ec = boot_ec;
+			boot_ec = NULL;
+			goto end;
 		}
 	}
 
@@ -943,6 +946,7 @@ int __init acpi_ec_ecdt_probe(void)
 		boot_ec->command_addr = ecdt_ptr->control.address;
 		boot_ec->data_addr = ecdt_ptr->data.address;
 		boot_ec->gpe = ecdt_ptr->gpe;
+		boot_ec->from_ecdt = 1;
 		if (ACPI_FAILURE(acpi_get_handle(NULL, ecdt_ptr->id,
 				&boot_ec->handle))) {
 			pr_info("Failed to locate handle for boot EC\n");

--------------030109050904080804010404--
