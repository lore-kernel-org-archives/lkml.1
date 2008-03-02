Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYCBXU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYCBXU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbYCBXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:20:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbYCBXUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:20:17 -0500
Subject: Re: [PATCH] leak less memory in failure paths of
	alloc_rt_sched_group()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LNX.1.00.0803030002520.4939@dragon.funnycrock.com>
References: <alpine.LNX.1.00.0803030002520.4939@dragon.funnycrock.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 00:19:52 +0100
Message-Id: <1204499992.6240.109.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 00:09 +0100, Jesper Juhl wrote:
> In kernel/sched.c b/kernel/sched.c::alloc_rt_sched_group() we currently do 
> some paired memory allocations, and if one fails we bail out without 
> freeing the previous one.
> 
> If we fail inside the loop we should proably roll the whole thing back. 
> This patch does not do that, it simply frees the first member of the 
> paired alloc if the second fails. This is not perfect, but it's a simple 
> change that will, at least, result in us leaking a little less than we 
> currently do when an allocation fails.
> 
> So, not perfect, but better than what we currently have.
> Please consider applying.

Doesn't the following handle that:

sched_create_group()
{
...
	if (!alloc_rt_sched_group())
		goto err;
...

err:
	free_sched_group();
}


free_sched_group()
{
...
	free_rt_sched_group();
...
}

free_rt_sched_group()
{
 	free all relevant stuff
}

