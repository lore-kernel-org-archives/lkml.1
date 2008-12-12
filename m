Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYLLEzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYLLEzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYLLEy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:54:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbYLLEy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:54:56 -0500
Date: Thu, 11 Dec 2008 20:00:52 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Roland Dreier <rolandd@cisco.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [patch 03/83] cxgb3: Fix kernel crash caused by uninitialized
	l2t_entry.arpq
Message-ID: <20081212040052.GA9561@suse.de>
References: <20081211190201.612240183@mini.kroah.org> <20081211191334.GC5894@kroah.com> <200812112212.35832.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812112212.35832.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 10:12:34PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Donnerstag, 11. Dezember 2008, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Roland Dreier <rdreier@cisco.com>
> > 
> > [ Upstream commit 6d329af9967e7ab3f4a3d7f1e8ef87539c3a069f ]
> > 
> > Commit 147e70e6 ("cxgb3: Use SKB list interfaces instead of home-grown
> > implementation.") causes a crash in t3_l2t_send_slow() when an iWARP
> > connection request is received.  This is because the new l2t_entry.arpq
> > skb queue is never initialized, and therefore trying to add an skb to
> > it causes a NULL dereference.  With the old code there was no need to
> > initialize the queues because the l2t_entry structures were zeroed,
> > and the code used NULL to mean empty.
> > 
> > Fix this by adding __skb_queue_head_init() when all the l2t_entry
> > structures get allocated.
> 
> This patch doesn't compile.
> 
> > Signed-off-by: Roland Dreier <rolandd@cisco.com>
> > Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/net/cxgb3/l2t.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/drivers/net/cxgb3/l2t.c
> > +++ b/drivers/net/cxgb3/l2t.c
> > @@ -436,6 +436,7 @@ struct l2t_data *t3_init_l2t(unsigned in
> >  	for (i = 0; i < l2t_capacity; ++i) {
> >  		d->l2tab[i].idx = i;
> >  		d->l2tab[i].state = L2T_STATE_UNUSED;
> > +		__skb_queue_head_init(&d->l2tab[i].arpq);
> >  		spin_lock_init(&d->l2tab[i].lock);
> >  		atomic_set(&d->l2tab[i].refcnt, 0);
> >  	}
> 
>   CC [M]  drivers/net/cxgb3/cxgb3_main.o
>   CC [M]  drivers/net/cxgb3/ael1002.o
>   CC [M]  drivers/net/cxgb3/vsc8211.o
>   CC [M]  drivers/net/cxgb3/t3_hw.o
>   CC [M]  drivers/net/cxgb3/mc5.o
>   CC [M]  drivers/net/cxgb3/xgmac.o
>   CC [M]  drivers/net/cxgb3/sge.o
>   CC [M]  drivers/net/cxgb3/l2t.o
> drivers/net/cxgb3/l2t.c: In function ‘t3_init_l2t’:
> drivers/net/cxgb3/l2t.c:439: error: implicit declaration of function ‘__skb_queue_head_init’
> drivers/net/cxgb3/l2t.c:439: error: ‘struct l2t_entry’ has no member named ‘arpq’
> make[3]: *** [drivers/net/cxgb3/l2t.o] Error 1
> make[2]: *** [drivers/net/cxgb3] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> It seems to depend on
> 
> commit 147e70e62fdd5af6263106ad634b03c5154c1e56
> Author: David S. Miller <davem@davemloft.net>
> Date:   Mon Sep 22 01:29:52 2008 -0700
> 
>     cxgb3: Use SKB list interfaces instead of home-grown implementation.
> 
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Hm, no, adding that patch also breaks the build for other reasons :)

David, I'm going to have to drop the original patch you sent me here, as
it doesn't build in the 2.6.27 tree.  If you have a replacement for it
that does build, I'll be glad to take it.

thanks,

greg k-h
