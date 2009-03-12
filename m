Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZCLDZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZCLDZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZCLDZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:25:28 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33596 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZCLDZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:25:27 -0400
Message-ID: <49B8807A.5080302@cosmosbay.com>
Date: Thu, 12 Mar 2009 04:24:42 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> <49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com> <20090312024419.GG18665@kvack.org>
In-Reply-To: <20090312024419.GG18665@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 04:24:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise a écrit :
> On Thu, Mar 12, 2009 at 03:39:51AM +0100, Eric Dumazet wrote:
>> Assuming that __fput() cannot be called from interrupt context.
>> -> fput() should not be called from interrupt context as well.
> 
> It doesn't get called in irq context.  The atomic dec is done in irq 
> context, and if that is the last user of the file descriptor, it's 
> placed on a work queue and then released in process context.
> 

really_put_req() itself can be called from interrupt context, unless I am wrong.
(its 4:24 am here ;) )

        if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
                get_ioctx(ctx);
                spin_lock(&fput_lock);
                list_add(&req->ki_list, &fput_head);
                spin_unlock(&fput_lock);
                queue_work(aio_wq, &fput_work);
        } else
                really_put_req(ctx, req); /* from interrupt context */



static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
{
        assert_spin_locked(&ctx->ctx_lock);

        if (!IS_ERR(req->ki_eventfd))
                fput(req->ki_eventfd);   /* BANG : can be called from interrupt context */
        if (req->ki_dtor)
                req->ki_dtor(req);
        if (req->ki_iovec != &req->ki_inline_vec)
                kfree(req->ki_iovec);
        kmem_cache_free(kiocb_cachep, req);
        ctx->reqs_active--;

        if (unlikely(!ctx->reqs_active && ctx->dead))
                wake_up(&ctx->wait);
}

Thank you

