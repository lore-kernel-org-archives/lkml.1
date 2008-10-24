Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYJXXP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYJXXP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbYJXXPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:15:37 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:38043 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472AbYJXXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:15:35 -0400
Date: Fri, 24 Oct 2008 21:15:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024191552.GA14894@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810241224.38541.alistair@devzero.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 12:24:38PM +0100, Alistair John Strachan wrote:
> On Friday 24 October 2008 05:10:29 Linus Torvalds wrote:
> > It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1
> > is out there, and it's hopefully all good.
> 
> It seems if you have a broken asm/ symlink in include/ (which happened as a 
> result of the x86 header moves, for me) the kernel won't try to update it 
> appropriately, and this breaks "make prepare".
> 
> $ make    ARCH=x86_64 prepare                                                                                                   
>   CHK     include/linux/version.h                                                                                                                            
>   CHK     include/linux/utsrelease.h                                                                                                                         
>   GEN     include/asm/asm-offsets.h                                                                                                                          
> /bin/sh: include/asm/asm-offsets.h: No such file or directory                                                                                                
> make[1]: *** [include/asm/asm-offsets.h] Error 1                                                                                                             
> make: *** [prepare0] Error 2
> 
> rm -f include/asm fixes it
> 
> This was just from taking a 2.6.27 tree, git clean -d -f, git pull, make 
> oldconfig. Might be a nice thing to fix?

The following patch add another special case hwre we delete stale symlinks.
In my limited testing it fixes the issue - can you try to give it a spin.

	Sam

diff --git a/Makefile b/Makefile
index f6703f1..9dc7427 100644
--- a/Makefile
+++ b/Makefile
@@ -961,6 +961,7 @@ export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
 # The asm symlink changes when $(ARCH) changes.
 # Detect this and ask user to run make mrproper
+# If asm is a stale symlink (point to dir that does not exist) remove it
 define check-symlink
 	set -e;                                                            \
 	if [ -L include/asm ]; then                                        \
@@ -970,6 +971,7 @@ define check-symlink
 			echo "       set ARCH or save .config and run 'make mrproper' to fix it";             \
 			exit 1;                                            \
 		fi;                                                        \
+		test -e $$asmlink || rm include/asm;                       \
 	fi
 endef
 
