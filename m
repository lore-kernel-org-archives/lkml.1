Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZFEMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZFEMOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZFEMOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:14:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:54793 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbZFEMOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:14:08 -0400
Date: Fri, 05 Jun 2009 21:04:10 +0900 (JST)
Message-Id: <20090605.210410.112169966.ryusuke@osrg.net>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: viro@zeniv.linux.org.uk, Artem.Bityutskiy@nokia.com,
       konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       hch@infradead.org, linux-fsdevel@vger.kernel.org, users@nilfs.org
Subject: Re: [PATCH v2.1 11/17] NILFS: do not manipulate s_dirt directly
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1244207155-2092-12-git-send-email-dedekind@infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
	<1244207155-2092-12-git-send-email-dedekind@infradead.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 05 Jun 2009 21:04:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Jun 2009 16:05:49 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> ... use new VFS helpers instead.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: users@nilfs.org
> Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

> ---
>  fs/nilfs2/segment.c   |    2 +-
>  fs/nilfs2/super.c     |   18 +++++++++---------
>  fs/nilfs2/the_nilfs.c |    2 +-
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index fb70ec3..0dcac79 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2069,7 +2069,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
>  	if (update_sr) {
>  		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
>  				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
> -		sbi->s_super->s_dirt = 1;
> +		mark_sb_dirty(sbi->s_super);
>  
>  		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
>  		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 7262e84..6f3707b 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -307,7 +307,7 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
>  		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
>  		nilfs->ns_sbwtime[1] = t;
>  	}
> -	sbi->s_super->s_dirt = 0;
> +	mark_sb_clean(sbi->s_super);
>  	return nilfs_sync_super(sbi, dupsb);
>  }
>  
> @@ -318,7 +318,7 @@ static void nilfs_put_super(struct super_block *sb)
>  
>  	lock_kernel();
>  
> -	if (sb->s_dirt)
> +	if (is_sb_dirty(sb))
>  		nilfs_write_super(sb);
>  
>  	nilfs_detach_segment_constructor(sbi);
> @@ -344,17 +344,17 @@ static void nilfs_put_super(struct super_block *sb)
>   * @sb: super_block
>   *
>   * nilfs_write_super() gets a fs-dependent lock, writes super block(s), and
> - * clears s_dirt.  This function is called in the section protected by
> - * lock_super().
> + * clears the superblock.  This function is called in the section protected
> + * by lock_super().
>   *
> - * The s_dirt flag is managed by each filesystem and we protect it by ns_sem
> - * of the struct the_nilfs.  Lock order must be as follows:
> + * The super block s_dirt flag is managed by each filesystem and we protect
> + * it by ns_sem of the struct the_nilfs.  Lock order must be as follows:
>   *
>   *   1. lock_super()
>   *   2.    down_write(&nilfs->ns_sem)
>   *
> - * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
> - * of the super block (nilfs->ns_sbp[]).
> + * Inside NILFS, locking ns_sem is enough to protect the super block s_dirt
> + * and the buffer of the super block (nilfs->ns_sbp[]).
>   *
>   * In most cases, VFS functions call lock_super() before calling these
>   * methods.  So we must be careful not to bring on deadlocks when using
> @@ -383,7 +383,7 @@ static void nilfs_write_super(struct super_block *sb)
>  		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
>  		nilfs_commit_super(sbi, dupsb);
>  	}
> -	sb->s_dirt = 0;
> +	mark_sb_clean(sb);
>  	up_write(&nilfs->ns_sem);
>  }
>  
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 7f65b3b..5b02f50 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -278,7 +278,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
>  			goto failed;
>  		}
>  		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
> -			sbi->s_super->s_dirt = 1;
> +			mark_sb_dirty(sbi->s_super);
>  	}
>  
>  	set_nilfs_loaded(nilfs);
> -- 
> 1.6.0.6
