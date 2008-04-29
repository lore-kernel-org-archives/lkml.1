Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYD2Vqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYD2Vqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYD2Vq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:46:27 -0400
Received: from www.tglx.de ([62.245.132.106]:37221 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYD2Vq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:46:26 -0400
Date: Tue, 29 Apr 2008 23:46:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Helge Wagner <Helge.Wagner@gefanuc.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: restrict keyboard io ports reservation to make ipmi
 driver work
Message-ID: <alpine.LFD.1.10.0804292342060.6003@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helge Wagner <Helge.Wagner@gefanuc.com>

On some of our (single board computer) boards (x86) we are using an
IPMI controller that uses I/O ports 0x62 and 0x66 for a KCS (keyboard
controller style) IPMI system interface.
 
Trying to load the openipmi driver fails, because the ports
(0x62/0x66) are reserved for keyboard. keyboard reserves the full
range 0x60-0x6F while it doesn't need to.

Reserve only ports 0x60 and 0x64 for the legacy PS/2 i8042 keyboad
controller instead of 0x60-0x6F to allow the openipmi driver to work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/setup_32.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -127,7 +127,12 @@ static struct resource standard_io_resou
 }, {
 	.name	= "keyboard",
 	.start	= 0x0060,
-	.end	= 0x006f,
+	.end	= 0x0060,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "keyboard",
+	.start	= 0x0064,
+	.end	= 0x0064,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
 }, {
 	.name	= "dma page reg",
