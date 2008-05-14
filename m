Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbYENLFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbYENLFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbYENLFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:05:40 -0400
Received: from baikonur.stro.at ([213.239.196.228]:42234 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbYENLFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:05:39 -0400
Date: Wed, 14 May 2008 13:05:31 +0200
From: maximilian attems <max@stro.at>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, Mike Frysinger <vapier@gentoo.org>,
       debian-kernel@lists.debian.org
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for
	userspace
Message-ID: <20080514110531.GA11775@stro.at>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Richard Henderson <rth@twiddle.net>,
	Mike Frysinger <vapier@gentoo.org>, debian-kernel@lists.debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805100836.48046.vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could we please get an ack or nack on that patch.
checked linux-next and it doesn't appear there.
without it currently perl 5.10 doesn't build on alpha:
perl.c: In function 'perl_construct':
perl.c:388: error: 'CONFIG_HZ' undeclared (first use in this function)
-> http://buildd.debian.org/fetch.cgi?pkg=perl;ver=5.10.0-10;arch=alpha;stamp=1210252894

-- 
maks

I noticed this because alpha was broken due to the recent bdc807871d58285737. 
Most arches do something like this in their asm/param.h:
#ifdef __KERNEL__
# define HZ CONFIG_HZ
#else
# define HZ 100
#endif
A few arches though (namely alpha/h8300/um/v850/xtensa) either do no set HZ at
all for !__KERNEL__, or they set it wrongly.  This should bring all arches in
line by setting up HZ for userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-alpha/param.h b/include/asm-alpha/param.h
index 0982f1d..d300950 100644
--- a/include/asm-alpha/param.h
+++ b/include/asm-alpha/param.h
@@ -5,8 +5,12 @@
    hardware ignores reprogramming.  We also need userland buy-in to the 
    change in HZ, since this is visible in the wait4 resources etc.  */
 
+#ifdef __KERNEL__
 #define HZ		CONFIG_HZ
 #define USER_HZ		HZ
+#else
+#define HZ		100
+#endif
 
 #define EXEC_PAGESIZE	8192
 
diff --git a/include/asm-h8300/param.h b/include/asm-h8300/param.h
index 04f64f1..1c72fb8 100644
--- a/include/asm-h8300/param.h
+++ b/include/asm-h8300/param.h
@@ -1,14 +1,12 @@
 #ifndef _H8300_PARAM_H
 #define _H8300_PARAM_H
 
-
-#ifndef HZ
-#define HZ CONFIG_HZ
-#endif
-
 #ifdef __KERNEL__
+#define HZ		CONFIG_HZ
 #define	USER_HZ		HZ
 #define	CLOCKS_PER_SEC	(USER_HZ)
+#else
+#define HZ		100
 #endif
 
 #define EXEC_PAGESIZE	4096
diff --git a/include/asm-um/param.h b/include/asm-um/param.h
index 4cd4a22..e44f4e6 100644
--- a/include/asm-um/param.h
+++ b/include/asm-um/param.h
@@ -13,6 +13,8 @@
 #define HZ CONFIG_HZ
 #define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
+#else
+#define HZ 100
 #endif
 
 #endif
diff --git a/include/asm-v850/param.h b/include/asm-v850/param.h
index 2818326..4391f5f 100644
--- a/include/asm-v850/param.h
+++ b/include/asm-v850/param.h
@@ -26,6 +26,8 @@
 # define HZ		CONFIG_HZ
 # define USER_HZ	100
 # define CLOCKS_PER_SEC	USER_HZ
+#else
+# define HZ		100
 #endif
 
 #endif /* __V850_PARAM_H__ */
diff --git a/include/asm-xtensa/param.h b/include/asm-xtensa/param.h
index 82ad34d..ba03d5a 100644
--- a/include/asm-xtensa/param.h
+++ b/include/asm-xtensa/param.h
@@ -15,6 +15,8 @@
 # define HZ		CONFIG_HZ	/* internal timer frequency */
 # define USER_HZ	100		/* for user interfaces in "ticks" */
 # define CLOCKS_PER_SEC (USER_HZ)	/* frequnzy at which times() counts */
+#else
+# define HZ		100
 #endif
 
 #define EXEC_PAGESIZE	4096
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
