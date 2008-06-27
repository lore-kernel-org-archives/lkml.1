Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbYF0Xyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbYF0Xyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbYF0Xyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:54:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52089 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696AbYF0Xyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:54:37 -0400
Subject: Re: [PATCH] ext4: Add missing unlock to an error path in
	ext4_quota_write()
From: Mingming Cao <cmm@us.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
In-Reply-To: <12144791441146-git-send-email-jack@suse.cz>
References: n <12144791432214-git-send-email-jack@suse.cz>
	 <12144791441146-git-send-email-jack@suse.cz>
Content-Type: text/plain
Organization: IBM
Date: Fri, 27 Jun 2008 16:54:34 -0700
Message-Id: <1214610874.6837.22.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 13:19 +0200, Jan Kara wrote:
> When write in ext4_quota_write() fails, we have to properly release
> i_mutex. One error path has been missing the unlock...
> 

Added to ext4 patch queue,

thanks
Mingming
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cb96f12..02bf243 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3337,8 +3337,10 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
>  		blk++;
>  	}
>  out:
> -	if (len == towrite)
> +	if (len == towrite) {
> +		mutex_unlock(&inode->i_mutex);
>  		return err;
> +	}
>  	if (inode->i_size < off+len-towrite) {
>  		i_size_write(inode, off+len-towrite);
>  		EXT4_I(inode)->i_disksize = inode->i_size;

