Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbYAaTgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbYAaTgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYAaTfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:35:50 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45432 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYAaTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:35:48 -0500
Date: Thu, 31 Jan 2008 12:35:43 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] jbd: fix assertion failure in journal_next_log_block
In-reply-to: <20080131161417.GA29679@unused.rdu.redhat.com>
To: Josef Bacik <jbacik@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20080131193543.GS23836@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080131161417.GA29679@unused.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008  11:14 -0500, Josef Bacik wrote:
[snip excellent analysis]
> So you get into this situation where
> t_nr_buffers (the actual number of buffers that are on the transaction) is
> greater than the number of buffers accounted for via t_outstanding_credits.
> This presents a problem since as we loop through writting buffers to the
> journal, we decrement t_outstanding_credits, and if t_nr_buffers is more than
> t_outstanding_credits then we end up with a negative number for
> t_outstanding_credits
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>

Do you know what kernel this problem was introduced in, or is this a
long standing problem?  Presumably the same is needed for jbd2?

Once we have some decent amount of testing going on with ext4, I think
it makes sense to merge the jbd2 changes back into jbd and return to
a single code base, since there is nothing in the jbd2 code that ext3
can't also work with (i.e. all of the changes are properly isolated
with compatibility flags and such).

> @@ -1056,7 +1056,7 @@ static inline int jbd_space_needed(journal_t *journal)
>  	int nblocks = journal->j_max_transaction_buffers;
>  	if (journal->j_committing_transaction)
>  		nblocks += journal->j_committing_transaction->
> -					t_outstanding_credits;
> +					t_nr_buffers;

(trivial) this can be moved back onto the previous line.

> @@ -1168,7 +1168,7 @@ static inline int jbd_space_needed(journal_t *journal)
>  	int nblocks = journal->j_max_transaction_buffers;
>  	if (journal->j_committing_transaction)
>  		nblocks += journal->j_committing_transaction->
> -					t_outstanding_credits;
> +					t_nr_buffers;

Same...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

