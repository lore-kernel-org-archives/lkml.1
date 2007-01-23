Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXAWAiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXAWAiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437AbXAWAiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:38:54 -0500
Received: from mx1.suse.de ([195.135.220.2]:36106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbXAWAix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:38:53 -0500
Date: Tue, 23 Jan 2007 01:39:39 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Niki Hammler <mailinglists@nobaq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why active list and inactive list?
Message-ID: <20070123003939.GY13798@opteron.random>
References: <45B55286.5060909@nobaq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B55286.5060909@nobaq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 01:10:46AM +0100, Niki Hammler wrote:
> Dear Linux Developers/Enthusiasts,
> 
> For a course at my university I'm implementing parts of an operating
> system where I get most ideas from the Linux Kernel (which I like very
> much). One book I gain information from is [1].
> 
> Linux uses for its Page Replacing Algorithm (based on LRU) *two* chained
> lists - one active list and one active list.
> I implemented my PRA this way too.
> 
> No the big question is: WHY do I need *two* lists? Isn't it just
> overhead/more work? Are there any reasons for that?
>
> In my opinion, it would be better to have just one just; pop frames to
> be swapped out from the end of the list and push new frames in front of
> it. Then just evaluate the frames and shift them around in the list.
> 
> Is there any explanation why Linux uses two lists?

Back then I designed it with two lru lists because by splitting the
active from the inactive cache allows to detect the cache pollution
before it starts discarding the working set. The idea is that the
pollution will enter and exit the inactive list without ever being
elected to the active list because by definition it will never
generate a cache hit. The working set will instead trigger cache hits
during page faults or repeated reads, and it will be preserved better
by electing it to enter the active list.

A page in the inactive list will be collected much more quickly than a
page in the active list, so the pollution will be collected more
quickly than the working set. Then the VM while freeing cache tries to
keep a balance between the size of the two lists to avoid being too
unfair, obviously at some point the active list have to be
de-activated too. If your server "fits in ram" you'll find lots of
cache to be active and so the I/O activity not part of the working set
will be collected without affecting the working set much.
