Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbZHZBTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbZHZBTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932737AbZHZBTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:19:22 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:27135 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbZHZBTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:19:21 -0400
Date: Tue, 25 Aug 2009 17:26:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Anirban Sinha" <ASinha@zeugmasystems.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] console_print: change the function api to make it have
 printk style interface
Message-Id: <20090825172640.af8b9f58.randy.dunlap@oracle.com>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A948D70.0106:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 16:47:49 -0700 Anirban Sinha wrote:

> Hi Folks:
> 
> I bumped into this function in printk.c a while back. As I started using
> it, I wondered if we could enhance it with printk style interface that
> could make it somewhat more useful. 
> 
> One straightforward thing to do here would perhaps be to define this as
> a macro. Something like this:
> 
> #define console_print(fmt,msg...) printk(KERN_EMERG fmt,##msg)
> 
> However, there might be some important reason why this was not done. I
> do not know. 
> Anyway, keeping the existing code of using a proper C function and
> exporting the symbol, here's a patch that enhances the function to use
> prink style interface. To the best of my knowledge, I do not think it
> will break existing code that uses this function. I did a grep through
> the kernel code and didn't look like this call was used in lot of other
> places. I have also built the kernel locally with this change and looks
> like at least for mips, it does not break our build.
> 
> CCing Linus for his opinion.
> 
> Cheers,
> 
> Ani
> 
> 
> Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
> ---
>  drivers/char/serial167.c |    2 +-
>  include/linux/tty.h      |    2 +-
>  kernel/printk.c          |   14 ++++++++++++--
>  3 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
> index 51e7a46..029aa0d 100644
> --- a/drivers/char/serial167.c
> +++ b/drivers/char/serial167.c
> @@ -171,7 +171,7 @@ static int startup(struct cyclades_port *);
>  static void cy_throttle(struct tty_struct *);
>  static void cy_unthrottle(struct tty_struct *);
>  static void config_setup(struct cyclades_port *);
> -extern void console_print(const char *);
> +extern int console_print(const char *, ...);

Drop that.  Add
#include <linux/tty.h>
if it's not already #included.


>  #ifdef CYCLOM_SHOW_STATUS
>  static void show_status(int);
>  #endif
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index e8c6c91..eb3e4fe 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -519,7 +519,7 @@ extern int pcxe_open(struct tty_struct *tty, struct
> file *filp);
>  
>  /* printk.c */
>  
> -extern void console_print(const char *);
> +extern int console_print(const char *, ...);

Make that prototype be like printk, with the __attribute__ ((format (printf, 1, 2))):


int printk(const char * fmt, ...)
	__attribute__ ((format (printf, 1, 2)));


>  
>  /* vt.c */
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index b4d97b5..729b0ff 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1060,9 +1060,19 @@ void __sched console_conditional_schedule(void)
>  }
>  EXPORT_SYMBOL(console_conditional_schedule);
>  
> -void console_print(const char *s)
> +int console_print(const char *fmt, ...)
>  {
> -	printk(KERN_EMERG "%s", s);
> +	va_list args;
> +	int r;
> +	char _fmt[1024] = KERN_EMERG;
> +
> +	strncat(_fmt, fmt,sizeof(_fmt)- sizeof(KERN_EMERG));
> +
> +	va_start(args, fmt);
> +	r = vprintk(_fmt, args);
> +	va_end(args);
> +
> +	return r;
>  }
>  EXPORT_SYMBOL(console_print);
>  
> -- 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
