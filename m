Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbZHUNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbZHUNg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZHUNg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:36:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179AbZHUNg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:36:57 -0400
Date: Fri, 21 Aug 2009 15:35:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86: fix system die when load with "reservetop"
	parameter
Message-ID: <20090821133553.GE10263@elte.hu>
References: <4A8D402F.4080805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D402F.4080805@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> The system will die if the kernel is booted with "reservetop" 
> parameter, in present code, parse "reservetop" parameter after 
> early_ioremap_init(), and some function still use early_ioremap() 
> after it.

btw., what are you using the 'reservetop' boot option for?

> The problem is, "reservetop" parameter can modify 'FIXADDR_TOP', 
> then the virtual address got by early_ioremap() is base on old 
> 'FIXADDR_TOP', but the page mapping is base on new 'FIXADDR_TOP', 
> it will occur page fault, and the IDT is not prepare yet, so, the 
> system is dead.
> 
> So, put parse_early_param() in the front of early_ioremap_init() 
> in this patch.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kernel/setup.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

Does this bug trigger in 2.6.30 too?

I'm quite nervous about doing this change so late in the .31 cycle, 
we've got a hundred early parameters that now get executed much 
earlier than before. No way can i test all of them and others 
testing it (like in your case) takes time to trickle through.

So unless this is a .31 regression i'd be inclined to queue it up 
for .32.

	Ingo
