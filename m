Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYKCXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYKCXBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 18:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYKCXBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 18:01:06 -0500
Received: from smtp1.riverbed.com ([206.169.144.12]:25088 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYKCXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 18:01:05 -0500
Date: Mon, 3 Nov 2008 15:01:04 -0800
From: Arthur Jones <ajones@riverbed.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       sandeen@redhat.com, linux-ext4@vger.kernel.org, sct@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Message-ID: <20081103230104.GC3371@ajones-laptop.nbttech.com>
References: <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103205854.GC30565@ajones-laptop.nbttech.com> <20081103131313.e9ae2f93.akpm@linux-foundation.org> <20081103211929.GA18117@mit.edu> <20081103132735.9e63a3d0.akpm@linux-foundation.org> <20081103220144.GD18117@mit.edu> <20081103142706.92e3a2ae.akpm@linux-foundation.org> <20081103225544.GH18117@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081103225544.GH18117@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, ...

On Mon, Nov 03, 2008 at 02:55:44PM -0800, Theodore Tso wrote:
> @@ -2922,15 +2919,15 @@ static void ext4_write_super(struct super_block *sb)
> 
>  static int ext4_sync_fs(struct super_block *sb, int wait)
>  {
> -       tid_t target;
> +       int ret;
> 
>         trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
>         sb->s_dirt = 0;
> -       if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
> -               if (wait)
> -                       jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
> -       }
> -       return 0;
> +       if (wait)
> +               ret = ext4_force_commit(sb);
> +       else
> +               ret = jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
> +       return ret;
>  }
> 
>  /*

Same problem as the last one, jbd2_journal_start_commit returns
true if it started a commit, not an error...

Arthur
