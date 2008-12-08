Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbYLHWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbYLHWa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYLHWaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:30:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbYLHWaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:30:08 -0500
Date: Mon, 8 Dec 2008 14:30:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Duane Griffin" <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: Checking link targets are NULL-terminated
Message-Id: <20081208143003.9449bc77.akpm@linux-foundation.org>
In-Reply-To: <20081205144810.GA25585@dastardly.home.dghda.com>
References: <20081205144810.GA25585@dastardly.home.dghda.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 14:48:10 +0000
"Duane Griffin" <duaneg@dghda.com> wrote:

> Hi folks,
> 
> I am looking at a report of an intermittent BUG caused by an
> intentionally corrupted ext2 filesystem:
> http://bugzilla.kernel.org/show_bug.cgi?id=11412
> 
> What I think is happening is generic_readlink gets the name via
> i_ops->follow_link and passes it into vfs_readlink, without it
> necessarily being validating anywhere. If the name is not
> NULL-terminated the strlen call in vfs_readlink may run off past the end
> of the page. I think this is potentially happening in
> page_follow_link_light, as well as ext2_follow_link, so it isn't just
> ext* that is affected.
> 
> Does this sound correct, or have I missed something?
> 
> Assuming this is a real problem, does anyone have a better solution than
> scanning the name for a \0 (in ext2_follow_link and
> page_follow_link_light) and returning -ENAMETOOLONG if we can't find
> one? I.e. something like this:

It would be nice to fix this in a single place, for all filesystems,
for all time.  But how to do that?


> diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
> index 4e2426e..9b01af2 100644
> --- a/fs/ext2/symlink.c
> +++ b/fs/ext2/symlink.c
> @@ -24,8 +24,14 @@
>  static void *ext2_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct ext2_inode_info *ei = EXT2_I(dentry->d_inode);
> -	nd_set_link(nd, (char *)ei->i_data);
> -	return NULL;
> +	void *err = NULL;
> +
> +	if (memchr(ei->i_data, 0, sizeof(ei->i_data)) == NULL)
> +		err = ERR_PTR(-ENAMETOOLONG);
> +	else
> +		nd_set_link(nd, (char *)ei->i_data);
> +
> +	return err;
>  }

Perhaps nd_set_link() is a suitable place?  Change that function so
that it is passed a third argument (max_len) and then check that within
nd_set_link().  Change nd_set_link() to return a __must_check-marked
errno, change callers to handle errors appropriately.

Or something totally different ;)  But along those lines?


