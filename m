Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbZCaXtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbZCaXtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758458AbZCaXtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:49:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbZCaXtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:49:21 -0400
Date: Tue, 31 Mar 2009 16:43:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
       m.mizuma@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, npiggin@suse.de
Subject: Re: [PATCH][RESEND for 2.6.29-rc8-mm1] skip I_CLEAR state inodes
Message-Id: <20090331164332.7093ac94.akpm@linux-foundation.org>
In-Reply-To: <20090330071824.GA9260@localhost>
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com>
	<20090323103846.GA16577@localhost>
	<20090324155655.2684.61FB500B@jp.fujitsu.com>
	<20090324074457.GA7745@localhost>
	<20090324120502.GC23439@duck.suse.cz>
	<20090324124001.GA25326@localhost>
	<20090330071824.GA9260@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 15:18:24 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> and do so _outside_ of inode_lock. So any I_FREEING testing is
> incomplete without a coupled testing of I_CLEAR.
> 
> So add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> add_dquot_ref().
> 
> Masayoshi MIZUMA discovered the bug in drop_pagecache_sb() and Jan Kara
> reminds fixing the other two cases.

ok...

But what is the user-visible consequence of this?  You cc'ed
stable@kernel.org so I assume it's serious.  People will want to know
what problem we're fixing!

> 
> --- mm.orig/fs/drop_caches.c
> +++ mm/fs/drop_caches.c
> @@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
>  			continue;
>  		if (inode->i_mapping->nrpages == 0)
>  			continue;
> --- mm.orig/fs/fs-writeback.c
> +++ mm/fs/fs-writeback.c
> @@ -538,7 +538,8 @@ void generic_sync_sb_inodes(struct super
>  		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>  			struct address_space *mapping;
>  
> -			if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> +			if (inode->i_state &
> +					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
>  				continue;
>  			mapping = inode->i_mapping;
>  			if (mapping->nrpages == 0)
> --- mm.orig/fs/quota/dquot.c
> +++ mm/fs/quota/dquot.c
> @@ -823,7 +823,7 @@ static void add_dquot_ref(struct super_b
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
>  			continue;
>  		if (!atomic_read(&inode->i_writecount))
>  			continue;
