Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYJRA1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYJRA1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYJRA1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:27:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYJRA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:27:25 -0400
Date: Fri, 17 Oct 2008 17:25:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] mm: fix anon_vma races
In-Reply-To: <Pine.LNX.4.64.0810180045370.8995@blonde.site>
Message-ID: <alpine.LFD.2.00.0810171717470.3438@nehalem.linux-foundation.org>
References: <20081016041033.GB10371@wotan.suse.de> <Pine.LNX.4.64.0810172300280.30871@blonde.site> <alpine.LFD.2.00.0810171549310.3438@nehalem.linux-foundation.org> <Pine.LNX.4.64.0810180045370.8995@blonde.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Hugh Dickins wrote:
> 
> But they're doing it to make the page's ptes accessible to
> memory reclaim, and the CPU doing memory reclaim will not
> (unless by coincidence) have done that anon_vma_prepare() -
> it's just reading the links which the faulters are providing.

Ahh. Good point. Then yes, those ones would really need the 
smp_read_barrier_depends() too.

Very annoying.

Of course, we _could_ just admit that the situation is really *really* 
unlikely, and there are probably something like five people running 
Linux/alpha, and that we don't care enough. With just the smp_wmb(), we 
cover all non-alpha people, since this is all through a pointer, so all 
the readers will inevitably be of the smp_read_barrier_depends kind.

If we want to guarantee the proper smp_read_barrier_depends() behaviour, 
then we'd need to find them all. Possibly by renaming the whole field 
(prepend an underscore like we usually do) and forcing all readers to use 
some "get_anon_vma(vma)" helper function, aka

  static inline struct anon_vma *get_anon_vma(struct vm_area_struct *vma)
  {
	struct anon_vma *anon_vma = vma->_anon_vma;
	smp_read_barrier_depends();
	return anon_vma;
  }

which would find them all.

Ugh. I really would have preferred not having something like that. 
Especially considering how limited that issue really is. Hmm. 

		Linus
