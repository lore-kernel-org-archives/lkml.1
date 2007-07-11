Return-Path: <linux-kernel-owner+w=401wt.eu-S1765892AbXGKRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765892AbXGKRzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXGKRzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:55:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617AbXGKRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:55:38 -0400
Message-ID: <46951992.8040700@redhat.com>
Date: Wed, 11 Jul 2007 13:55:30 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kirill Korotaev <dev@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: Lost JBD fix
References: <20070709181443.GF30433@duck.suse.cz>
In-Reply-To: <20070709181443.GF30433@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2007 02:14 PM, Jan Kara wrote:
>   Hi Andrew,
> 
>   it seems we've accidentally lost one JBD fix (probably it was my mistake
> when rediffing some checkpointing changes) as Kirill has noted. A transaction
> can currently be released when there are still some buffers on one of its
> checkpointing lists. Attached patch should fix it (it still seems to apply
> fine). Please apply it. Thanks.
> 
> 								Honza
> 
> 
> ------------------------------------------------------------------------
> 
> We have to check that also the second checkpoint list is non-empty before
> dropping the transaction.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> diff -rupX /home/jack/.kerndiffexclude linux-2.6.16-rc1/fs/jbd/commit.c linux-2.6.16-rc1-1-checkpoint-fix/fs/jbd/commit.c
> --- linux-2.6.16-rc1/fs/jbd/commit.c	2006-01-15 00:20:12.000000000 +0100
> +++ linux-2.6.16-rc1-1-checkpoint-fix/fs/jbd/commit.c	2006-01-17 23:35:19.000000000 +0100
> @@ -829,7 +829,8 @@ restart_loop:
>  	journal->j_committing_transaction = NULL;
>  	spin_unlock(&journal->j_state_lock);
>  
> -	if (commit_transaction->t_checkpoint_list == NULL) {
> +	if (commit_transaction->t_checkpoint_list == NULL &&
> +	    commit_transaction->t_checkpoint_io_list == NULL) {
>  		__journal_drop_transaction(journal, commit_transaction);
>  	} else {
>  		if (journal->j_checkpoint_transactions == NULL) {

Critical bugfix -- 2.6.22-stable (no earlier versions) should get
this too, right?

If so, can we get this merged into 2.6.23-rc soon?
