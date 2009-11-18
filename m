Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbZKRMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbZKRMbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZKRMbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:31:19 -0500
Received: from mail.parknet.jp ([210.171.162.6]:45189 "EHLO mail.officemail.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZKRMbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:31:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Andi Kleen <andi@firstfloor.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 19/20] ext2: Add ext2_sb_info s_lock spinlock
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
	<1258536293-7762-20-git-send-email-jblunck@suse.de>
Date: Wed, 18 Nov 2009 21:31:16 +0900
In-Reply-To: <1258536293-7762-20-git-send-email-jblunck@suse.de> (Jan Blunck's
	message of "Wed, 18 Nov 2009 10:24:52 +0100")
Message-ID: <87pr7g3tgr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck <jblunck@suse.de> writes:

> +static void ext2_sync_super(struct super_block *sb,
> +			    struct ext2_super_block *es)
>  {
> +	spin_lock(&EXT2_SB(sb)->s_lock);
>  	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
>  	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
>  	es->s_wtime = cpu_to_le32(get_seconds());
> +	/* unlock before we do IO */
> +	spin_unlock(&EXT2_SB(sb)->s_lock);
>  	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
>  	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
>  	sb->s_dirt = 0;

[...]

>  static int ext2_sync_fs(struct super_block *sb, int wait)
>  {
> -	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
> +	struct ext2_sb_info *sbi = EXT2_SB(sb);
> +	struct ext2_super_block *es = sbi->s_es;
>  
>  	lock_kernel();
> +	spin_lock(&sbi->s_lock);
>  	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
>  		ext2_debug("setting valid to 0\n");
>  		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
> @@ -1137,9 +1159,11 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
>  		es->s_free_inodes_count =
>  			cpu_to_le32(ext2_count_free_inodes(sb));
>  		es->s_mtime = cpu_to_le32(get_seconds());
> +		spin_unlock(&EXT2_SB(sb)->s_lock);
>  		ext2_sync_super(sb, es);
>  	} else {
>  		ext2_commit_super(sb, es);
> +		spin_unlock(&sbi->s_lock);
>  	}
>  	sb->s_dirt = 0;

[...]

> @@ -1237,6 +1264,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
>  		if (!ext2_setup_super (sb, es, 0))
>  			sb->s_flags &= ~MS_RDONLY;
>  	}
> +	spin_unlock(&EXT2_SB(sb)->s_lock);
>  	ext2_sync_super(sb, es);
>  	unlock_kernel();
>  	return 0;

ext2_setup_super() will call ext2_sync_fs(), so ->s_lock seems to be
recursive in here.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
