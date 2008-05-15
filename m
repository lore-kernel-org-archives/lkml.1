Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbYEOPIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbYEOPIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbYEOPG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:06:27 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:22453 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742AbYEOPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:06:24 -0400
X-IronPort-AV: E=Sophos;i="4.27,492,1204531200"; 
   d="scan'208";a="27244504"
From: Roland Dreier <rdreier@cisco.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: Sparse annotation for "context imbalance" false positives?
References: <adaod78fe94.fsf@cisco.com>
	<1210841663.4282.9.camel@johannes.berg>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 15 May 2008 08:05:23 -0700
In-Reply-To: <1210841663.4282.9.camel@johannes.berg> (Johannes Berg's message
	of "Thu, 15 May 2008 10:54:23 +0200")
Message-ID: <ada7idvfw0c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 May 2008 15:05:23.0386 (UTC) FILETIME=[197DE1A0:01C8B69D]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > You could, for example, insert this:
 > 
 > > 	static void mlx4_ib_lock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_cq *recv_cq)
 > > 	{
 > > 		if (send_cq == recv_cq)
 > 		{
 > > 			spin_lock_irq(&send_cq->lock);
 > 			 /* pretend to have acquired both for sparse */	
 > 			__acquire(&recv_cq->lock);
 > 		}

but the problem sparse sees is not that some paths take only one lock
and some take two -- sparse is complaining that this function is
returning without unlocking the locks that it takes.  Even if I change
the function to something as simple as:

	static void mlx4_ib_lock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_cq *recv_cq)
	{
		spin_lock_irq(&recv_cq->lock);
	}

I still get

    drivers/infiniband/hw/mlx4/qp.c:603:13: warning: context imbalance in 'mlx4_ib_lock_cqs' - wrong count at exitn

thanks,
  Roland
