Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYEODQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYEODQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYEODQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:16:42 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47151 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbYEODQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:16:40 -0400
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="98929611"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Sparse annotation for "context imbalance" false positives?
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 May 2008 20:16:39 -0700
Message-ID: <adaod78fe94.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 May 2008 03:16:39.0701 (UTC) FILETIME=[17667C50:01C8B63A]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that I've gotten the sparse noise in drivers/infiniband down to a
fairly low level, I'm starting to look at some of the more recalcitrant
false positive warnings.  One example is:

    drivers/infiniband/hw/mlx4/qp.c:605:2: warning: context imbalance in 'mlx4_ib_lock_cqs' - wrong count at exit

where the function being warned about is:

	static void mlx4_ib_lock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_cq *recv_cq)
	{
		if (send_cq == recv_cq)
			spin_lock_irq(&send_cq->lock);
		else if (send_cq->mcq.cqn < recv_cq->mcq.cqn) {
			spin_lock_irq(&send_cq->lock);
			spin_lock_nested(&recv_cq->lock, SINGLE_DEPTH_NESTING);
		} else {
			spin_lock_irq(&recv_cq->lock);
			spin_lock_nested(&send_cq->lock, SINGLE_DEPTH_NESTING);
		}
	}

this function wraps up the locking rules for aquiring the completion
queue (CQ) locks associated with a queue pair (QP) -- the rule is that
if both the send and receive CQs are the same object, we (obviously)
only lock it once, otherwise we take the lock belonging to the CQ with a
numerically lower ID first (to avoid AB-BA deadlocks).

So obviously is it correct and intended that this function return
holding one or two locks, but I don't know how to tell sparse that.
I've tried messing around with __acquires() etc but it doesn't seem to
be exactly what I want.

Is there any way to tell sparse what's going on here, or do I just live
with the warnings?

Thanks,
  Roland
