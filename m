Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYDTTCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYDTTCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYDTTCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:02:44 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34134 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbYDTTCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:02:43 -0400
Date: Sun, 20 Apr 2008 22:02:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>, Joe Perches <joe@perches.com>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [2.6 patch] fix asm-x86/{posix_types,unistd}.h
Message-ID: <20080420190217.GA14788@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0804192351220.3260@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804192351220.3260@boston.corp.fedex.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 12:04:53AM +0800, Jeff Chua wrote:
>
> Linus,
>
> The latest git download changes the behavior of posix_types.h such that  
> non-kernel programs are no longer able to include posix types (e.g. 
> xserver can no longer be compiled).
>
> I don't know whether this is intended or a bug.

Thanks for reporting this bug.

Commit e40c0fe6b0b5dd16aec3c0dad311d36b19d78fd9
(x86: cleanup duplicate includes) contains no indication
this was intentional.

@Joe:
Please be more careful in the future.

@Ingo:
A proper review of the patch could have caught this bug that now made it 
into a stable kernel.

> Attached is a patch to allow __i386__ as was done in the past.
> 
> Thanks,
> Jeff.
>
>
> --- linux-2.6/include/asm-x86/posix_types.h.org	2008-04-19 16:53:03 +0800
> +++ linux-2.6/include/asm-x86/posix_types.h	2008-04-19 16:51:48 +0800
> @@ -1,5 +1,5 @@
> -#ifdef __KERNEL__
> -# if defined(CONFIG_X86_32) || defined(__i386__)
> +#if defined(__KERNEL__) || defined(__i386__)
> +# if defined(CONFIG_X86_32)
>  #  include "posix_types_32.h"
>  # else
>  #  include "posix_types_64.h"

This doesn't look as if it will work with 64bit userspace.

A patch that reverts the bogus changes to asm-x86/posix_types.h and 
asm-x86/unistd.h (which suffers from the same breakage) is below.

cu
Adrian


<--  snip  -->


Commit e40c0fe6b0b5dd16aec3c0dad311d36b19d78fd9
(x86: cleanup duplicate includes) turned the userspace
asm-x86/posix_types.h and asm-x86/unistd.h headers into
empty files.

This patch reverts these bogus changes.

Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-x86/posix_types.h |    8 +++++++-
 include/asm-x86/unistd.h      |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

ab170018723af65f4020db74757e4949d110963a diff --git a/include/asm-x86/posix_types.h b/include/asm-x86/posix_types.h
index fe312a5..bb7133d 100644
--- a/include/asm-x86/posix_types.h
+++ b/include/asm-x86/posix_types.h
@@ -1,5 +1,11 @@
 #ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+# ifdef CONFIG_X86_32
+#  include "posix_types_32.h"
+# else
+#  include "posix_types_64.h"
+# endif
+#else
+# ifdef __i386__
 #  include "posix_types_32.h"
 # else
 #  include "posix_types_64.h"
diff --git a/include/asm-x86/unistd.h b/include/asm-x86/unistd.h
index effc7ad..2a58ed3 100644
--- a/include/asm-x86/unistd.h
+++ b/include/asm-x86/unistd.h
@@ -1,5 +1,11 @@
 #ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+# ifdef CONFIG_X86_32
+#  include "unistd_32.h"
+# else
+#  include "unistd_64.h"
+# endif
+#else
+# ifdef __i386__
 #  include "unistd_32.h"
 # else
 #  include "unistd_64.h"

