Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbZL1UR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbZL1UR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZL1UR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:17:26 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62631 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZL1UR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=om/5fgCZ7ao4gQcGqkTXvmbk4+IxYrGySNEATGY78YZgzpBKS0K337Ven8FzQuDbqW
         2tmr9VEiJQ6P7XP7RfMcoa/NOt04s1YYz7YEP4g6JQhJOuUizjLa3FribEgDtz8ybED2
         6EMFHknyn3IWI9zxXACRjxRjoL+zpaZlOTfVk=
Date: Mon, 28 Dec 2009 12:17:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Rolland <rol@as2917.net>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091228201720.GA4253@core.coreip.homeip.net>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
 <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
 <20091228094444.GG24690@elte.hu>
 <20091228120125.GA10911@elte.hu>
 <20091228160212.1f70d825@tux.DEF.witbe.net>
 <20091228175301.4e89aa65@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228175301.4e89aa65@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Dec 28, 2009 at 05:53:01PM +0100, Paul Rolland wrote:
> 
> Fixed this completely with the following two patches on top of 2.6.33-rc2 :
> 
> --- wmi.c.orig  2009-12-28 17:27:15.000000000 +0100
> +++ wmi.c       2009-12-28 17:39:01.000000000 +0100
> @@ -488,12 +488,13 @@
>  {
>         struct wmi_block *block;
>         acpi_status status;
> +       bool err;
>  
>         if (!guid || !handler)
>                 return AE_BAD_PARAMETER;
>  
> -       find_guid(guid, &block);
> -       if (!block)
> +       err = find_guid(guid, &block);
> +       if (!err)
>                 return AE_NOT_EXIST;
>  
>         if (block->handler)
> @@ -517,12 +518,13 @@
>  {
>         struct wmi_block *block;
>         acpi_status status;
> +       bool err;
>  
>         if (!guid)
>                 return AE_BAD_PARAMETER;
>  
> -       find_guid(guid, &block);
> -       if (!block)
> +       err = find_guid(guid, &block);
> +       if (!err)
>                 return AE_NOT_EXIST;
>  
>         if (!block->handler)
> 
> --- dell-wmi.c.orig     2009-12-28 17:49:09.000000000 +0100
> +++ dell-wmi.c  2009-12-28 17:41:36.000000000 +0100
> @@ -343,7 +343,7 @@
>                 printk(KERN_ERR
>                         "dell-wmi: Unable to register notify handler - %d\n",
>                         err);
> -               return err;
> +               return -err;

This still leaks AE_* error codes to the upper layers which do not care
for them and expect the errors from Exxxx namespace.

I wonder why wmi is not using standard error codes but instead decided
to come up with it's own.

-- 
Dmitry
