Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYJZF3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYJZF3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 01:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYJZF3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 01:29:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:21390 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYJZF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 01:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ppayJsYRtpPq4QY3Up7IEGVy/FNtLkk93/bGwlYqQbtc6eAMjviuJDPnybZ2JE1V+s
         TKWGoBjzZQpKZxtL0w9dloI93pvcUtztTlWhwmnJ6RtqW53hXswbBL8oETN37fQPs7Xv
         rE0cB89KP2dUVFIFuYW7vhRXbTTWLB/yWGV28=
Date: Sun, 26 Oct 2008 08:32:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix allmodconfig breakage
Message-ID: <20081026053255.GA2702@x200.localdomain>
References: <20081025211107.GA20417@uranus.ravnborg.org> <20081026051234.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026051234.GN28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 05:12:34AM +0000, Al Viro wrote:
> 	If you use KCONFIG_ALLCONFIG (even with empty file) you get
> broken allmodconfig/allyesconfig; CONFIG_MODULES gets turned off,
> with obvious massive fallout.
> 
> 	Breakage had been introduced when conf_set_all_new_symbols()
> got used for allmodconfig et.al.
> 
> 	What happens is that sym_calc_value(modules_sym) done in
> conf_read_simple() sets SYMBOL_VALID on both modules_sym and MODULES.
> When we get to conf_set_all_new_symbols(), we set sym->def[S_DEF_USER]
> on everything, but it has no effect on sym->curr for the symbols that
> already have SYMBOL_VALID - these are stuck.
> 
> 	Solution: use sym_clear_all_valid() in there.  Note that it
> makes reevaluation of modules_sym redundant - sym_clear_all_valid()
> will do that itself.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=11512

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index b91cf24..830d9ea 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -852,8 +852,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
>  
>  	}
>  
> -	if (modules_sym)
> -		sym_calc_value(modules_sym);
> +	sym_clear_all_valid();
>  
>  	if (mode != def_random)
>  		return;
