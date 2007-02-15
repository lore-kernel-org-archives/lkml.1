Return-Path: <linux-kernel-owner+w=401wt.eu-S1161576AbXBOWhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161576AbXBOWhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161575AbXBOWhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:37:06 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24351 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161573AbXBOWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:37:03 -0500
Date: Thu, 15 Feb 2007 14:35:49 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <20070215124143.b52ad45b.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>
Message-id: <Pine.LNX.4.64.0702151427060.12571@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <20070215124143.b52ad45b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Randy Dunlap wrote:

> On Thu, 15 Feb 2007 08:29:49 -0800 (PST) Zwane Mwaikambo wrote:
> 
> > VBE1.2 doesn't support function 15h (DDC) resulting in a 'hang' whilst
> > uncompressing kernel with some video cards. Make sure we check VBE version 
> > before fiddling around with DDC.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=1458
> > 
> > Opened: 2003-10-30 09:12 Last update: 2007-02-13 22:03
> > 
> > :(
> 
> true.
> 
> Just one question:  why use 'je' instead of 'jle' (jge ?) : check for
> current version <= 0x0102, whatever that is in gas; I'm still used
> to intel syntax.

Good point;

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>

Index: linux-2.6.20-mm1/arch/i386/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/i386/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/i386/boot/video.S	15 Feb 2007 17:35:57 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/i386/boot/video.S	15 Feb 2007 22:28:34 -0000
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
+	jle	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
Index: linux-2.6.20-mm1/arch/x86_64/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/x86_64/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/x86_64/boot/video.S	15 Feb 2007 17:36:18 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/x86_64/boot/video.S	15 Feb 2007 22:29:00 -0000
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
+	jle	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
