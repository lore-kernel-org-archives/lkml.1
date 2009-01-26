Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZAZNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZAZNjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAZNjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:39:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54479 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZAZNjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:39:08 -0500
Date: Mon, 26 Jan 2009 14:38:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] audit: Fix compile time warning on kernel/auditsc.c
Message-ID: <20090126133854.GA18859@elte.hu>
References: <b9df5fa10901231150i1b9ea0f4n14d1cf60a9296a78@mail.gmail.com> <32272.1232853509@turing-police.cc.vt.edu> <b9df5fa10901242201h75f40e40ic27dfb089dd90fc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10901242201h75f40e40ic27dfb089dd90fc8@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On 1/25/09, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> >
> > Blech.  That's abuse of inline.  Can you find some other, more kernel-y
> >  way to address the issue?  (Possibly make it an actual inline up in a .h
> >  file, with a #ifdef wrapping around it, or do something matching what's
> >  done at the call site (apparently #ifdef'ing code is accepted in that .c
> >  file, adding another #ifdef around that function to match all the *other*
> >  '#ifdef CONFIG_AUDIT_TREE' would be less ugly than 'inline'.
> 
> Hi, Valdis. Thanks for your suggestions. Actually without inline-ing
> the warning doesn't resolves. So, as you said I moved
> audit_set_auditable function into kernel/audit.h, but not #ifdef
> wrapping around it rather #ifdef into it. Since wrapping #ifdef
> generates same warning few times more. Here is the patch. If I miss
> anything, then please notice.
> 
> -----
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/audit.h	2009-01-23 18:28:45.000000000 +0600
> +++ linux-2.6/kernel/audit.h	2009-01-25 11:50:22.520217272 +0600
> @@ -121,6 +121,16 @@ extern struct mutex audit_filter_mutex;
>  extern void audit_free_rule_rcu(struct rcu_head *);
>  extern struct list_head audit_filter_list[];
> 
> +static inline void audit_set_auditable(struct audit_context *ctx)
> +{
> +#ifdef CONFIG_AUDIT_TREE
> +	if (!ctx->prio) {
> +		ctx->prio = 1;
> +		ctx->current_state = AUDIT_RECORD_CONTEXT;
> +	}
> +#endif
> +}
> +
>  #ifdef CONFIG_AUDIT_TREE
>  extern struct audit_chunk *audit_tree_lookup(const struct inode *);
>  extern void audit_put_chunk(struct audit_chunk *);
> 
> ------
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/auditsc.c	2009-01-23 18:28:45.000000000 +0600
> +++ linux-2.6/kernel/auditsc.c	2009-01-25 11:50:25.712731936 +0600
> @@ -741,14 +741,6 @@ void audit_filter_inodes(struct task_str
>  	rcu_read_unlock();
>  }
> 
> -static void audit_set_auditable(struct audit_context *ctx)
> -{
> -	if (!ctx->prio) {
> -		ctx->prio = 1;
> -		ctx->current_state = AUDIT_RECORD_CONTEXT;
> -	}
> -}
> -

i dont see how this is an improvement in code quality. A non-oneliner 
function got inlined and an ugly #ifdef got added.

	Ingo
