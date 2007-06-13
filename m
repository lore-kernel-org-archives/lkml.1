Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXFMPbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXFMPbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbXFMPax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:30:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:52448 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791AbXFMPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B3ggGtJDBKSj8yCIYkOh+rSVWlFPxXem/Amy2ITxRO9Un5/Y0NyfP3nyEkc5HTsGqRynOgUhWzJ0fgqp2iDdEvuf/EiDTMi2OzYLeHBu/wEjJ/Kx7RiN/uGJynDKt+C/nWJFy1BnyvA2Mmc4EBxD/fHsxJ3pO31Guj7qe4MN7TM=
Message-ID: <a781481a0706130830i7b363eacucd5ce9530c726b4f@mail.gmail.com>
Date: Wed, 13 Jun 2007 21:00:51 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 2/7] support multiple logging
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <466FC681.5060501@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC681.5060501@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On 6/13/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:

> +struct netconsole_target {
> +       struct list_head list;
> +       int id;
> +       struct netpoll np;
> +};
> +
> +static LIST_HEAD(target_list);
> +static DEFINE_SPINLOCK(target_list_lock);

Some description of the struct netconsole_target / target_list
would be nice. For instance, here I tried to read from the code
what the "int id" member is all about, but noticed that it is
only being set during add_target(), and never read / used
anywhere else later. You should just remove it, then.

> +       if (netpoll_setup(&new_target->np)) {
> +               printk(KERN_ERR "netconsole: can't setup netpoll:%s\n",
> +                      target_config);
> +               kfree(new_target);
> +               retval = -EINVAL;

Please prefer something like "err = netpoll_setup(...);"
and then "if (err) { printk(); kfree(); return err; }" here.

netpoll_setup() returns perfectly reasonable error codes,
we must be returning the same back up.

> +#ifndef MODULE
>  static int __init option_setup(char *opt)
>  {
> -       configured = !netpoll_parse_options(&np, opt);
> +       strncpy(config, opt, 256);

strlcpy would be safer than strncpy here, IMHO.

> -static int __init init_netconsole(void)
> +static void cleanup_netconsole(void)
>  {
> -       int err;
> +#ifdef CONFIG_NETCONSOLE_DYNCON
> +       struct netconsole_target *nt, *tmp;
>
> -       if(strlen(config))
> -               option_setup(config);
> +       unregister_console(&netconsole);

> +       list_for_each_entry_safe(nt, tmp, &target_list, list)
> +               remove_target(nt);

You should be doing the spin_lock_irqsave() and
spin_unlock_irqrestore() around this code here,
and lose it from the remove_target() ...

> +static int __init init_netconsole(void)
> +{
> +       char *tmp = config;
> +#ifdef CONFIG_NETCONSOLE_DYNCON
> +       char *p;
> +
> +       register_console(&netconsole);

register_console() needs to be _after_ netpoll_setup().

> +       if (!strlen(config)) {
> +               printk(KERN_ERR "netconsole: not configured\n");
>                 return 0;
>         }

You could move this out of the #ifdef. It's applicable to both
DYNCON and !DYNCON cases.

> -       err = netpoll_setup(&np);
> -       if (err)
> -               return err;
> -
> +       while ((p = strsep(&tmp, ";")) != NULL)
> +               if (add_target(p)) {
> +                       printk(KERN_ERR
> +                              "netconsole: can't add target to netconsole\n");
> +                       cleanup_netconsole();
> +                       return -EINVAL;
> +               }
> +#else
> +       if (!strlen(config) ||
> +           netpoll_parse_options(&np, tmp) || netpoll_setup(&np)) {

Joining these 3 expressions (statements, actually) together
is so gross :-)
Please do them separately, like the previous code did. That way
you could preserve the error code from netpoll_setup() too ...

Satyam
