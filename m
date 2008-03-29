Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYC2Cw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYC2Cw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 22:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYC2Cwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 22:52:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbYC2Cwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 22:52:47 -0400
Date: Fri, 28 Mar 2008 19:52:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
In-Reply-To: <20080329022408.0DD4726FA1D@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803281942440.14670@woody.linux-foundation.org>
References: <20080329001230.D013726FA1D@magilla.localdomain> <20080329001341.7F93826FA1D@magilla.localdomain> <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org> <20080329022408.0DD4726FA1D@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Roland McGrath wrote:
> 
> It could be a PF_* too, I suppose.  There aren't too many of those
> bits free, but it would have the advantage of being a place for an
> arch that doesn't store any TS_* bits anywhere.

Yeah, I guess PF_ would be a bit more regular. Maybe we should even try to 
avoid the use of TS_ in x86, and turn it into PF_. There are probably bad 
historical reasons for the duplication of capabilities.

> Since acting on the flag is in arch signal code anyway, it makes some
> sense to let the arch define how it gets that to happen.  I'll send
> some follow-on patches that change the conditionals to use #ifdef
> HAVE_SET_RESTORE_SIGMASK.

Let's see if it matters first. No reason to add another arch-specific 
thing if nobody can even measure this thing, and from a quick look it 
seems like every RESTORE_SIGMASK user is basically an error path for a 
system call. Those few extra cycles really won't be noticeable, we almost 
certainly have better things we could use our energy on.

So never mind. I think your series is fine, and my TS_ idea doesn't really 
look like it's worth it (and using PF_ sounds a bit more palatable since 
we could do it with existing infrastructure, but a quick grep shows that 
there's more users of test_thread_flag(TIF_RESTORE_SIGMASK) than I would 
have expected (and the *testing* is equally cheap for atomic and thread- 
synchronous fields, so that's not a performance issue).

			Linus
