Return-Path: <linux-kernel-owner+w=401wt.eu-S936353AbYBWIRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936353AbYBWIRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761989AbYBWIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:15 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765740AbYBWIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:54 -0500
Date: Sat, 23 Feb 2008 00:04:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH2] Basic braille screen reader support
Message-Id: <20080223000410.674ce674.akpm@linux-foundation.org>
In-Reply-To: <20080222002822.GB32480@implementation>
References: <20080204031842.GE4439@implementation>
	<20080205220054.GD4394@implementation>
	<20080205165853.561d5f3d.akpm@linux-foundation.org>
	<20080206020423.GG4394@implementation>
	<20080222002822.GB32480@implementation>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 01:28:22 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Samuel Thibault, le Wed 06 Feb 2008 02:04:23 +0000, a __crit :
> > Andrew Morton, le Tue 05 Feb 2008 16:58:53 -0800, a __crit :
> > > On Tue, 5 Feb 2008 22:00:54 +0000
> > > Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > > > +	serial8250_console.write(braille_co, data, c - data);
> > > 
> > > hm.  Is it appropriate that this driver wire itself directly into
> > > serial8250?
> > > What if the screen reader is attached to some other sort of
> > > uart, or a terminal server, or...
> > 
> > Indeed that's an issue.  For now, there is no clean way to attach to the
> > early serial drivers, that's why I chose 8250,
> 
> In the patch below, I hook into kernel/printk.c's console= parser, which
> now gives me attachment to any kind of console.
> 
> 
> 
> 
> This adds a minimalistic braille screen reader support.
> This is meant to be used by blind people e.g. on boot failures or when /
> cannot be mounted etc and thus the userland screen readers can not work.
> 

Sorry, but I can't say that this is my favoritest ever patch.  But I can't
immediately think of any way of significantly improving it :( Jiri and
Dmitry appear to be hiding.

> +++ linux-2.6.24.1-perso/kernel/printk.c	2008-02-21 12:09:06.000000000 +0100
> @@ -105,6 +105,7 @@

Please use `diff -p'

>  	char	name[8];			/* Name of the driver	    */
>  	int	index;				/* Minor dev. to use	    */
>  	char	*options;			/* Options for the driver   */
> +	char	*brl_options;			/* Options for braille driver */
>  };

Should this depend on CONFIG_A11Y_BRAILLE_CONSOLE or whatever?

>  #define MAX_CMDLINECONSOLES 8
> @@ -766,15 +767,59 @@
>  
>  #endif
>  
> +static int __add_preferred_console(char *name, int idx, char *options,
> +				   char *brl_options)
> +{
> +	struct console_cmdline *c;
> +	int i;
> +
> +	/*
> +	 *	See if this tty is not yet registered, and
> +	 *	if we have a slot free.
> +	 */
> +	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
> +		if (strcmp(console_cmdline[i].name, name) == 0 &&
> +			  console_cmdline[i].index == idx) {
> +				if (!brl_options)
> +					selected_console = i;
> +				return 0;
> +		}
> +	if (i == MAX_CMDLINECONSOLES)
> +		return -E2BIG;

Does the array of consles have any locking here?

> +	if (!brl_options)
> +		selected_console = i;
> +	c = &console_cmdline[i];
> +	memcpy(c->name, name, sizeof(c->name));
> +	c->name[sizeof(c->name) - 1] = 0;

strlcpy()?

> +	c->options = options;
> +	c->brl_options = brl_options;
> +	c->index = idx;
> +	return 0;
> +}
>  /*
>   * Set up a list of consoles.  Called from init/main.c
>   */
>  static int __init console_setup(char *str)
>  {
>  	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
> -	char *s, *options;
> +	char *s, *options, *brl_options = NULL;
>  	int idx;
>  
> +#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> +	if (!memcmp(str, "brl,", 4)) {
> +		brl_options = "";
> +		str += 4;
> +	} else if (!memcmp(str, "brl=", 4)) {
> +		brl_options = str + 4;
> +		str = strchr(brl_options, ',');
> +		if (!str) {
> +			printk(KERN_ERR "need port name after brl=\n");
> +			return 1;
> +		}
> +		*(str++) = 0;
> +	}
> +#endif

Update Documentation/kernel-parameters.txt, please.  And additional
documentation would be nice, if justified?

>  	/*
>  	 * Decode str into name, index, options.
>  	 */
> @@ -799,7 +844,7 @@
>  	idx = simple_strtoul(s, NULL, 10);
>  	*s = 0;
>  
> -	add_preferred_console(buf, idx, options);
> +	__add_preferred_console(buf, idx, options, brl_options);
>  	return 1;
>  }
>
> ...
>
> +static void beep(unsigned int freq)
> +{
> +	if (sound)
> +		kd_mksound(freq, HZ/10);
> +}

hm, do we have enough Kconfig dependencies here to ensure that kd_mksound()
is always available?


