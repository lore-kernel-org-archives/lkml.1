Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYBAT4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYBAT4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbYBAT4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:56:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbYBAT4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:56:42 -0500
Date: Fri, 1 Feb 2008 11:56:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: mingo@elte.hu, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make loglevel related commandline to early_param v2
Message-Id: <20080201115623.c9f1c85b.akpm@linux-foundation.org>
In-Reply-To: <200802011135.36475.yinghai.lu@sun.com>
References: <200802010240.37799.yinghai.lu@sun.com>
	<p73bq704zqs.fsf@bingen.suse.de>
	<200802011135.36475.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 11:35:35 -0800
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] make loglevel related commandline to early_param v2
> 
> so we can use them for early console like 
> console=uart8250,io,0x3f8,115200n8
> earlycon=uart8250,io,0x3f8,115200n8
> early_printk
> 
> otherwise printk(KERN_DEBUG "debug msg") will not print out to console even
> "debug" command line is used.
> 
> andi point out early_param need to return 0 instead 1.
> 
> Ingo had another patch in x86.git to process ignore_loglevel
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/init/main.c b/init/main.c
> index cb81ed1..3741bda 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -232,30 +232,26 @@ EXPORT_SYMBOL(loops_per_jiffy);
>  
>  static int __init debug_kernel(char *str)
>  {
> -	if (*str)
> -		return 0;
>  	console_loglevel = 10;
> -	return 1;
> +	return 0;
>  }
>  
>  static int __init quiet_kernel(char *str)
>  {
> -	if (*str)
> -		return 0;
>  	console_loglevel = 4;
> -	return 1;
> +	return 0;
>  }
>  
> -__setup("debug", debug_kernel);
> -__setup("quiet", quiet_kernel);
> +early_param("debug", debug_kernel);
> +early_param("quiet", quiet_kernel);
>  
>  static int __init loglevel(char *str)
>  {
>  	get_option(&str, &console_loglevel);
> -	return 1;
> +	return 0;
>  }
>  
> -__setup("loglevel=", loglevel);
> +early_param("loglevel", loglevel);
>  
>  /*
>   * Unknown boot options get handed to init, unless they look like

Your earlier patch converted ignore_loglevel but this one no longer does
so.  Was that deliberate?

Below is the patch whcih I presently have queued.  Is it OK?

 init/main.c     |   14 +++++---------
 kernel/printk.c |    5 ++---
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN init/main.c~convert-loglevel-related-kernel-boot-parameters-to-early_param init/main.c
--- a/init/main.c~convert-loglevel-related-kernel-boot-parameters-to-early_param
+++ a/init/main.c
@@ -232,22 +232,18 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 10;
-	return 1;
+	return 0;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 4;
-	return 1;
+	return 0;
 }
 
-__setup("debug", debug_kernel);
-__setup("quiet", quiet_kernel);
+early_param("debug", debug_kernel);
+early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
@@ -255,7 +251,7 @@ static int __init loglevel(char *str)
 	return 1;
 }
 
-__setup("loglevel=", loglevel);
+early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
diff -puN kernel/printk.c~convert-loglevel-related-kernel-boot-parameters-to-early_param kernel/printk.c
--- a/kernel/printk.c~convert-loglevel-related-kernel-boot-parameters-to-early_param
+++ a/kernel/printk.c
@@ -447,11 +447,10 @@ static int __init ignore_loglevel_setup(
 {
 	ignore_loglevel = 1;
 	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
-
-	return 1;
+	return 0;
 }
 
-__setup("ignore_loglevel", ignore_loglevel_setup);
+early_param("ignore_loglevel", ignore_loglevel_setup);
 
 /*
  * Write out chars from start to end - 1 inclusive
_

