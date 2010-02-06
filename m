Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0BFBIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 20:08:12 -0500
Received: from lo.gmane.org ([80.91.229.12]:35776 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab0BFBIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 20:08:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: [patch 6/7] reiser4: writeback_inodes implementation
Date: Sat, 06 Feb 2010 02:07:48 +0100
Message-ID: <4B6CC0E4.1010105@free.fr>
References: <201002020256.27208.edward.shishkin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78.239.55.22
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; fr; rv:1.9.1.7) Gecko/20100130 SeaMonkey/2.0.2
In-Reply-To: <201002020256.27208.edward.shishkin@gmail.com>
X-Enigmail-Version: 1.0
Cc: reiserfs-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Edward,

Le 02/02/2010 02:56, Edward Shishkin a écrit :
> . add reiser4 implementation of ->writeback_inodes()
>   super operation;
> . cleanup comments.
> 
> Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
> ---
>  fs/reiser4/context.c    |    3 +-
>  fs/reiser4/context.h    |    2 -
>  fs/reiser4/entd.c       |    7 ++++--
>  fs/reiser4/page_cache.c |   12 +++++------
>  fs/reiser4/super_ops.c  |   49 +++++++++++++++++++++++++++++-------------------
>  fs/reiser4/txnmgr.c     |    2 -
>  6 files changed, 45 insertions(+), 30 deletions(-)
> 
[...]
>  
> Index: linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
> ===================================================================
> --- linux-2.6.33-rc5-mm1.orig/fs/reiser4/super_ops.c
> +++ linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
> @@ -379,48 +379,59 @@ static void reiser4_clear_inode(struct i
[...]
> -static void reiser4_sync_inodes(struct super_block *super,
> -			       struct writeback_control *wbc)
> +static int reiser4_writeback_inodes(struct super_block *super,
> +				    struct bdi_writeback *wb,
> +				    struct writeback_control *wbc)
>  {
> -	reiser4_context *ctx;
> +	int ret;
>  	long to_write;
> +	reiser4_context *ctx;
>  
>  	if (wbc->for_kupdate)
>  		/* reiser4 has its own means of periodical write-out */
> -		return;
> -
> -	to_write = wbc->nr_to_write;
> +		goto skip;
>  	assert("vs-49", wbc->older_than_this == NULL);
>  
> +	spin_unlock(&inode_lock);

It seems that reiser4 can't be built as a module because of these access to inode_lock...

Kernel: arch/x86/boot/bzImage is ready  (#13)
  Building modules, stage 2.
  MODPOST 188 modules
ERROR: "inode_lock" [fs/reiser4/reiser4.ko] undefined!
make[1]: *** [__modpost] Erreur 1
make: *** [modules] Erreur 2

~~
laurent


