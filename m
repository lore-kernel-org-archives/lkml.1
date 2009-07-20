Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZGTQDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZGTQDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZGTQDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:03:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbZGTQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:03:15 -0400
Date: Mon, 20 Jul 2009 09:01:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Krzysztof Oledzki <olel@ans.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <20090720151008.GC10015@suse.de>
Message-ID: <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Greg KH wrote:
>
> > >Linus Torvalds (1):
> > >      Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x
> > 
> > I'm very sorry to say that but 2.6.27.27 compiled with gcc-4.2.4
> > hangs during boot and it is caused by this fix.
> > 
> > I extended http://bugzilla.kernel.org/show_bug.cgi?id=13012 with
> > additional info & .config.
> 
> Wierd.  Linus, any thoughts?  Do we need to check the version of the
> compiler that we are using before turning that option off?

Dang. That was what we hoped to avoid by not using -fwrapv - we didn't 
know which compilers were buggy, although it _looked_ like just 4.1.x (I 
have some dim memory of somebody suspecting a 4.2.x version too, but that 
may have been just a "we know it should only be needed in 4.3.x, so maybe 
we shouldn't use it in 4.2.x either").

But it looks like the "buggy window" for -fno-strict-overflow is 
potentially even _larger_ than it ever was with -fwrapv. And I suspect 
that in both cases the real problem is that almost nobody ever uses either 
optimization flag, so coverage is way way smaller.

For now, I suspect we need to do something like this: go back to -fwrapv 
(because it has gotten more testing), but limit it to 4.2.x and newer.

However, it would be really good to figure out _why_ it breaks. It's 
probably some specific configuration issue in addition to the particular 
kernel vesion (and maybe it even needs some particular hardware to show 
the bug - ie a specific driver that triggers it or whatever).

			Linus

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 79957b3..47a3a1a 100644
--- a/Makefile
+++ b/Makefile
@@ -566,7 +566,7 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
-KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
+KBUILD_CFLAGS	+= $(call cc-ifversion, -ge, 0402, -fwrapv)
 
 # revert to pre-gcc-4.4 behaviour of .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
