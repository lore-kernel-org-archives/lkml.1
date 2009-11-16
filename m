Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbZKPK4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbZKPK4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZKPK4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:56:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:54898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZKPK4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:56:52 -0500
Date: Mon, 16 Nov 2009 11:56:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
Message-ID: <20091116105657.GE5818@wotan.suse.de>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com> <20091116041407.GB5818@wotan.suse.de> <4B011677020000780001FD9D@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B011677020000780001FD9D@vpn.id2.novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 08:08:07AM +0000, Jan Beulich wrote:
> >>> Nick Piggin <npiggin@suse.de> 16.11.09 05:14 >>>
> >On Fri, Nov 13, 2009 at 11:54:40AM +0000, Jan Beulich wrote:
> >> Rather than having X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT (with
> >> inconsistent defaults), just having the latter suffices as the former
> >> can be easily calculated from it.
> >> 
> >> To be consistent, also change X86_INTERNODE_CACHE_BYTES to
> >> X86_INTERNODE_CACHE_SHIFT, and set it to 7 (128 bytes) for NUMA to
> >> account for last level cache line size (which here matters more than
> >> L1 cache line size).
> >
> >I think if we're going to set it to 7 (128B, for Pentium 4), then
> >we should set the L1 cache shift as well? Most alignments to
> >prevent cacheline pingpong use L1 cache shift for this anyway?
> 
> But for P4 L1_CACHE_SHIFT already is 7.

I was more talking about the GENERIC defaults, wihch is now 64.
There is no point in making it 128B on a system with 64B cachelines.
So it should be the same as L1_CACHE_BYTES, and I guess we don't
need to further debate the 64B size for GENERIC kernels now because
0a2a18b721abc960fbcada406746877d22340a60 already decided it should
be 64.

 
> >The internode thing is really just a not quite well defined thing
> >because internode cachelines are really expensive and really big
> >on vsmp so they warrant trading off extra space on some critical
> >structures to reduce pingpong (but this is not to say that other
> >structures that are *not* internode annotated do *not* need to
> >worry about pingpong).
> 
> The internode one, as said in the patch description, should consider
> the last level cache line size rather than L1, which 128 seems to be
> a much better fit (without in introducing model dependencies like
> for L1) than just using the L1 value directly.

By far the biggest user has always been to avoid cacheline ping
pong, so LLC size is more important there and IMO the L1 cache
size macro should always work best with the largest line size in
the hierarchy.

Internode was introduced because making it 4096 everywhere was
probably too prohibitive, so only the worst ones were getting
converted (this situation is probably far better now with much
better per-cpu structures and more dynamic allocation (ie. no
more [NR_CPUS] arrays of cacheline_aligned_in_smp to speak of).

The only other use for L1 cache size macro is to pack objects
to cachelines better (so they always use the fewest number of
lines). But this case is more rare nowadays people don't really
count cachelines anymore, but I think even then it makes sense
for it to be the largest line size in the system because we
don't know how big L1s are, and if you want opimal L1 packing,
you likely also want optimal Ln packing.

