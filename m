Return-Path: <linux-kernel-owner+w=401wt.eu-S939471AbYCSV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939471AbYCSV66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbYCSUWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:22:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52064 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbYCSUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:22:49 -0400
Date: Wed, 19 Mar 2008 21:23:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080319202323.GA1811@elf.ucw.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz> <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org> <20080319114851.GB21270@atrey.karlin.mff.cuni.cz> <alpine.LFD.1.00.0803190742450.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803190742450.3020@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
> > of drivers/acpi/ec.c patch fixed the
> > "rc6-breaks-backlight-in-X-over-lid-close", good.
> 
> Can you clarify a bit?
> 
> Do you mean that the full revert of 2c81ce4 that already got committed is 
> sufficient for you, or do you need to totally undo everything we've done 
> to ec.c since -rc5, and thus also to revert the _other_ revert we did (in 
> 4af8e10a6c57e7292862bd1703712f0565c7e429)?

I did some more testing, and realized I was wrong. We need to totally
undo everything we've done to ec.c since -rc5... (that has small
sideffect of brightness up/down keys no longer working -- regression
since 2.6.24, but saves us from "backlight gone after
closing/reopening lid" which is _NASTY_ regression from 2.6.25-rc5).

ACPI sucks.

I.e. this patch:


Revert ec.c to 2.6.25-rc5 state:

* this fixes backlight after closing/reopening the lid while in X on
thinkpad x60

* unfortunately it breaks fn-home/end keyboard brightness control

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7222a18..caf873c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -943,7 +943,11 @@ int __init acpi_ec_ecdt_probe(void)
 		boot_ec->command_addr = ecdt_ptr->control.address;
 		boot_ec->data_addr = ecdt_ptr->data.address;
 		boot_ec->gpe = ecdt_ptr->gpe;
-		boot_ec->handle = ACPI_ROOT_OBJECT;
+		if (ACPI_FAILURE(acpi_get_handle(NULL, ecdt_ptr->id,
+				&boot_ec->handle))) {
+			pr_info("Failed to locate handle for boot EC\n");
+			boot_ec->handle = ACPI_ROOT_OBJECT;
+		}
 	} else {
 		/* This workaround is needed only on some broken machines,
 		 * which require early EC, but fail to provide ECDT */

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
