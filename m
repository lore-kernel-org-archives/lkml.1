Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYJFSKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYJFSKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 14:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYJFSKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 14:10:40 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:42322 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbYJFSKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:10:39 -0400
Message-ID: <48EA549E.1050001@opengridcomputing.com>
Date: Mon, 06 Oct 2008 13:10:38 -0500
From: Tom Tucker <tom@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: ericvh@gmail.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov
Subject: Re: [PATCH 01/03] 9prdma: RDMA Transport Support for 9P
References: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>	<1222906119-14310-2-git-send-email-tom@opengridcomputing.com> <adaod23d1if.fsf@cisco.com>
In-Reply-To: <adaod23d1if.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> very cool... neat that it only takes 1000 lines of code to do this too.
> 
> a few quick comments from a cursory read:
> 
>  > This file implements the RDMA transport provider for 9P. It allows
>  > mounts to be performed over iWARP and IB capable network interfaces
>  > and uses the OpenFabrics API to perform I/O.
> 
> I don't like this "openfabrics API" terminology -- the RDMA API is just
> one part of the kernel API that you're using, and I'm not sure it's
> worth calling out specially.  ie just delete that third line from the
> changelog.
> 

Ok.

>  > +	atomic_t next_tag;
> 
> this seems to be a write-only field... delete it?

This is left over garbage. Nice catch.

> 
>  > + * @wc_op: Mellanox's broken HW doesn't provide the original WR op
>  > + * when the CQE completes in error. This forces apps to keep track of
>  > + * the op themselves. Yes, it's a Pet Peeve of mine ;-)
> 
> there's nothing broken about this behavior -- the IB spec very
> explicitly calls out that the opcode field is undefined for completions
> with error status.
>

Fair enough...

>  > +find_req(struct p9_trans_rdma *rdma, u16 tag)
> 
>  > +	return found ? req : 0;
> 
> using 0 instead of NULL here... probably worth running all this through
> sparse to see what else if flags.
>

will do.


>  > +	if (atomic_inc_return(&rdma->sq_count) >= rdma->sq_depth)
>  > +		wait_event_interruptible
>  > +			(rdma->send_wait,
>  > +			 (atomic_read(&rdma->sq_count) < rdma->sq_depth));
> 
> this worries me a bit... for one thing you use wait_event_interruptible()
> without checking the return value, so it's entirely possible that this
> gets woken up before the condition actually becomes true.  And to handle
> that correctly, you'd need extra code to decrement the sq_count and wake
> up other waiters if it was interrupted, etc.
>

Yes, I think this needs to be wait_event.

> I know counting semaphores are out of favor in the kernel but this seems
> to be a good place to use real semaphores, rather than concocting your
> own in a much more complicated way.
> 


>  > +	wait_for_completion_interruptible(&rdma->cm_done);
> 
> similarly there are lots of places you do this interruptible wait but
> then don't check if you were interrupted.
> 

Well. The only place I do that is when the connection is being 
established. And actually, I don't(didn't?) really care why it stopped 
waiting, I  only care about the state of the connection and if it's not 
what I need it to be I error out. I suppose there is a theoretical race 
here where the user cancels the wait with ctrl-C, but the connection 
keeps going because the transport always gets back fast enough. This 
would eventually fail in rdma_rpc.

I'll add the code to check so that it's obvious.

>  > +	if (0 == (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
>  > +		rdma->dma_mr = ib_get_dma_mr(rdma->pd, IB_ACCESS_LOCAL_WRITE);
>  > +		if (IS_ERR(rdma->dma_mr))
>  > +			goto error;
>  > +		rdma->lkey = rdma->dma_mr->lkey;
>  > +	} else
>  > +		rdma->lkey = rdma->cm_id->device->local_dma_lkey;
> 
> seems to me this could be written more naturally and avoid the "if
> (0==(test))" construction (which I always have to reread to parse) if
> you reverse the test:
> 
> 	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
> 		rdma->lkey = rdma->cm_id->device->local_dma_lkey;
> 	} else {
> 		rdma->dma_mr = ib_get_dma_mr(rdma->pd, IB_ACCESS_LOCAL_WRITE);
> 		if (IS_ERR(rdma->dma_mr))
> 			goto error;
> 		rdma->lkey = rdma->dma_mr->lkey;
> 	}
> 
agree. thanks.

> The only place I see a send request posted has:
> 
>  > +	wr.opcode = IB_WR_SEND;
> 
> so I guess your protocol is only send/receives (ie no RDMA in the
> pedantic sense, just two-sided operations).  I'm wondering what the
> motivation for all this is: is using send/receive on IB/iWARP a big
> performance win over non-offloaded transport?  Even compared to TCP on a
> NIC with LSO and (software) LRO?
> 

For IB it avoids IPoIB. Which I think is a big win. For iWARP, it's  not 
so clear. There is the potential for RDMA ops in the future.

> Is your protocol documented anywhere?  It seems npfs has support for the
> same transport.
> 

When using SEND/RECV, there isn't a protocol other than 9P itself. Once 
we add RDMA ops, one will be required to exchange RKEY, etc... But maybe 
I don't understand the question?

> Finally, you create your QP with:
> 
>  > +	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
> 
> but you unconditionally do:
> 
>  > +	wr.send_flags = IB_SEND_SIGNALED;
> 
> not a big deal but you could save one line of code and a correspondingly
> tiny amount of .text by just making the send queue signal all requests.
> 

ok.

Thanks for the review,
Tom

>  - R.

