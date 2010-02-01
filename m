Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0BAVRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:17:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1721 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0BAVRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:17:13 -0500
Subject: Re: arch/arm/mach-omap2/mux.c: Off by one error
From: Joe Perches <joe@perches.com>
To: Tony Lindgren <tony@atomide.com>
Cc: d binderman <dcb314@hotmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100201210633.GC22747@atomide.com>
References: <BLU108-W14539E61D58BF455B82CA59C590@phx.gbl>
	 <20100201210633.GC22747@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 13:17:10 -0800
Message-ID: <1265059030.25140.349.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 13:06 -0800, Tony Lindgren wrote:
> * d binderman <dcb314@hotmail.com> [100131 04:14]:
> > I just ran the sourceforge tool cppcheck over the source code of the
> > new Linux kernel 2.6.33-rc6
> > 
> > It said
> > 
> > [./arm/mach-omap2/mux.c:492]: (error) Buffer access out-of-bounds
> > 
> > The source code is
> > 
> >         char mode[14];
> >         int i = -1;
> > 
> >         sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);
> > 13 characters + 1 digit + 1 zero byte is more than 14 characters.
> > Suggest new code
> >         char mode[15];
> diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
> index 32764be..047aa57 100644
> --- a/arch/arm/mach-omap2/mux.c
> +++ b/arch/arm/mach-omap2/mux.c
> @@ -486,7 +486,7 @@ int __init omap_mux_init_signal(char *muxname, int val)
>  static inline void omap_mux_decode(struct seq_file *s, u16 val)
>  {
>  	char *flags[OMAP_MUX_MAX_NR_FLAGS];
> -	char mode[14];
> +	char mode[15];

Maybe:

	char mode[sizeof("OMAP_MUX_MODE") + 1];
or
	char mode[OMAP_MUX_DEFNAME_LEN];

with the #define moved up a bit?

