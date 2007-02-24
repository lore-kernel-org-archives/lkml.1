Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXBXSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXBXSxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 13:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbXBXSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 13:53:18 -0500
Received: from mba.ocn.ne.jp ([210.190.142.172]:64306 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbXBXSxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 13:53:18 -0500
Date: Sun, 25 Feb 2007 03:53:15 +0900 (JST)
Message-Id: <20070225.035315.25909736.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org
Subject: Re: Detecting section mismatches in vmlinux
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070222.005728.126762028.anemo@mba.ocn.ne.jp>
References: <20070222.005728.126762028.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 00:57:28 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> $ ../build-i386/scripts/mod/modpost ../build-i386/mm/built-in.o
> WARNING: ../build-i386/mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x18382) and '__kmem_cache_destroy'
> 
> set_up_list3s() in slab.c is not marked as __init and it references
> initkmem_list3[] which is marked as __initdata.  So it is not false
> positive.  But "modpost vmlinux" does not report it.

For this set_up_list3s() case, it is not a fatal since it is only
called during early bootstrap phase.  But anyway I think we should
detect these case at compile time.

I found refenrence_*.pl was removed on these commits at 2.6.17:

> commit eae0f536f640bb95f2ad437a57c40c7d5683d1ac
> Author: Sam Ravnborg <sam@mars.ravnborg.org>
> Date:   Tue Mar 21 07:28:24 2006 +0100
> 
>     kbuild: remove obsoleted scripts/reference_* files
> 
> commit b39927cf4cc5a9123d2b157ffd396884cb8156eb
> Author: Sam Ravnborg <sam@mars.ravnborg.org>
> Date:   Fri Feb 17 22:42:02 2006 +0100
> 
>     kbuild: check for section mismatch during modpost stage

Reviving these perl scripts looks overkill for me.

This is a dirty hack to check all built-in.o just after linking
vmlinux.  But this can not detect mismatches in libs.a files, and
modpost fails with "... is truncated" message on empty built-in.o
files.

Maybe checking at each $(LD) invocation should detect all mismatches,
but I'm not familer with kbuild to do it by myself.  Could someone
make perfect solution?


diff --git a/Makefile b/Makefile
index d442d4b..4e8015d 100644
--- a/Makefile
+++ b/Makefile
@@ -738,6 +738,7 @@ ifdef CONFIG_HEADERS_CHECK
 endif
 	$(call if_changed_rule,vmlinux__)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
+	-scripts/mod/modpost $(filter-out $(libs-y1),$(vmlinux-init) $(vmlinux-main))
 	$(Q)rm -f .old_version
 
 # The actual objects are generated when descending, 


---
Atsushi Nemoto
