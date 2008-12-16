Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYLPBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYLPBMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYLPBMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:12:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40475 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYLPBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:12:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 3/3] fsnotify: use the new open-exec hook for inotify and dnotify
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <20081215164419.2018.11097.stgit@paris.rdu.redhat.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com> <20081215164419.2018.11097.stgit@paris.rdu.redhat.com>
Message-Id: <20081216100418.06CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 10:12:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index 88265dd..a7122c6 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -170,6 +170,12 @@ static inline void fsnotify_modify(struct dentry *dentry)
>   */
>  static inline void fsnotify_open_exec(struct file *file)
>  {
> +	struct dentry *dentry = file->f_path.dentry;
> +	struct inode *inode = dentry->d_inode;
> +
> +	dnotify_parent(dentry, DN_ACCESS);
> +	inotify_dentry_parent_queue_event(dentry, IN_ACCESS, 0, dentry->d_name.name);
> +	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
>  }

Current fsnotify_open() has following code

	static inline void fsnotify_open(struct dentry *dentry)
	{
	        struct inode *inode = dentry->d_inode;
	        u32 mask = IN_OPEN;
	
	        if (S_ISDIR(inode->i_mode))
	                mask |= IN_ISDIR;
	
	        inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
	        inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
	}

they are two different.

1) Call dnotify_parent() or not
2) Use IN_OPEN or IN_ACCESS

The patch description doesn't explain any reason.


IOW, IN_ACCESS is usually used by read(). but linux has demand paging
mechanism. then exec() only do open and mmap.
actual reading is processed by page fault.

I guess you have the reason of this design choice.
but it isn't described.




