Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYDBQU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYDBQU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbYDBQUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:20:09 -0400
Received: from rtr.ca ([76.10.145.34]:4278 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbYDBQUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:20:07 -0400
Message-ID: <47F3B235.4000103@rtr.ca>
Date: Wed, 02 Apr 2008 12:20:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: stern@rowland.harvard.edu, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
Subject: [PATCH] usb ehci_iaa_watchdog fix
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org> <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> Also, check out the thread on LKML started by Tino Keitel.  He had
>> similar problems and found that reverting commit
>> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 fixed them.
> 
> And try the change I suggested there:  taking the
> HC_IS_RUNNING test out of ehci_iaa_watchdog().
..

Yup, that does indeed cure it.
Here's a patch, in case you didn't already generate one:

Signed-off-by: Mark Lord <mlord@pobox.com>

--- rc8/drivers/usb/host/ehci-hcd.c	2008-03-11 11:18:40.000000000 -0400
+++ linux/drivers/usb/host/ehci-hcd.c	2008-04-02 12:16:40.000000000 -0400
@@ -289,9 +289,7 @@
 	 * (a) SMP races against real IAA firing and retriggering, and
 	 * (b) clean HC shutdown, when IAA watchdog was pending.
 	 */
-	if (ehci->reclaim
-			&& !timer_pending(&ehci->iaa_watchdog)
-			&& HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
+	if (ehci->reclaim && !timer_pending(&ehci->iaa_watchdog)) {
 		u32 cmd, status;
 
 		/* If we get here, IAA is *REALLY* late.  It's barely
