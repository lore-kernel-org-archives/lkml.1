Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab0CMMzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:55:48 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:55283 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab0CMMzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:55:46 -0500
Date: Sat, 13 Mar 2010 07:53:59 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Philippe De Muyter <phdm@macqel.be>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kobjects] Fix a rare memory leak in
 kobject_set_name_vargs
In-Reply-To: <20100313124324.GA15244@frolo.macqel>
Message-ID: <alpine.LFD.2.00.1003130752001.8523@localhost>
References: <20100313124324.GA15244@frolo.macqel>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010, Philippe De Muyter wrote:

> Hello Greg,
>
> This is a possible memory leak that I discovered only by accidental code
> reading.
>
> --
>
> If kvasprintf fails in kobject_set_name_vargs, the memory used by
> the original kobj->name is leaked.  Fix that.  I also avoid useless
> memory accesses to kobj->name by using the local variables old_name
> and new_name instead.
>
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>
> diff -r 373fdd3df333 linux-2.6.x/lib/kobject.c
> --- a/linux-2.6.x/lib/kobject.c	Wed Aug 19 23:26:44 2009 +0200
> +++ b/linux-2.6.x/lib/kobject.c	Sat Mar 13 13:35:43 2010 +0100
> @@ -216,20 +216,22 @@ int kobject_set_name_vargs(struct kobjec
>  				  va_list vargs)
>  {
>  	const char *old_name = kobj->name;
> +	char *new_name;
>  	char *s;
>
> -	if (kobj->name && !fmt)
> +	if (old_name && !fmt)
>  		return 0;
>
> -	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> -	if (!kobj->name)
> +	new_name = kvasprintf(GFP_KERNEL, fmt, vargs);
> +	if (!new_name)
>  		return -ENOMEM;
>
>  	/* ewww... some of these buggers have '/' in the name ... */
> -	while ((s = strchr(kobj->name, '/')))
> +	while ((s = strchr(new_name, '/')))
>  		s[0] = '!';
>
>  	kfree(old_name);
> +	kobj->name = new_name;
>  	return 0;
>  }

  the routine kobject_set_name_vargs() is described in
Documentation/kobject.txt as "legacy cruft" to be removed at some
point, so it's not clear there's any value in "fixing" it.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
