Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbYENNP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbYENNP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYENNPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:15:09 -0400
Received: from styx.suse.cz ([82.119.242.94]:60138 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbYENNPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:15:08 -0400
Date: Wed, 14 May 2008 15:15:06 +0200
From: Jan Kara <jack@suse.cz>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
       Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>
Subject: Re: [PATCH 3/4] jbd: abort when failed to log metadata buffers
	(rebased)
Message-ID: <20080514131505.GE24363@duck.suse.cz>
References: <482A6E00.6080303@hitachi.com> <482A6F6F.20002@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A6F6F.20002@hitachi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-05-08 13:49:51, Hidehiro Kawai wrote:
> Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers
> 
> If we failed to write metadata buffers to the journal space and
> succeeded to write the commit record, stale data can be written
> back to the filesystem as metadata in the recovery phase.
> 
> To avoid this, when we failed to write out metadata buffers,
> abort the journal before writing the commit record.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  fs/jbd/commit.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.26-rc2/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/jbd/commit.c
> +++ linux-2.6.26-rc2/fs/jbd/commit.c
> @@ -703,6 +703,9 @@ wait_for_iobuf:
>  		__brelse(bh);
>  	}
>  
> +	if (err)
> +		journal_abort(journal, err);
> +
>  	J_ASSERT (commit_transaction->t_shadow_list == NULL);
  Shouldn't this rather be further just before
journal_write_commit_record()? We should abort also if writing revoke
records etc. failed, shouldn't we?

>  	jbd_debug(3, "JBD: commit phase 5\n");
> 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
