Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZJEMYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZJEMYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZJEMYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:24:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZJEMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:24:47 -0400
Date: Mon, 5 Oct 2009 14:24:09 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       sandeen@redhat.com
Subject: Re: [PATCH] ext3: Don't update superblock write time when
	filesystem is read-only
Message-ID: <20091005122409.GC8388@duck.suse.cz>
References: <1254625958-3588-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254625958-3588-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 03-10-09 23:12:38, Theodore Ts'o wrote:
> This avoids updating the superblock write time when we are mounting
> the root file system read/only but we need to replay the journal; at
> that point, for people who are east of GMT and who make their clock
> tick in localtime for Windows bug-for-bug compatibility, and this will
> cause e2fsck to complain and force a full file system check.
  Thanks, the patch is queued in my queue already. I just held it for a
while because Eric also had a valid point - maybe fsck is too strict when
it forces a full filesystem check just because the superblock write time is
in future? On a pc-class hw, clocks go often wrong. Even I remember setting
system clock on my desktop a few hours back because it just gets out of
sync and I don't run NTP...
  So I'm not against your patch because it can help in some cases and
it's not a big deal but I think a proper fix would be in fsck...

								Honza
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext3/super.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 72743d3..7a520a8 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2321,7 +2321,18 @@ static int ext3_commit_super(struct super_block *sb,
>  
>  	if (!sbh)
>  		return error;
> -	es->s_wtime = cpu_to_le32(get_seconds());
> +	/*
> +	 * If the file system is mounted read-only, don't update the
> +	 * superblock write time.  This avoids updating the superblock
> +	 * write time when we are mounting the root file system
> +	 * read/only but we need to replay the journal; at that point,
> +	 * for people who are east of GMT and who make their clock
> +	 * tick in localtime for Windows bug-for-bug compatibility,
> +	 * the clock is set in the future, and this will cause e2fsck
> +	 * to complain and force a full file system check.
> +	 */
> +	if (!(sb->s_flags & MS_RDONLY))
> +		es->s_wtime = cpu_to_le32(get_seconds());
>  	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
>  	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
>  	BUFFER_TRACE(sbh, "marking dirty");
> -- 
> 1.6.4.4.2.g31f8e.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
