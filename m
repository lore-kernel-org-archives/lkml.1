Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYKURlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYKURlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYKURlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:41:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:59810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbYKURlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:41:11 -0500
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4HFtfgyEkC"
Content-Transfer-Encoding: 7bit
Message-ID: <18726.62188.197402.569729@hermes.suse.de>
Date: Fri, 21 Nov 2008 18:42:04 +0100
From: Egbert Eich <eich@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Luc Verhaegen <lverhaegen@suse.de>, Egbert Eich <eich@suse.de>
Subject: Re: vm86 segfaults with NX bit
In-Reply-To: tiwai@suse.de wrote on Thursday, 20 November 2008 at 18:01:08 +0100 
References: <s5hmyfu9zl1.wl%tiwai@suse.de>
	<20081120085844.6f158e08@infradead.org>
	<s5h3ahm9vsb.wl%tiwai@suse.de>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4HFtfgyEkC
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

Takashi Iwai writes:
 > At Thu, 20 Nov 2008 08:58:44 -0800,
 > Arjan van de Ven wrote:
 > > 
 > > On Thu, 20 Nov 2008 16:39:06 +0100
 > > Takashi Iwai <tiwai@suse.de> wrote:
 > > 
 > > > Hi,
 > > > 
 > > > X guys reported that VESA driver segfaults in vm86 mode with a kernel
 > > > with CONFIG_X86_PAE, and it turned to be the NX bit.  See Novell
 > > > bugzilla #443440:
 > > > 	https://bugzilla.novell.com/show_bug.cgi?id=443440
 > > > 
 > > > I can confirm that the latest 2.6.28-rc still causes the same problem,
 > > > and it disappears when booted with noexec=off option.
 > > > 
 > > > Also, when NX bit is reset for the first 1MB (or smaller) in
 > > > do_sys_vm86(), it also works as expected.  But I have little clue
 > > > where to restore the bit again.
 > > > 
 > > > Any good suggestions / solutions?
 > > > 
 > > 
 > > did the code that mapped this memory setup use PROT_EXEC ?
 > 
 > A good question...
 > Luc, Egbert, how does VESA driver handle it?


Yes, we set the PROT_EXEC for the VBIOS. But the segfault doesn't happen
in VBIOS as far as I can tell. It happens on the 'exit instruction', a
hlt (0xf6) which is trapped by vm86 so it returns to the caller.
This is done by putting 0xf6 into address 0x600 and putting this address
on the stack.
The memory that's mapped at 0x600 in the Xserver's address space is
allocated thru shmget() and attached to the right place in the processes
memory space for vm86.
We should call mprotect() on these ranges to set this memory executable.
Hey, this code was orginally written almost 10 years ago!

The patch below fixes the issue.

Cheers,
	Egbert.


--4HFtfgyEkC
Content-Type: text/plain
Content-Disposition: inline;
	filename="diff.vm86_exec"
Content-Transfer-Encoding: 7bit

diff --git a/hw/xfree86/os-support/linux/int10/linux.c b/hw/xfree86/os-support/linux/int10/linux.c
index 67eb161..b15f7fd 100644
--- a/hw/xfree86/os-support/linux/int10/linux.c
+++ b/hw/xfree86/os-support/linux/int10/linux.c
@@ -1,6 +1,6 @@
 /*
  * linux specific part of the int10 module
- * Copyright 1999, 2000, 2001, 2002, 2003, 2004 Egbert Eich
+ * Copyright 1999, 2000, 2001, 2002, 2003, 2004, 2008 Egbert Eich
  */
 #ifdef HAVE_XORG_CONFIG_H
 #include <xorg-config.h>
@@ -357,7 +357,10 @@ MapCurrentInt10(xf86Int10InfoPtr pInt)
 		   "shmat(low_mem) error: %s\n",strerror(errno));
 	return FALSE;
     }
-    
+    if (mprotect((void*)0, V_RAM, PROT_READ|PROT_WRITE|PROT_EXEC) != 0)
+        xf86DrvMsg(pInt->scrnIndex, X_ERROR,
+		   "Cannot set EXEC bit on low memory: %s\n", strerror(errno));
+
     if (((linuxInt10Priv*)pInt->private)->highMem >= 0) {
 	addr = shmat(((linuxInt10Priv*)pInt->private)->highMem,
 		     (char*)HIGH_MEM, 0);
@@ -368,6 +371,11 @@ MapCurrentInt10(xf86Int10InfoPtr pInt)
 		       "shmget error: %s\n",strerror(errno));
 	    return FALSE;
 	}
+	if (mprotect((void*)HIGH_MEM, HIGH_MEM_SIZE,
+		     PROT_READ|PROT_WRITE|PROT_EXEC) != 0)
+	    xf86DrvMsg(pInt->scrnIndex, X_ERROR,
+		       "Cannot set EXEC bit on high memory: %s\n",
+		       strerror(errno));
     } else {
 	if ((fd = open(DEV_MEM, O_RDWR, 0)) >= 0) {
 	    if (mmap((void *)(V_BIOS), SYS_BIOS - V_BIOS,

--4HFtfgyEkC--
