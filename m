Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZFIDNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZFIDNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZFIDNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:13:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:53223 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbZFIDNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,328,1241420400"; 
   d="scan'208";a="152085913"
Date: Tue, 9 Jun 2009 11:07:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
	usage
Message-ID: <20090609030726.GA8026@localhost>
References: <20090608023757.GA6244@localhost> <20090608134428.4373.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608134428.4373.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 12:55:18PM +0800, KOSAKI Motohiro wrote:
> Hi
> 
> > Hi,
> > 
> > This lockdep warning appears when doing stress memory tests over NFS.
> > 
> > page reclaim => nfs_writepage => tcp_sendmsg => lock sk_lock
> > 
> > tcp_close => lock sk_lock => tcp_send_fin => alloc_skb_fclone => page reclaim
> > 
> > Any ideas?
> 
> AFAIK, btrfs has re-dirty hack. 
> 
> ------------------------------------------------------------------
> static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
> {
>         struct extent_io_tree *tree;
> 
> 
>         if (current->flags & PF_MEMALLOC) {
>                 redirty_page_for_writepage(wbc, page);
>                 unlock_page(page);
>                 return 0;
>         }
>         tree = &BTRFS_I(page->mapping->host)->io_tree;
>         return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
> }
> ---------------------------------------------------------------
> 
> PF_MEMALLOC mean caller is try_to_free_pages(). (not normal write nor kswapd)

No, kswapd also sets the PF_MEMALLOC flag. It looks like btrfs_writepage()
is trying to avoid inefficient page outs at the cost of pinning dirty
pages in memory (even when we really want free pages).

Thanks,
Fengguang

> Can't nfs does similar hack? 
> 
> 
> I'm not net nor nfs expert. perhaps I'm wrong :-)
> 
> 
> Thanks.
> 
> 
