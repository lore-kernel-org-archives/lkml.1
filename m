Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZDGB1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZDGB1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZDGB0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:26:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbZDGB0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:26:52 -0400
Date: Mon, 6 Apr 2009 18:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
Message-Id: <20090406182410.a7a13b6d.akpm@linux-foundation.org>
In-Reply-To: <1239067146.22733.260.camel@macbook.infradead.org>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
	<20090406175918.c38654b2.akpm@linux-foundation.org>
	<1239066583.22733.258.camel@macbook.infradead.org>
	<1239067146.22733.260.camel@macbook.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 18:19:06 -0700
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2009-04-06 at 18:09 -0700, David Woodhouse wrote:
> > 
> > I'm unconvinced by the fix -- can we find a way to fix the if() macro so
> > that normal (if fugly) C code like this doesn't doesn't need this kind
> > of workaround?
> 
> Something like this perhaps? I'd reformat it but dinner calls...
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 6faa7e5..1da2e72 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -114,7 +114,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>   * "Define 'is'", Bill Clinton
>   * "Define 'if'", Steven Rostedt
>   */
> -#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
> +#define if(cond, ...) if (__builtin_constant_p((cond, ## __VA_ARGS__)) ? !!(cond, ## __VA_ARGS__) : \
>  	({								\
>  		int ______r;						\
>  		static struct ftrace_branch_data			\
> @@ -125,7 +125,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  				.file = __FILE__,			\
>  				.line = __LINE__,			\
>  			};						\
> -		______r = !!(cond);					\
> +		______r = !!(cond, ## __VA_ARGS__);					\
>  		______f.miss_hit[______r]++;					\
>  		______r;						\
>  	}))

That would be better.  If it works, please send something Linuswards?
