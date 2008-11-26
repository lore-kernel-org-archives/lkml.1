Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYKZHZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYKZHZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYKZHZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:25:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYKZHZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:25:10 -0500
Date: Wed, 26 Nov 2008 08:24:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print
	oops dumps
Message-ID: <20081126072445.GG26036@elte.hu>
References: <20081123130042.1d194768@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123130042.1d194768@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> From 57b0deb1ad706a94e3118baee4127676f465c4ab Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 5 Nov 2008 19:00:36 -0800
> Subject: [PATCH] scripts: script from kerneloops.org to pretty print oops dumps
> 
> We're strugling all the time to figure out where the code came from
> that oopsed.. The script below (a adaption from a script used by kerneloops.org)
> can help developers quite a bit, at least for non-module cases.
> 
> It works and looks like this:
> 
> [/home/arjan/linux]$ dmesg | perl scripts/markup_oops.pl vmlinux
>  {
>  	struct agp_memory *memory;
> 
>  	memory = agp_allocate_memory(agp_bridge, pg_count, type);
>  c055c10f:	89 c2                	mov    %eax,%edx
>  	if (memory == NULL)
>  c055c111:	74 19                	je     c055c12c <agp_allocate_memory_wrap+0x30>
>  /* This function must only be called when current_controller != NULL */
>  static void agp_insert_into_pool(struct agp_memory * temp)
>  {
>  	struct agp_memory *prev;
> 
>  	prev = agp_fe.current_controller->pool;
>  c055c113:	a1 ec dc 8f c0       	mov    0xc08fdcec,%eax
> *c055c118:	8b 40 10             	mov    0x10(%eax),%eax     <----- faulting instruction
> 
>  	if (prev != NULL) {
>  c055c11b:	85 c0                	test   %eax,%eax
>  c055c11d:	74 05                	je     c055c124 <agp_allocate_memory_wrap+0x28>
>  		prev->prev = temp;
>  c055c11f:	89 50 04             	mov    %edx,0x4(%eax)
>  		temp->next = prev;
>  c055c122:	89 02                	mov    %eax,(%edx)
>  	}
>  	agp_fe.current_controller->pool = temp;
>  c055c124:	a1 ec dc 8f c0       	mov    0xc08fdcec,%eax
>  c055c129:	89 50 10             	mov    %edx,0x10(%eax)
>  	if (memory == NULL)
>  		return NULL;
> 
>  	agp_insert_into_pool(memory);
> 
> so in this case, we faulted while dereferencing agp_fe.current_controller pointer, and we get to see
> exactly which function and line it affects... Personally I find this very useful, and I can
> see value for having this script in the kernel for more-than-just-me to use.
> 
> Caveats:
> * It only works for oopses not-in-modules
> * It only works nicely for kernels compiled with CONFIG_DEBUG_INFO
> * It's not very fast.
> * It only works on x86
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  scripts/markup_oops.pl |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 162 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/markup_oops.pl

looks useful - Andrew, Sam, any objections to this?

	Ingo
