Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYDKIxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYDKIxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbYDKIxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:53:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987AbYDKIw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:52:59 -0400
Subject: Re: [PATCH] xen: Enable Xen console by default in domU
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, Jeremy Fitzhardinge <jeremy@goop.org>,
       mingo@redhat.com
In-Reply-To: <87d4oxvhk0.fsf@pike.pond.sub.org>
References: <87hcehshyc.fsf@pike.pond.sub.org>
	 <87d4oxvhk0.fsf@pike.pond.sub.org>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 09:52:25 +0100
Message-Id: <1207903945.26445.4.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-10 at 17:46 +0200, Markus Armbruster wrote:
...
> Problem: when tty registers, we can't yet know whether the PVFB is
> enabled.  By the time we can know (xenstore is up), the console setup
> game is over.
> 
> Enable the Xen console hvc by default, and make it the preferred
> console.  Change the preferred console to tty when PVFB probes
> successfully, unless we've been given console kernel parameters.
...
> The previous version of this patch had the PVFB change the preferred
> console *always*.  That's wrong, because it blithely overwrites any
> preferred console the user might have set up with console kernel
> parameters.  Unfortunately, I couldn't see how to fix that cleanly
> without messing with printk.c.  If you can think of a better way, let
> me know.
...
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c

> @@ -358,6 +361,28 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
>  	return ret;
>  }
>  
> +static __devinit void
> +xenfb_make_preferred_console(void)
> +{
> +	struct console *c;
> +
> +	if (console_set_on_cmdline)
> +		return;
> +
> +	acquire_console_sem();
> +	for (c = console_drivers; c; c = c->next) {
> +		if (!strcmp(c->name, "tty") && c->index == 0)
> +			break;
> +	}

How about adding a new console flag so that e.g. you could do:

        if (!strcmp(c->name, "tty") && c->index == 0 &&
            !(c->flags & CON_SET_ON_CMDLINE))
                break;

> +	release_console_sem();
> +	if (c) {
> +		unregister_console(c);
> +		c->flags |= CON_CONSDEV;
> +		c->flags &= ~CON_PRINTBUFFER; /* don't print again */
> +		register_console(c);
> +	}
> +}
> +
...
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -107,6 +107,8 @@ struct console {
>  	struct	 console *next;
>  };
>  
> +extern int console_set_on_cmdline;
> +
>  extern int add_preferred_console(char *name, int idx, char *options);
>  extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
>  extern void register_console(struct console *);
> diff --git a/kernel/printk.c b/kernel/printk.c
> index c46a20a..c07bfc1 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -118,6 +118,7 @@ struct console_cmdline
>  static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
>  static int selected_console = -1;
>  static int preferred_console = -1;
> +int console_set_on_cmdline;
>  
>  /* Flag: console code may call schedule() */
>  static int console_may_schedule;
> @@ -829,6 +830,7 @@ static int __init console_setup(char *str)
>  	*s = 0;
>  
>  	add_preferred_console(buf, idx, options);
> +	console_set_on_cmdline = 1;
>  	return 1;
>  }
>  __setup("console=", console_setup);

