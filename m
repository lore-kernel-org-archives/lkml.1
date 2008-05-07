Return-Path: <linux-kernel-owner+w=401wt.eu-S1763441AbYEGHYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763441AbYEGHYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYEGHX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:23:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376AbYEGHXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:23:55 -0400
Date: Wed, 7 May 2008 00:23:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
Message-Id: <20080507002345.831bc379.akpm@linux-foundation.org>
In-Reply-To: <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 May 2008 13:35:32 +0300 Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:

> Let file systems to writeback their pages and inodes when needed. This
> is needed for UBIFS budgeting sub-system because it has to force
> write-back from time to time.
> 
> Note, it cannot be called if one of the dirty pages is locked by
> the caller, otherwise it'll deadlock.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---
>  fs/fs-writeback.c         |    8 ++++++++
>  include/linux/writeback.h |    1 +
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 0655767..4591270 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -573,6 +573,14 @@ void sync_inodes_sb(struct super_block *sb, int wait)
>  	spin_unlock(&inode_lock);
>  }
>  
> +void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc)
> +{
> +	spin_lock(&inode_lock);
> +	sync_sb_inodes(sb, wbc);
> +	spin_unlock(&inode_lock);
> +}
> +EXPORT_SYMBOL_GPL(writeback_inodes_sb);
> +
>  /*
>   * Rather lame livelock avoidance.
>   */
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index b7b3362..0083a0a 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -71,6 +71,7 @@ struct writeback_control {
>  void writeback_inodes(struct writeback_control *wbc);
>  int inode_wait(void *);
>  void sync_inodes_sb(struct super_block *, int wait);
> +void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc);
>  void sync_inodes(int wait);
>  

This looks rather similar to
http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-sb_sync_inodes.patch

Which is best?


