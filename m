Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZI2VHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZI2VHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI2VHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:07:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbZI2VHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:07:04 -0400
Date: Tue, 29 Sep 2009 14:07:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: linux-kernel@vger.kernel.org, bernhard@bwalle.de
Subject: Re: [PATCH] Always print panic message on current console
Message-Id: <20090929140701.540f978b.akpm@linux-foundation.org>
In-Reply-To: <1254055014-4441-1-git-send-email-bernhard@bwalle.de>
References: <1254055014-4441-1-git-send-email-bernhard@bwalle.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 14:36:54 +0200
Bernhard Walle <bernhard@bwalle.de> wrote:

> The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
> redirect the kernel messages to a specific console.
> 
> However, since it's not possible to switch to the kernel message console after
> a panic(), it would be nice if the kernel would print the panic message on the
> current console.
> 
> 
> Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
> ---
>  kernel/panic.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index bcdef26..f9950e3 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -22,6 +22,7 @@
>  #include <linux/init.h>
>  #include <linux/nmi.h>
>  #include <linux/dmi.h>
> +#include <linux/tty.h>

It's odd that kmsg_redirect is declared in tty.h when it's purely a
vt.c thing.  Why not vt.h?

>  int panic_on_oops;
>  static unsigned long tainted_mask;
> @@ -65,6 +66,9 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	 */
>  	preempt_disable();
>  
> +	/* don't redirect the panic message to some hidden console */
> +	kmsg_redirect = 0;
> +
>  	bust_spinlocks(1);
>  	va_start(args, fmt);
>  	vsnprintf(buf, sizeof(buf), fmt, args);

Methinks CONFIG_HW_CONSOLE=n kernels won't link after making this
change.

I'd suggest something like

#ifdef CONFIG_HW_CONSOLE
extern void vt_set_kmsg_redirect(int vt);
#else
static inline void vt_set_kmsg_redirect(int vt)
{
}
#endif


Another possible way of doing this would be for vt.c to hook itself
into panic_notifier_list.  That's nice and clean from a
separation-of-subsystems POV but isn't really conceptually correct - it
assumes that other entries on panic_notifier_list don't print messages
to the console.


