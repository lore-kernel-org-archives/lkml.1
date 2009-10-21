Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZJUPyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZJUPyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZJUPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbZJUPyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:54:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 3/5] cfq-iosched: reimplement priorities using different service trees
References: <200910202012.12007.czoccolo@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Oct 2009 11:54:05 -0400
In-Reply-To: <200910202012.12007.czoccolo@gmail.com> (Corrado Zoccolo's
	message of "Tue, 20 Oct 2009 20:12:11 +0200")
Message-ID: <x49eiow9202.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> We use different service trees for different priority classes.
> This allows a simplification in the service tree insertion code, that no
> longer has to consider priority while walking the tree.

This is kind of funny, considering things used to be divied up into
lists by class and priority.

> + * Index in the service_trees.
> + * IDLE is handled separately, so it has negative index
> + */
> +enum wl_prio_t {
> +	IDLE_WORKLOAD = -1,
> +	BE_WORKLOAD = 0,
> +	RT_WORKLOAD = 1
> +};

What's wrong with IOPRIO_CLASS_(RT|BE|IDLE)?  Why invent another enum?

> +
> +/*
>   * Per block device queue structure
>   */
>  struct cfq_data {
[...]
> +	struct cfq_rb_root service_trees[2];
> +	struct cfq_rb_root service_tree_idle;

Why separate out the idle service tree from the others?

> +static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
> +					    struct cfq_data *cfqd)
> +{
> +	if (prio == IDLE_WORKLOAD)
> +		return &cfqd->service_tree_idle;
> +
> +	return &cfqd->service_trees[prio];
> +}

This should just turn into cfqd->service_trees[IOPRIO_CLASS_*] in the
callers.

[...]

>  /*
> @@ -1106,6 +1134,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>  	if (cfq_cfqq_coop(cfqq))
>  		return NULL;
>  
> +	/* we don't want to mix processes with different characteristics */
> +	if (cfqq->service_tree != cur_cfqq->service_tree)
> +		return NULL;
> +

Hmm, that looks like a current bug in the close cooperator code.  It
shouldn't allow cooperation between differring scheduling classes.

Cheers,
Jeff
