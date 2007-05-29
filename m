Return-Path: <linux-kernel-owner+w=401wt.eu-S1763561AbXE2IDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763561AbXE2IDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXE2IDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:03:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:1335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXE2ID1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zu8DFENSQ/AT31t98NCiJNTojEI7BMGLIfmt7kXvhoKvG3pAh3jSTUdP/vjJ7KwDQ/lqEzcOjdvhU+I98b6cOLYdyzaDPkB5DuAONnvjqr1cqp9tqxzW8vhprdVVeENQSJblqxmw4Bw9cqR9UZnZ9flBmaGlBggLrrbn2Qvq6oY=
Message-ID: <9a8748490705290103p3f7d1167n2b58625f26a5667f@mail.gmail.com>
Date: Tue, 29 May 2007 10:03:27 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Per Linden" <per.liden@ericsson.com>,
       "Jon Maloy" <jon.maloy@ericsson.com>,
       "Allan Stephens" <allan.stephens@windriver.com>,
       tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] Fix potential memory leak in tipc_named_node_up()
In-Reply-To: <20070528231524.GA17298@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200705282258.08701.jesper.juhl@gmail.com>
	 <20070528231524.GA17298@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/07, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> On 2007.05.28 22:58:08 +0200, Jesper Juhl wrote:
> > There seems to be a memory leak in net/tipc/name_distr.c::tipc_named_node_up()
> >
> > The function, with comments, is this :
> >
> > void tipc_named_node_up(unsigned long node)
> > {
> >         struct publication *publ;
> >         struct distr_item *item = NULL;
> >         struct sk_buff *buf = NULL;
> >         u32 left = 0;
> >         u32 rest;
> >         u32 max_item_buf;
> >
> >         read_lock_bh(&tipc_nametbl_lock);
> >         max_item_buf = TIPC_MAX_USER_MSG_SIZE / ITEM_SIZE;
> >         max_item_buf *= ITEM_SIZE;
> >         rest = publ_cnt * ITEM_SIZE;
> >
> >         list_for_each_entry(publ, &publ_root, local_list) {
> > -----> If we stop processing here after doing 1, 2 & 3 below we end up at (4) (below).
> >                 if (!buf) {
> >                         left = (rest <= max_item_buf) ? rest : max_item_buf;
> >                         rest -= left;
> >                         buf = named_prepare_buf(PUBLICATION, left, node);
> > -----> (1) here we allocate memory and store a pointer to it in 'buf'.
> >
> >                         if (!buf) {
> > -----> (2) This test needs to fail, meaning we did allocate some memory.
> >                                 warn("Bulk publication distribution failure\n");
> >                                 goto exit;
> >                         }
> >                         item = (struct distr_item *)msg_data(buf_msg(buf));
> >                 }
> >                 publ_to_item(item, publ);
> >                 item++;
> >                 left -= ITEM_SIZE;
> >                 if (!left) {
> > -----> (3) If this test fails we loop and do nothing to 'buf'.
> >                         msg_set_link_selector(buf_msg(buf), node);
> >                         dbg("tipc_named_node_up: sending publish msg to "
> >                             "<%u.%u.%u>\n", tipc_zone(node),
> >                             tipc_cluster(node), tipc_node(node));
> >                         tipc_link_send(buf, node, node);
> >                         buf = NULL;
> >                 }
> >         }
> > exit:
> >         read_unlock_bh(&tipc_nametbl_lock);
> > -----> (4) here we return without freeing 'buf' - memory leak.
> > }
> >
> > Luckily this is easy to fix, since we can only leave the function with 'buf'
> > either set to NULL or (in the leak case) set to a valid address, and since
> > kfree() handles being passed NULL gracefully we can simply kfree(buf) just
> > before we leave the function.
>
> Actually, I don't think that there's a leak.
>
> publ_cnt: Number of items in the list
>
> rest = publ_cnt * ITEM_SIZE
> max_item_buf = n * ITEM_SIZE (Buffer can hold n elements at most)
>
> 1)
> If publ_cnt <= n, "rest" becomes 0 and "left" becomes publ_cnt * ITEM_SIZE,
> so for the last iteration "left" becomes 0 and "buf" is freed.
>
> 2)
> And if publ_cnt > n, "left" becomes 0 in the nth iteration. As "rest"
> already got decrement by n * ITEM_SIZE, you now got:
> rest = (publ_cnt - n) * ITEM_SIZE
> Then after 2*n iterations:
> rest = (publ_cnt - 2*n) * ITEM_SIZE
> and so on, until publ_cnt - m*n < n
>
> At that point, "left" becomes (publ_cnt - m*n) * ITEM_SIZE, and there are
> also (publ_cnt - m*n) iterations left, so "left" again becomes 0 in the
> last iteration and "buf" is freed.
>
Ok, creating patches late in the evening after several cups of coffee
is clearly a bad idea. I think you are right and there is really no
leak. Thanks.


>
> Besides that, is it valid to call kfree() on a buffer allocated by
> alloc_skb()?
>
Arrgh, no of course not, seems I messed this one up real good :(


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
