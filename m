Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZKPEOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZKPEOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZKPEOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:14:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbZKPEOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:14:04 -0500
Date: Mon, 16 Nov 2009 05:14:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
Message-ID: <20091116041407.GB5818@wotan.suse.de>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 11:54:40AM +0000, Jan Beulich wrote:
> Rather than having X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT (with
> inconsistent defaults), just having the latter suffices as the former
> can be easily calculated from it.
> 
> To be consistent, also change X86_INTERNODE_CACHE_BYTES to
> X86_INTERNODE_CACHE_SHIFT, and set it to 7 (128 bytes) for NUMA to
> account for last level cache line size (which here matters more than
> L1 cache line size).

I think if we're going to set it to 7 (128B, for Pentium 4), then
we should set the L1 cache shift as well? Most alignments to
prevent cacheline pingpong use L1 cache shift for this anyway?

The internode thing is really just a not quite well defined thing
because internode cachelines are really expensive and really big
on vsmp so they warrant trading off extra space on some critical
structures to reduce pingpong (but this is not to say that other
structures that are *not* internode annotated do *not* need to
worry about pingpong).

Put another way, big SMP P4 systems with !NUMA still want to have
128 byte aligned variables. I think it should just default to
L1_CACHE_SHIFT unless the special case of vsmp.

But other than that complaint (which was not introduced by your
patch anyway) then this looks like a good cleanup to me, thanks.


> Finally, make sure the default value for X86_L1_CACHE_SHIFT, when
> X86_GENERIC is selected, is being seen before that for the individual
> CPU model options (other than on x86-64, where GENERIC_CPU is part of
> the choice construct, X86_GENERIC is a separate option on ix86).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Nick Piggin <npiggin@suse.de>
