Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZIPStj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZIPStj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZIPStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZIPStd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:49:33 -0400
Date: Wed, 16 Sep 2009 14:47:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [PATCH 20/23] io-controller: Per cgroup request descriptor
	support
Message-ID: <20090916184749.GF5221@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-21-git-send-email-vgoyal@redhat.com> <e98e18940909141133m5186b780r3215ce15141e4f87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e98e18940909141133m5186b780r3215ce15141e4f87@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 11:33:37AM -0700, Nauman Rafique wrote:

[..]
> >  struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
> >  {
> >        struct request *rq;
> > +       struct request_list *rl;
> >
> >        BUG_ON(rw != READ && rw != WRITE);
> >
> >        spin_lock_irq(q->queue_lock);
> > +       rl = blk_get_request_list(q, NULL);
> >        if (gfp_mask & __GFP_WAIT) {
> >                rq = get_request_wait(q, rw, NULL);
> >        } else {
> > -               rq = get_request(q, rw, NULL, gfp_mask);
> > +               rq = get_request(q, rw, NULL, gfp_mask, rl, NULL);
> >                if (!rq)
> >                        spin_unlock_irq(q->queue_lock);
> >        }
> > @@ -1085,12 +1269,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
> >        if (req->cmd_flags & REQ_ALLOCED) {
> >                int is_sync = rq_is_sync(req) != 0;
> >                int priv = req->cmd_flags & REQ_ELVPRIV;
> > +               struct request_list *rl = rq_rl(q, req);
> >
> >                BUG_ON(!list_empty(&req->queuelist));
> >                BUG_ON(!hlist_unhashed(&req->hash));
> >
> >                blk_free_request(q, req);
> > -               freed_request(q, is_sync, priv);
> > +               freed_request(q, is_sync, priv, rl);
> 
> We have a potential memory bug here. freed_request should be called
> before blk_free_request as blk_free_request might result in release of
> cgroup, and request_list. Calling freed_request after blk_free_request
> would result in operations on freed memory.
> 

Good point Nauman. freeing rq will drop reference on the io queue. Which
in turn will drop reference on io group and if associated cgroup is
already gone, then io group will be freed hence request list pointer is
no more valid and any operation on that is bad.

So either we can take a reference on the queue, call free_request() and
then drop the reference or we can call freed_request() before
blk_free_request(). Calling freed_request() before blk_free_request()
sounds better to me. The only thing is that this function name and other
dependent function names should now be freeing_request() instead of
freed_request(). :-)

Will move freed_request() before blk_free_request() in next version.

Thanks
Vivek
