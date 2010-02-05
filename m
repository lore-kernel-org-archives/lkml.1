Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0BEHNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:13:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab0BEHNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:13:11 -0500
Date: Fri, 5 Feb 2010 08:12:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 1/2] x86/alternatives: Fix build warning
Message-ID: <20100205071249.GB9320@elte.hu>
References: <20100205062427.3745.85746.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205062427.3745.85746.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Fixes below warnings.
> 
> ====
> FYI, there's this new build warning on x86 defconfig:
> 
> arch/x86/kernel/alternative.c: In function 'alternatives_text_reserved':
> arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
> arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
> arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
> arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
> 
> Caused by:
> 
> 2cfa197: ftrace/alternatives: Introducing *_text_reserved functions
> ====
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  arch/x86/kernel/alternative.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 3832fdc..99d9920 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -399,10 +399,10 @@ int alternatives_text_reserved(void *start, void *end)
>  	u8 **ptr;
>  
>  	list_for_each_entry(mod, &smp_alt_modules, next) {
> -		if (mod->text > end || mod->text_end < start)
> +		if (mod->text > (u8 *)end || mod->text_end < (u8 *)start)
>  			continue;
>  		for (ptr = mod->locks; ptr < mod->locks_end; ptr++)
> -			if (start <= *ptr && end >= *ptr)
> +			if ((u8 *)start <= *ptr && (u8 *)end >= *ptr)
>  				return 1;
>  	}

Such casts are a bit ugly and in general type casts are somewhat dangerous.

One possible solution would be to add intermediary local variables 
(text_start/text_end) with u8 * type and assign start/end to them - which can 
be done without a cast.

Thanks,

	Ingo
