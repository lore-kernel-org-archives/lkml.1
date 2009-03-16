Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbZCPT3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbZCPT3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZCPT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:29:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60400 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZCPT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:29:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Mar 2009 20:29:04 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] async: remove the temporary (2.6.29) "async is off by
 default" code
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090315112438.79f40526@infradead.org>
Message-ID: <tkrat.92d38dd320374c4d@s5r6.in-berlin.de>
References: <20090315112345.764fc4ac@infradead.org>
 <20090315112438.79f40526@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Mar, Arjan van de Ven wrote:
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -391,16 +391,8 @@ static int __init async_init(void)
>  		if (IS_ERR(kthread_run(async_manager_thread, NULL,
>  				       "async/mgr")))
>  			async_enabled = 0;
> -	return 0;
> -}
> -
> -static int __init setup_async(char *str)
> -{
>  	async_enabled = 1;
> -	return 1;
> +	return 0;
>  }
>  
> -__setup("fastboot", setup_async);
> -
> -
>  core_initcall(async_init);


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: async: enable it for real

Fix 'async: remove the temporary (2.6.29) "async is off by default" code'.

Also warn if the thread couldn't be started.  A start failure may have
serious side effects when more code starts to use <linux/async.h>.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Only compile-tested.

 kernel/async.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/kernel/async.c
===================================================================
--- linux.orig/kernel/async.c
+++ linux/kernel/async.c
@@ -49,6 +49,7 @@ asynchronous and synchronous parts of th
 */
 
 #include <linux/async.h>
+#include <linux/bug.h>
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
@@ -387,11 +388,10 @@ static int async_manager_thread(void *un
 
 static int __init async_init(void)
 {
-	if (async_enabled)
-		if (IS_ERR(kthread_run(async_manager_thread, NULL,
-				       "async/mgr")))
-			async_enabled = 0;
-	async_enabled = 1;
+	async_enabled =
+		!IS_ERR(kthread_run(async_manager_thread, NULL, "async/mgr"));
+
+	WARN_ON(!async_enabled);
 	return 0;
 }
 


-- 
Stefan Richter
-=====-==--= --== =----
http://arcgraph.de/sr/

