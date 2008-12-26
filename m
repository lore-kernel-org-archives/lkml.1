Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYLZRFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYLZRFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 12:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYLZRFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 12:05:12 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46057 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYLZRFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 12:05:11 -0500
Date: Fri, 26 Dec 2008 22:34:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081226170452.GC5100@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081226153318.GA4514@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-26 16:33:18]:

> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > * Sam Ravnborg <sam@ravnborg.org> [2008-12-26 11:27:16]:
> > 
> > > On Fri, Dec 26, 2008 at 02:05:47AM -0800, Yinghai Lu wrote:
> > > > Kamalesh Babulal wrote:
> > > > > * Yinghai Lu <yinghai@kernel.org> [2008-12-24 12:34:41]:
> > > > > 
> > > > >> --
> > > > > 
> > > > > After the applying the patch, the kernel panic's with the same backtrace. The
> > > > > box is running Fedora 5 on it.
> > > > > 
> > > > 
> > > > please try...
> > > > Ingo, do we need to switch to use #idef and inline function instead?
> > > 
> > > I recall David Howells had a similar issue with the bootparamter patch set.
> > > The workaround he used was to add a barrier(); call in the weak function
> > > to avoid the inline.
> > > 
> > > [full context kept as I added David to to: list].
> > > 	Sam
> > > 
> > 
> > Hi Yinghai,
> > 
> > 	Thanks, after applying the patch, the kernel boot's up fine.
> 
> how about the patch below, does that work too? (after removing Yinghai's 
> patch)
> 
> 	Ingo


Hi Ingo,

	Kernel crashes with the same trace, after the applying the patch.


> 
> ------------->
> From 0d41e654c877a0de441448ca2f63a72ed11c5d84 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 26 Dec 2008 14:39:51 +0100
> Subject: [PATCH] kbuild, sparseirq: work around GCC bug with __weak aliases
> 
> Impact: fix panic on null pointer with sparseirq
> 
> Certain versions of GCC inline the weak global functions.
> Work it around by marking __weak functions as noinline.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/compiler-gcc.h |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index 5c8351b..1ad72e6 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -41,11 +41,17 @@
> 
>  #define __deprecated			__attribute__((deprecated))
>  #define __packed			__attribute__((packed))
> -#define __weak				__attribute__((weak))
>  #define __naked				__attribute__((naked))
>  #define __noreturn			__attribute__((noreturn))
> 
>  /*
> + * Mark weak aliases also noinline, because some GCC versions
> + * incorrectly inline weak aliases (even when a non-weak variant
> + * is there) and thus cause crashes:
> + */
> +#define __weak				__attribute__((weak)) noinline
> +
> +/*
>   * From the GCC manual:
>   *
>   * Many functions have no effects except the return value and their
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
