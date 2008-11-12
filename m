Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYKLS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYKLS52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYKLS5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:57:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYKLS5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:57:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [arch/x86/vdso/vdso32-syms.lds] Error 1
In-Reply-To: Markus Trippelsdorf's message of  Friday, 7 November 2008 19:11:17 +0100 <20081107181117.GA29006@gentoox2.trippelsdorf.de>
References: <20081107181117.GA29006@gentoox2.trippelsdorf.de>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081112185617.4A1C71541FE@magilla.localdomain>
Date: Wed, 12 Nov 2008 10:56:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, I've been offline.

> All of a sudden I get the following error when I build the kernel:

Suddenly when?  What changed to make this start happening?
Is it recent kernel sources?  If so, can you git-bisect to
which change did it?  If not, did something else change in
your build environment that made this problem appear?
Does it come or go with some .config change?

> --- -   2008-11-07 18:51:36.392997346 +0100
> +++ arch/x86/vdso/vdso32-int80-syms.lds 2008-11-07 18:51:36.283820343 +0100
> @@ -3,5 +3,3 @@
>  VDSO32_sigreturn = 0x0400;
>  VDSO32_vsyscall = 0x0420;
>  VDSO32_vsyscall_eh_frame_size = 0x040;
> -VDSO32_vsyscall = 0x0420;
> -VDSO32_vsyscall_eh_frame_size = 0x040;
> make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
> make: *** [arch/x86/vdso] Error 2

That sure looks odd.  It looks like sort -u failed to uniquify those lines.

Can you try something like this:

> -	else rm -f $(@D)/.tmp_$(@F); exit 1; \
> +	else cat >&2 $(@D)/.tmp_$(@F); exit 1; \

and run make V=1 to see the full output on the failure?

> When I edit arch/x86/vdso/Makefile as follows,
> 
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index 4d6ef0a..8d93123 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -107,7 +107,7 @@ define cmd_vdso32sym
>  		     else sed /VDSO32_SYSENTER_RETURN/d $(@D)/.tmp_$(@F) | \
>  			  diff -u - $H; fi &&) : ;\
>  	then mv -f $(@D)/.tmp_$(@F) $@; \
> -	else rm -f $(@D)/.tmp_$(@F); exit 1; \
> +	else mv -f $(@D)/.tmp_$(@F) $@; \
>  	fi
>  endef

This is ignoring the wrongly failing check, not fixing it.

> A least one other person has hit the same problem already:
> http://bugzilla.kernel.org/show_bug.cgi?id=11739

That report doesn't have a lot of information and doesn't show output that
looks the same as yours.  I'm not sure it's the same issue at all.


Thanks,
Roland
