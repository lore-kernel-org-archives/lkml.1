Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYFIWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYFIWUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYFIWUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:20:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbYFIWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:20:22 -0400
Date: Mon, 9 Jun 2008 15:19:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <20080609215651.GF21429@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0806091458121.3218@woody.linux-foundation.org>
References: <200806091712.46869.oliver@neukum.org> <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org> <20080609195015.GA6601@suse.de> <20080609205916.GC21429@elf.ucw.cz> <alpine.LFD.1.10.0806091435120.3218@woody.linux-foundation.org>
 <20080609215651.GF21429@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jun 2008, Pavel Machek wrote:
> 
> With USB_PERSIST on, you have problem on all drivers but usb-storage,
> AFAICT... because usb-storage seems to be the only driver implementing
> reset_resume.

So let's *fix* it. It's not as if USB_PERSIST is new - it was there 
for well over a year. Disabling it yet again will obviously not fix 
*anything*.

> I guess it is possible to do something like "if reset_resume() is
> unavailable, try plain resume()" in usb/driver.c, but I'd really
> changes to the suspend/resume callback to go in -rc1 so that they are
> tested properly, and not hot-patch it now.

And how many people have actually even reported the problem? And how big 
do you seriously expect the patch to be?

This isn't even a regression - it's behavior that has always been there. 
It's just that now the behavior is much more exposed, and by being more 
exposed, people now see a bug that they didn't see before. Let's just try 
to *fix* it first, especially since the guesses about how to fix it have 
so far been fairly simple.

For example, if it's really just a "if we don't have a reset_resume() 
function, use the regular resume instead", does this trivial patch make a 
difference? I dunno, but it seems to be what people are saying we should 
just try. Much simpler than a revert.

		Linus

---
 drivers/usb/core/driver.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 1e56f1c..893a1fe 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -885,17 +885,11 @@ static int usb_resume_interface(struct usb_interface *intf, int reset_resume)
 	}
 	driver = to_usb_driver(intf->dev.driver);
 
-	if (reset_resume) {
-		if (driver->reset_resume) {
-			status = driver->reset_resume(intf);
-			if (status)
-				dev_err(&intf->dev, "%s error %d\n",
-						"reset_resume", status);
-		} else {
-			/* status = -EOPNOTSUPP; */
-			dev_warn(&intf->dev, "no %s for driver %s?\n",
-					"reset_resume", driver->name);
-		}
+	if (reset_resume && driver->reset_resume) {
+		status = driver->reset_resume(intf);
+		if (status)
+			dev_err(&intf->dev, "%s error %d\n",
+					"reset_resume", status);
 	} else {
 		if (driver->resume) {
 			status = driver->resume(intf);
