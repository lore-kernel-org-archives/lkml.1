Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbZFHEzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbZFHEzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 00:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZFHEzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 00:55:21 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35660 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZFHEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 00:55:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20090608023757.GA6244@localhost>
References: <20090608023757.GA6244@localhost>
Message-Id: <20090608134428.4373.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Jun 2009 13:55:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi,
> 
> This lockdep warning appears when doing stress memory tests over NFS.
> 
> page reclaim => nfs_writepage => tcp_sendmsg => lock sk_lock
> 
> tcp_close => lock sk_lock => tcp_send_fin => alloc_skb_fclone => page reclaim
> 
> Any ideas?

AFAIK, btrfs has re-dirty hack. 

------------------------------------------------------------------
static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
{
        struct extent_io_tree *tree;


        if (current->flags & PF_MEMALLOC) {
                redirty_page_for_writepage(wbc, page);
                unlock_page(page);
                return 0;
        }
        tree = &BTRFS_I(page->mapping->host)->io_tree;
        return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
}
---------------------------------------------------------------

PF_MEMALLOC mean caller is try_to_free_pages(). (not normal write nor kswapd)
Can't nfs does similar hack? 


I'm not net nor nfs expert. perhaps I'm wrong :-)


Thanks.



