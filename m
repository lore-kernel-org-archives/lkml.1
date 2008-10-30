Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYJ3USn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYJ3USn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJ3USf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:18:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbYJ3USe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:18:34 -0400
Date: Thu, 30 Oct 2008 13:17:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Viktor Rosendahl <viktor.rosendahl@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/1] Make sure that any oops is flushed to the mtdoops
 console
Message-Id: <20081030131734.c74e614d.akpm@linux-foundation.org>
In-Reply-To: <1224688588-2665-2-git-send-email-viktor.rosendahl@nokia.com>
References: <1224688588-2665-1-git-send-email-viktor.rosendahl@nokia.com>
	<1224688588-2665-2-git-send-email-viktor.rosendahl@nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 18:16:28 +0300
Viktor Rosendahl <viktor.rosendahl@nokia.com> wrote:

> This used to work unpatched with older kernels, during the development phase
> of mtdoops. Before commit e3e8a75d2acfc61ebf25524666a0a2c6abb0620c a space was
> printed with console_loglevel set to 15, which probably flushed the oops
> message as a side effect.
> 
> This is another patch from the Nokia N810 kernel.
> 
> Signed-off-by: Viktor Rosendahl <viktor.rosendahl@nokia.com>
> ---
>  lib/bust_spinlocks.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/bust_spinlocks.c b/lib/bust_spinlocks.c
> index 486da62..9681d54 100644
> --- a/lib/bust_spinlocks.c
> +++ b/lib/bust_spinlocks.c
> @@ -12,6 +12,7 @@
>  #include <linux/tty.h>
>  #include <linux/wait.h>
>  #include <linux/vt_kern.h>
> +#include <linux/console.h>
>  
>  
>  void __attribute__((weak)) bust_spinlocks(int yes)
> @@ -22,6 +23,7 @@ void __attribute__((weak)) bust_spinlocks(int yes)
>  #ifdef CONFIG_VT
>  		unblank_screen();
>  #endif
> +		console_unblank();
>  		if (--oops_in_progress == 0)
>  			wake_up_klogd();
>  	}

That looks logical.  From my reading we can now remove that
unblank_screen(), because the console_unblank() will call
vt_console_driver.unblank() for us?

--- a/lib/bust_spinlocks.c~oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix
+++ a/lib/bust_spinlocks.c
@@ -11,7 +11,6 @@
 #include <linux/spinlock.h>
 #include <linux/tty.h>
 #include <linux/wait.h>
-#include <linux/vt_kern.h>
 #include <linux/console.h>
 
 
@@ -20,9 +19,6 @@ void __attribute__((weak)) bust_spinlock
 	if (yes) {
 		++oops_in_progress;
 	} else {
-#ifdef CONFIG_VT
-		unblank_screen();
-#endif
 		console_unblank();
 		if (--oops_in_progress == 0)
 			wake_up_klogd();
_

