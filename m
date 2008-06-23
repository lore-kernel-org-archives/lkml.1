Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYFWXvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYFWXvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYFWXvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:51:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYFWXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:51:38 -0400
Date: Mon, 23 Jun 2008 16:51:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/kernel.h userspace header cleanup
Message-Id: <20080623165124.c1fd99de.akpm@linux-foundation.org>
In-Reply-To: <20080623174940.GL4756@cs181140183.pp.htv.fi>
References: <20080623174940.GL4756@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 20:49:40 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> Nothing from the bottom of this header is part of the 
> kernel<->userspace ABI.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  include/linux/kernel.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> c023fd63795380bceef9abc92c1d6fca91791de7 diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 792bf0a..2993b80 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -487,6 +487,8 @@ struct sysinfo {
>  	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
>  };
>  
> +#ifdef __KERNEL__
> +
>  /* Force a compilation error if condition is true */
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  
> @@ -506,4 +508,6 @@ struct sysinfo {
>  #define NUMA_BUILD 0
>  #endif
>  
> +#endif  /*  __KERNEL__  */
> +
>  #endif

Patches against linux-next would be better, especially during late -rc.
There's a 25MB diff between that and mainline.

I see no need to add an additional ifdef block here - better to move
the new kernel-only code to be inside the existing guards?

 include/linux/kernel.h |   42 ++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN include/linux/kernel.h~linux-kernelh-userspace-header-cleanup include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-userspace-header-cleanup
+++ a/include/linux/kernel.h
@@ -442,26 +442,6 @@ static inline char *pack_hex_byte(char *
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
-#endif /* __KERNEL__ */
-
-#define SI_LOAD_SHIFT	16
-struct sysinfo {
-	long uptime;			/* Seconds since boot */
-	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
-	unsigned long totalram;		/* Total usable main memory size */
-	unsigned long freeram;		/* Available memory size */
-	unsigned long sharedram;	/* Amount of shared memory */
-	unsigned long bufferram;	/* Memory used by buffers */
-	unsigned long totalswap;	/* Total swap space size */
-	unsigned long freeswap;		/* swap space still available */
-	unsigned short procs;		/* Number of current processes */
-	unsigned short pad;		/* explicit padding for m68k */
-	unsigned long totalhigh;	/* Total high memory size */
-	unsigned long freehigh;		/* Available high memory size */
-	unsigned int mem_unit;		/* Memory unit size in bytes */
-	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
-};
-
 /* Force a compilation error if condition is true */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
@@ -516,4 +496,26 @@ struct sysinfo {
 	__typesafe_cb(rettype (*)(__VA_ARGS__, void *), (fn),		\
 		      rettype (*)(__VA_ARGS__, const typeof(arg)),	\
 		      rettype (*)(__VA_ARGS__, typeof(arg)))
+
+
+#endif /* __KERNEL__ */
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	long uptime;			/* Seconds since boot */
+	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
+	unsigned long totalram;		/* Total usable main memory size */
+	unsigned long freeram;		/* Available memory size */
+	unsigned long sharedram;	/* Amount of shared memory */
+	unsigned long bufferram;	/* Memory used by buffers */
+	unsigned long totalswap;	/* Total swap space size */
+	unsigned long freeswap;		/* swap space still available */
+	unsigned short procs;		/* Number of current processes */
+	unsigned short pad;		/* explicit padding for m68k */
+	unsigned long totalhigh;	/* Total high memory size */
+	unsigned long freehigh;		/* Available high memory size */
+	unsigned int mem_unit;		/* Memory unit size in bytes */
+	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
+};
+
 #endif
_

