Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZBDL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZBDL5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZBDL5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:57:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZBDL5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:57:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
Date: Wed, 4 Feb 2009 12:55:52 +0100
User-Agent: KMail/1.9.9
References: <20090204064307.GA18415@gondor.apana.org.au> <1233734645.3198.2.camel@localhost.localdomain>
In-Reply-To: <1233734645.3198.2.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, hpa@zytor.com, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, arnd@arndb.de,
       mchehab@infradead.org, jens.axboe@oracle.com,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041255.53264.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18AItzGm+5avybPPcqtz1OMEMDsgbFKOD6foam
 8AnsBMZurY3zhhUs5ex0mBM0V9A8q7gqhgJaJMi1qJOLS+MwKH
 r2JaIaJWvHhfoqyMMcwJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Jaswinder Singh Rajput wrote:
> On Wed, 2009-02-04 at 17:43 +1100, Herbert Xu wrote:
> > > -#include <asm/types.h>
> > > +#include <linux/types.h>
> > > #include <linux/ioctl.h>
> > 
> > Awesome, you've just broken the userspace build of kvm as the
> > file linux/types.h conflicts with sys/types.h.
> > 
> 
> What I did is absolutely right.
> 
> If there is any conflict then we need to solve it in better way.
> 
> Can you please share what is the conflict and what you are expecting and
> what you are getting.

I fear that the problem might be more widespread than just kvm.
The problem is that <linux/types.h> without __KERNEL_STRICT_NAMES
defines the standard types that glibc provides in its own <sys/types.h>,
some of them even defined differently (e.g. the size of off_t depends
__USE_FILE_OFFSET64).

You should be able to do

#include <sys/types.h>
#define __KERNEL_STRICT_NAMES
#include <linux/types.h>

or

#include <sys/types.h>
#include <asm/types.h>

but not without the __KERNEL_STRICT_NAMES! This means that the
mass-conversion to <linux/types.h> was flawed and should be fixed
before 2.6.29 to avoid more trouble.

This is related to the point I brought up earlier with u_int32_t
and other types being problematic in user space. I would suggest
changing all the headers that you converted from <asm/types.h>
to <linux/types.h> again to <linux/strict_types.h>, and apply
the patch below to make that possible.

---
Subject: introduce <linux/strict_types.h>

Exported user space headers should not use <linux/types.h> as that
leaks a number of type names, which conflict with the <sys/types.h>
provided by many libc variants.

This introduces a <linux/strict_types.h> that can be safely included
by any other header file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- /dev/null
+++ b/include/linux/strict_types.h
@@ -0,0 +1,31 @@
+#ifndef __LINUX_STRICT_TYPES_H
+#define __LINUX_STRICT_TYPES_H
+
+#include <asm/types.h>
+/*
+ * Below are truly Linux-specific types that should never collide with
+ * any application/library that wants linux/types.h.
+ */
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#ifdef __CHECK_ENDIAN__
+#define __bitwise __bitwise__
+#else
+#define __bitwise
+#endif
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+typedef __u16 __bitwise __sum16;
+typedef __u32 __bitwise __wsum;
+
+#endif /* __LINUX_STRICT_TYPES_H */
diff --git a/include/linux/types.h b/include/linux/types.h
index 712ca53..beacdb7 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -9,7 +9,7 @@
 #endif
 
 #include <linux/posix_types.h>
-#include <asm/types.h>
+#include <linux/strict_types.h>
 
 #ifndef __KERNEL_STRICT_NAMES
 
@@ -156,32 +156,6 @@ typedef unsigned long blkcnt_t;
 
 #endif /* __KERNEL_STRICT_NAMES */
 
-/*
- * Below are truly Linux-specific types that should never collide with
- * any application/library that wants linux/types.h.
- */
-
-#ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
-#else
-#define __bitwise__
-#endif
-#ifdef __CHECK_ENDIAN__
-#define __bitwise __bitwise__
-#else
-#define __bitwise
-#endif
-
-typedef __u16 __bitwise __le16;
-typedef __u16 __bitwise __be16;
-typedef __u32 __bitwise __le32;
-typedef __u32 __bitwise __be32;
-typedef __u64 __bitwise __le64;
-typedef __u64 __bitwise __be64;
-
-typedef __u16 __bitwise __sum16;
-typedef __u32 __bitwise __wsum;
-
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
