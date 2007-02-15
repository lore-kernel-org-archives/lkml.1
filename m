Return-Path: <linux-kernel-owner+w=401wt.eu-S966010AbXBOQbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966010AbXBOQbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966077AbXBOQbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:31:03 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23507 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966010AbXBOQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:31:01 -0500
Date: Thu, 15 Feb 2007 08:29:49 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: [PATCH] Don't probe for DDC on VBE1.2
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>
Message-id: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

VBE1.2 doesn't support function 15h (DDC) resulting in a 'hang' whilst
uncompressing kernel with some video cards. Make sure we check VBE version 
before fiddling around with DDC.

http://bugzilla.kernel.org/show_bug.cgi?id=1458

Opened: 2003-10-30 09:12 Last update: 2007-02-13 22:03

:(

Much thanks to Tobias Hain for help in testing and investigating the bug. 
Tested on;

i386, Chips & Technologies 65548 VESA VBE 1.2
CONFIG_VIDEO_SELECT=Y
CONFIG_FIRMWARE_EDID=Y

Untested on x86_64.

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>

Index: linux-2.6.20-rc6-mm1/arch/i386/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc6-mm1/arch/i386/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-rc6-mm1/arch/i386/boot/video.S	30 Jan 2007 05:28:31 -0000	1.1.1.1
+++ linux-2.6.20-rc6-mm1/arch/i386/boot/video.S	15 Feb 2007 16:27:32 -0000
@@ -1945,6 +1945,20 @@ store_edid:
 	rep
 	stosl
 
+	pushw	%es
+	pushw	%ds
+	popw	%es
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	popw	%es
+
+	cmpw	$0x004f, %ax
+	jne	no_edid
+
+	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
+	je	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
Index: linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S	30 Jan 2007 05:28:36 -0000	1.1.1.1
+++ linux-2.6.20-rc6-mm1/arch/x86_64/boot/video.S	15 Feb 2007 16:27:32 -0000
@@ -1945,6 +1945,20 @@ store_edid:
 	rep
 	stosl
 
+	pushw	%es
+	pushw	%ds
+	popw	%es
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	popw	%es
+
+	cmpw	$0x004f, %ax
+	jne	no_edid
+
+	cmpw	$0x0102, 4(%di)			# only do EDID on > 1.2
+	je	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
