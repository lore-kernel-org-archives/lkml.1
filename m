Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbXE1XP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbXE1XP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXE1XPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:15:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:36973 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752017AbXE1XPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:15:15 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX192YsY+X8x2munaT5R2I/LTJ2GjHQSpCwf+y75ozy
	YLFivUQlEmwN3Z
Date: Tue, 29 May 2007 01:15:24 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Per Linden <per.liden@ericsson.com>, Jon Maloy <jon.maloy@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>,
       tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] Fix potential memory leak in tipc_named_node_up()
Message-ID: <20070528231524.GA17298@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Per Linden <per.liden@ericsson.com>,
	Jon Maloy <jon.maloy@ericsson.com>,
	Allan Stephens <allan.stephens@windriver.com>,
	tipc-discussion@lists.sourceforge.net
References: <200705282258.08701.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705282258.08701.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.28 22:58:08 +0200, Jesper Juhl wrote:
> There seems to be a memory leak in net/tipc/name_distr.c::tipc_named_node_up()
> 
> The function, with comments, is this :
> 
> void tipc_named_node_up(unsigned long node)
> {
>         struct publication *publ;
>         struct distr_item *item = NULL;
>         struct sk_buff *buf = NULL;
>         u32 left = 0;
>         u32 rest;
>         u32 max_item_buf;
> 
>         read_lock_bh(&tipc_nametbl_lock);
>         max_item_buf = TIPC_MAX_USER_MSG_SIZE / ITEM_SIZE;
>         max_item_buf *= ITEM_SIZE;
>         rest = publ_cnt * ITEM_SIZE;
> 
>         list_for_each_entry(publ, &publ_root, local_list) {
> -----> If we stop processing here after doing 1, 2 & 3 below we end up at (4) (below).
>                 if (!buf) {
>                         left = (rest <= max_item_buf) ? rest : max_item_buf;
>                         rest -= left;
>                         buf = named_prepare_buf(PUBLICATION, left, node);
> -----> (1) here we allocate memory and store a pointer to it in 'buf'.
> 
>                         if (!buf) {
> -----> (2) This test needs to fail, meaning we did allocate some memory.
>                                 warn("Bulk publication distribution failure\n");
>                                 goto exit;
>                         }
>                         item = (struct distr_item *)msg_data(buf_msg(buf));
>                 }
>                 publ_to_item(item, publ);
>                 item++;
>                 left -= ITEM_SIZE;
>                 if (!left) {
> -----> (3) If this test fails we loop and do nothing to 'buf'.
>                         msg_set_link_selector(buf_msg(buf), node);
>                         dbg("tipc_named_node_up: sending publish msg to "
>                             "<%u.%u.%u>\n", tipc_zone(node),
>                             tipc_cluster(node), tipc_node(node));
>                         tipc_link_send(buf, node, node);
>                         buf = NULL;
>                 }
>         }
> exit:
>         read_unlock_bh(&tipc_nametbl_lock);
> -----> (4) here we return without freeing 'buf' - memory leak.
> }
> 
> Luckily this is easy to fix, since we can only leave the function with 'buf'
> either set to NULL or (in the leak case) set to a valid address, and since 
> kfree() handles being passed NULL gracefully we can simply kfree(buf) just 
> before we leave the function.

Actually, I don't think that there's a leak.

publ_cnt: Number of items in the list

rest = publ_cnt * ITEM_SIZE
max_item_buf = n * ITEM_SIZE (Buffer can hold n elements at most)

1)
If publ_cnt <= n, "rest" becomes 0 and "left" becomes publ_cnt * ITEM_SIZE,
so for the last iteration "left" becomes 0 and "buf" is freed.

2)
And if publ_cnt > n, "left" becomes 0 in the nth iteration. As "rest"
already got decrement by n * ITEM_SIZE, you now got:
rest = (publ_cnt - n) * ITEM_SIZE
Then after 2*n iterations:
rest = (publ_cnt - 2*n) * ITEM_SIZE
and so on, until publ_cnt - m*n < n

At that point, "left" becomes (publ_cnt - m*n) * ITEM_SIZE, and there are
also (publ_cnt - m*n) iterations left, so "left" again becomes 0 in the
last iteration and "buf" is freed.


Besides that, is it valid to call kfree() on a buffer allocated by
alloc_skb()?

Thanks,
Björn
