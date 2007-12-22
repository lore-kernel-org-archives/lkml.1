Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXLVEYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXLVEYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 23:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXLVEYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 23:24:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbXLVEYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 23:24:44 -0500
Date: Fri, 21 Dec 2007 20:22:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
Message-Id: <20071221202223.37b3c41c.akpm@linux-foundation.org>
In-Reply-To: <20071221205859.316759032@mvista.com>
References: <20071221205854.408865412@mvista.com>
	<20071221205859.316759032@mvista.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 00:00:04 -0800 Daniel Walker <dwalker@mvista.com> wrote:

> I converted the usu_init_notify semaphore to normal mutex usage, and it 
> should still prevent the request_module before the init routine is
> complete. Before it acted more like a complete, now the mutex protects
> two distinct section from running at the same time..
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  drivers/usb/storage/libusual.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6.23/drivers/usb/storage/libusual.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/usb/storage/libusual.c
> +++ linux-2.6.23/drivers/usb/storage/libusual.c
> @@ -9,6 +9,7 @@
>  #include <linux/usb_usual.h>
>  #include <linux/vmalloc.h>
>  #include <linux/kthread.h>
> +#include <linux/mutex.h>
>  
>  /*
>   */
> @@ -30,7 +31,7 @@ static atomic_t usu_bias = ATOMIC_INIT(U
>  #define BIAS_NAME_SIZE  (sizeof("usb-storage"))
>  static const char *bias_names[3] = { "none", "usb-storage", "ub" };
>  
> -static struct semaphore usu_init_notify;
> +static DEFINE_MUTEX(usu_probe_mutex);
>  static DECLARE_COMPLETION(usu_end_notify);
>  static atomic_t total_threads = ATOMIC_INIT(0);
>  
> @@ -178,10 +179,7 @@ static int usu_probe_thread(void *arg)
>  	int rc;
>  	unsigned long flags;
>  
> -	/* A completion does not work here because it's counted. */
> -	down(&usu_init_notify);
> -	up(&usu_init_notify);
> -
> +	mutex_lock(&usu_probe_mutex);
>  	rc = request_module(bias_names[type]);
>  	spin_lock_irqsave(&usu_lock, flags);
>  	if (rc == 0 && (st->fls & USU_MOD_FL_PRESENT) == 0) {
> @@ -194,6 +192,7 @@ static int usu_probe_thread(void *arg)
>  	}
>  	st->fls &= ~USU_MOD_FL_THREAD;
>  	spin_unlock_irqrestore(&usu_lock, flags);
> +	mutex_unlock(&usu_probe_mutex);
>  
>  	complete_and_exit(&usu_end_notify, 0);
>  }
> @@ -204,10 +203,9 @@ static int __init usb_usual_init(void)
>  {
>  	int rc;
>  
> -	sema_init(&usu_init_notify, 0);
> -
> +	mutex_lock(&usu_probe_mutex);
>  	rc = usb_register(&usu_driver);
> -	up(&usu_init_notify);
> +	mutex_unlock(&usu_probe_mutex);
>  	return rc;
>  }

That's some pretty hairy-looking code you're playing with there.  Has this
been runtime tested?

