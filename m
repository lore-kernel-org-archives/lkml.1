Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYJBFMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYJBFMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYJBFLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:11:54 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4616 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYJBFLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:11:53 -0400
X-IronPort-AV: E=Sophos;i="4.33,348,1220227200"; 
   d="scan'208";a="167135766"
From: Roland Dreier <rdreier@cisco.com>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: ericvh@gmail.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov
Subject: Re: [PATCH 01/03] 9prdma: RDMA Transport Support for 9P
References: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>
	<1222906119-14310-2-git-send-email-tom@opengridcomputing.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 01 Oct 2008 22:11:52 -0700
In-Reply-To: <1222906119-14310-2-git-send-email-tom@opengridcomputing.com>
	(Tom Tucker's message of "Wed, 1 Oct 2008 19:08:37 -0500")
Message-ID: <adaod23d1if.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Oct 2008 05:11:52.0828 (UTC) FILETIME=[61C6F3C0:01C9244D]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

very cool... neat that it only takes 1000 lines of code to do this too.

a few quick comments from a cursory read:

 > This file implements the RDMA transport provider for 9P. It allows
 > mounts to be performed over iWARP and IB capable network interfaces
 > and uses the OpenFabrics API to perform I/O.

I don't like this "openfabrics API" terminology -- the RDMA API is just
one part of the kernel API that you're using, and I'm not sure it's
worth calling out specially.  ie just delete that third line from the
changelog.

 > +	atomic_t next_tag;

this seems to be a write-only field... delete it?

 > + * @wc_op: Mellanox's broken HW doesn't provide the original WR op
 > + * when the CQE completes in error. This forces apps to keep track of
 > + * the op themselves. Yes, it's a Pet Peeve of mine ;-)

there's nothing broken about this behavior -- the IB spec very
explicitly calls out that the opcode field is undefined for completions
with error status.

 > +find_req(struct p9_trans_rdma *rdma, u16 tag)

 > +	return found ? req : 0;

using 0 instead of NULL here... probably worth running all this through
sparse to see what else if flags.

 > +	if (atomic_inc_return(&rdma->sq_count) >= rdma->sq_depth)
 > +		wait_event_interruptible
 > +			(rdma->send_wait,
 > +			 (atomic_read(&rdma->sq_count) < rdma->sq_depth));

this worries me a bit... for one thing you use wait_event_interruptible()
without checking the return value, so it's entirely possible that this
gets woken up before the condition actually becomes true.  And to handle
that correctly, you'd need extra code to decrement the sq_count and wake
up other waiters if it was interrupted, etc.

I know counting semaphores are out of favor in the kernel but this seems
to be a good place to use real semaphores, rather than concocting your
own in a much more complicated way.

 > +	wait_for_completion_interruptible(&rdma->cm_done);

similarly there are lots of places you do this interruptible wait but
then don't check if you were interrupted.

 > +	if (0 == (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
 > +		rdma->dma_mr = ib_get_dma_mr(rdma->pd, IB_ACCESS_LOCAL_WRITE);
 > +		if (IS_ERR(rdma->dma_mr))
 > +			goto error;
 > +		rdma->lkey = rdma->dma_mr->lkey;
 > +	} else
 > +		rdma->lkey = rdma->cm_id->device->local_dma_lkey;

seems to me this could be written more naturally and avoid the "if
(0==(test))" construction (which I always have to reread to parse) if
you reverse the test:

	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
		rdma->lkey = rdma->cm_id->device->local_dma_lkey;
	} else {
		rdma->dma_mr = ib_get_dma_mr(rdma->pd, IB_ACCESS_LOCAL_WRITE);
		if (IS_ERR(rdma->dma_mr))
			goto error;
		rdma->lkey = rdma->dma_mr->lkey;
	}

The only place I see a send request posted has:

 > +	wr.opcode = IB_WR_SEND;

so I guess your protocol is only send/receives (ie no RDMA in the
pedantic sense, just two-sided operations).  I'm wondering what the
motivation for all this is: is using send/receive on IB/iWARP a big
performance win over non-offloaded transport?  Even compared to TCP on a
NIC with LSO and (software) LRO?

Is your protocol documented anywhere?  It seems npfs has support for the
same transport.

Finally, you create your QP with:

 > +	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;

but you unconditionally do:

 > +	wr.send_flags = IB_SEND_SIGNALED;

not a big deal but you could save one line of code and a correspondingly
tiny amount of .text by just making the send queue signal all requests.

 - R.
