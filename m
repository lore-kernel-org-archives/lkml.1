Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbXE2S3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbXE2S3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbXE2S3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:29:00 -0400
Received: from rtr.ca ([64.26.128.89]:3625 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXE2S27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:28:59 -0400
Message-ID: <465C70EA.9020300@rtr.ca>
Date: Tue, 29 May 2007 14:28:58 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org> <465C608E.3040303@rtr.ca> <465C64D1.3030604@rtr.ca> <alpine.LFD.0.98.0705291048020.26602@woody.linux-foundation.org> <465C6E9B.2040605@rtr.ca>
In-Reply-To: <465C6E9B.2040605@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Linus Torvalds wrote:
..
>> There's a different (but related to all the same freezer problems) 
>> patch by Rafael Wysocki <rjw@sisk.pl>:
>>
>>     Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by 
>> default
>>     Message-Id: <200705291415.31970.rjw@sisk.pl>
> 
> I'll hunt for Rafael's patch next.

Mmm.. Rafael's patch appears to be part of a large series of 15 patches,
and it's not totally clear to me how to test just that part of it,
so I think I'll leave things as is (working!) for now.

Here's my current fix:

-- snip --

Regarding commit 7ed92f1a149dddc3cb537ccd7441e98adac12c3e
"USB: make the autosuspend workqueue thread freezable":

This commit causes USB lockups on resume from Suspend-to-RAM
on my Core2duo notebook.  Applying the patch below to revert
the commit fixes the problem for me in 2.6.22-rc3.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- b0rken/drivers/usb/core/usb.c	2007-05-29 13:32:32.000000000 -0400
+++ linux/drivers/usb/core/usb.c	2007-05-29 13:27:10.000000000 -0400
@@ -205,11 +205,7 @@
 
 static int ksuspend_usb_init(void)
 {
-	/* This workqueue is supposed to be both freezable and
-	 * singlethreaded.  Its job doesn't justify running on more
-	 * than one CPU.
-	 */
-	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
+	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
 	if (!ksuspend_usb_wq)
 		return -ENOMEM;
 	return 0;
