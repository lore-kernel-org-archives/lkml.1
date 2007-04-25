Return-Path: <linux-kernel-owner+w=401wt.eu-S1031102AbXDYPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031102AbXDYPrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031096AbXDYPro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:47:44 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031102AbXDYPro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:47:44 -0400
Date: Wed, 25 Apr 2007 08:45:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Shani Moideen <shani.moideen@wipro.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [PATCH]:Replacing current->state with set_current_state in
 kernel/signal.c
In-Reply-To: <20070425091724.6f2c212b.dada1@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0704250843300.9964@woody.linux-foundation.org>
References: <1177483138.27118.25.camel@shani-win>
 <20070425091724.6f2c212b.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Eric Dumazet wrote:
> 
> Either you think you corrected a BUG, so please state it clearly in 
> Changelog so that Linus immediatly apply your patch for 2.6.21 :)

It's not a bug.

Setting current state manually is fine _iff_ you don't actually test a 
condition value. It's only if you do

	/* This has a race, and is bad! */
	current->state = TASK_INTERRUPTIBLE;
	if (some_condition)
		schedule();

that you have a race: the CPU (or the compiler, for that matter) can move 
the "some_condition" check up to before setting TASK_INTERRUPTIBLE, and if 
another CPU comes in and wakes you up, you might lose the wakeup.

But doing

	/* This is fine */
	current->state = TASK_INTERRUPTIBLE;
	schedule();

is fine.

		Linus
