Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbYENM4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbYENM4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbYENM4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:56:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:59268 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758685AbYENM4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:56:15 -0400
Date: Wed, 14 May 2008 14:56:13 +0200
From: Jan Kara <jack@suse.cz>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
       Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>
Subject: Re: [PATCH 1/4] jbd: strictly check for write errors on data
	buffers (rebased)
Message-ID: <20080514125613.GC24363@duck.suse.cz>
References: <482A6E00.6080303@hitachi.com> <482A6EE3.90901@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A6EE3.90901@hitachi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 14-05-08 13:47:31, Hidehiro Kawai wrote:
> Subject: [PATCH 1/4] jbd: strictly check for write errors on data buffers
> 
> In ordered mode, we should abort journaling when an I/O error has
> occurred on a file data buffer in the committing transaction.  But
> there can be data buffers which are not checked for error:
> 
>   (a) the buffer which has already been written out by pdflush
>   (b) the buffer which has been unlocked before scanned in the
>       t_locked_list loop
> 
> This patch adds missing error checks and aborts journaling
> appropriately.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitacih.com>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/jbd/commit.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.26-rc2/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/jbd/commit.c
> +++ linux-2.6.26-rc2/fs/jbd/commit.c
> @@ -172,7 +172,7 @@ static void journal_do_submit_data(struc
>  /*
>   *  Submit all the data buffers to disk
>   */
> -static void journal_submit_data_buffers(journal_t *journal,
> +static int journal_submit_data_buffers(journal_t *journal,
>  				transaction_t *commit_transaction)
>  {
>  	struct journal_head *jh;
> @@ -180,6 +180,7 @@ static void journal_submit_data_buffers(
>  	int locked;
>  	int bufs = 0;
>  	struct buffer_head **wbuf = journal->j_wbuf;
> +	int err = 0;
>  
>  	/*
>  	 * Whenever we unlock the journal and sleep, things can get added
> @@ -253,6 +254,8 @@ write_out_data:
>  			put_bh(bh);
>  		} else {
>  			BUFFER_TRACE(bh, "writeout complete: unfile");
> +			if (unlikely(!buffer_uptodate(bh)))
> +				err = -EIO;
>  			__journal_unfile_buffer(jh);
>  			jbd_unlock_bh_state(bh);
>  			if (locked)
> @@ -271,6 +274,8 @@ write_out_data:
>  	}
>  	spin_unlock(&journal->j_list_lock);
>  	journal_do_submit_data(wbuf, bufs);
> +
> +	return err;
>  }
>  
>  /*
> @@ -410,8 +415,7 @@ void journal_commit_transaction(journal_
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> -	err = 0;
> -	journal_submit_data_buffers(journal, commit_transaction);
> +	err = journal_submit_data_buffers(journal, commit_transaction);
>  
>  	/*
>  	 * Wait for all previously submitted IO to complete.
> @@ -426,10 +430,10 @@ void journal_commit_transaction(journal_
>  		if (buffer_locked(bh)) {
>  			spin_unlock(&journal->j_list_lock);
>  			wait_on_buffer(bh);
> -			if (unlikely(!buffer_uptodate(bh)))
> -				err = -EIO;
>  			spin_lock(&journal->j_list_lock);
>  		}
> +		if (unlikely(!buffer_uptodate(bh)))
> +			err = -EIO;
>  		if (!inverted_lock(journal, bh)) {
>  			put_bh(bh);
>  			spin_lock(&journal->j_list_lock);
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
