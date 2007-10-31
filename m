Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXJaE40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXJaE40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXJaE4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:56:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51972
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbXJaE4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:56:17 -0400
Date: Tue, 30 Oct 2007 21:56:16 -0700 (PDT)
Message-Id: <20071030.215616.241765510.davem@davemloft.net>
To: sam@ravnborg.org
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in
 exported headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030.211404.43558275.davem@davemloft.net>
References: <20071030222025.GA19792@uranus.ravnborg.org>
	<20071030.153154.241148799.davem@davemloft.net>
	<20071030.211404.43558275.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 30 Oct 2007 21:14:04 -0700 (PDT)

> Unfortunately I have to back it out, it breaks the build.
> 
> In file included from net/tipc/core.h:41,
>                  from net/tipc/addr.c:37:
> include/linux/tipc_config.h: In function 'TLV_SET':
> include/linux/tipc_config.h:306: error: implicit declaration of function 'memcpy'
> include/linux/tipc_config.h:306: warning: incompatible implicit declaration of built-in function 'memcpy'
> 
> I truly think adding linux/string.h to unifdef-y along with:
> 
> #ifndef __KERNEL__
> #include <string.h>
> #else
>  ...
> #endif
> 
> in linux/string.h is a much cleaner and less error prone solution :-)

Here is what I mean, specifically.  And this is build tested :-)

>From 97ef1bb0c8e371b7988287f38bd107c4aa14d78d Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@sunset.davemloft.net>
Date: Tue, 30 Oct 2007 21:44:00 -0700
Subject: [PATCH] [TIPC]: Fix headercheck wrt. tipc_config.h

It wants string functions like memcpy() for inline
routines, and these define userland interfaces.

The only clean way to deal with this is to simply
put linux/string.h into unifdef-y and have it
include <string.h> when not-__KERNEL__.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/Kbuild   |    1 +
 include/linux/string.h |   12 +++---------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index bd33c22..37bfa19 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -326,6 +326,7 @@ unifdef-y += sonypi.h
 unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
+unifdef-y += string.h
 unifdef-y += synclink.h
 unifdef-y += sysctl.h
 unifdef-y += tcp.h
diff --git a/include/linux/string.h b/include/linux/string.h
index 836062b..c5d3fca 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -3,16 +3,14 @@
 
 /* We don't want strings.h stuff being user by user stuff by accident */
 
-#ifdef __KERNEL__
+#ifndef __KERNEL__
+#include <string.h>
+#else
 
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 extern char *strndup_user(const char __user *, long);
 
 /*
@@ -111,9 +109,5 @@ extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
-#ifdef __cplusplus
-}
-#endif
-
 #endif
 #endif /* _LINUX_STRING_H_ */
-- 
1.5.2.5

