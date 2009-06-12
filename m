Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFLPFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFLPFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZFLPF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:05:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbZFLPF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:05:28 -0400
Date: Fri, 12 Jun 2009 08:04:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       npiggin@suse.de, benh@kernel.crashing.org, akpm@linux-foundation.org,
       cl@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
In-Reply-To: <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
Message-ID: <alpine.LFD.2.01.0906120800450.3237@localhost.localdomain>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Pekka J Enberg wrote:
>  
> +	if (system_state != SYSTEM_RUNNING)
> +		local_flags &= ~__GFP_WAIT;
> +
> +	might_sleep_if(local_flags & __GFP_WAIT);

This is pointless.

You're doing the "might_sleep_if()" way too late. At that point, you've 
already lost 99% of all coverage, since now none of the cases of just 
finding a free slab entry on the list will ever trigger that 
"might_sleep()" case.

So you need to do this _early_, at the entry-point, not late, at cache 
re-fill time.

So rather than removing the might_sleep_if() at the early point, and then 
moving it to this late stage (because you only do the local_flags fixups 
late), you need to move the local-flags fixup early instead, and do the 
might_sleep_it() there.

The whole point of "might_sleep()" is that it triggers every time if 
something is called in the wrong context - not just for the cases where it 
actually _does_ sleep.

			Linus
