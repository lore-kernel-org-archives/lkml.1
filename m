Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZBSMOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZBSMOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZBSMOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:14:21 -0500
Received: from ozlabs.org ([203.10.76.45]:48314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZBSMOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:14:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Date: Thu, 19 Feb 2009 22:44:14 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192121.55157.rusty@rustcorp.com.au> <20090219110631.GJ2354@elte.hu>
In-Reply-To: <20090219110631.GJ2354@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192244.15055.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 21:36:31 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Thursday 19 February 2009 00:13:31 Ingo Molnar wrote:
> > > 
> > > * Tejun Heo <tj@kernel.org> wrote:
> > > 
> > > >   0001-vmalloc-call-flush_cache_vunmap-from-unmap_kernel.patch
> > > >   0002-module-fix-out-of-range-memory-access.patch
> > > 
> > > Hm, these two seem to be .29 material too, agreed?
> > > 
> > > Rusty, if the fixes are fine with you i can put those two 
> > > commits into tip/core/urgent straight away, the full string of 
> > > 10 commits into tip/core/percpu and thus we'd avoid duplicate 
> > > (or even conflicting) commits.
> > 
> > No, the second one is not .29 material; it's a nice, but 
> > theoretical, fix.
> 
> Can it never trigger?

Actually, checked again.  It's not even necessary AFAICT (tho a comment
would be nice):

	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
		/* Extra for alignment requirement. */
		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
		BUG_ON(i == 0 && extra != 0);

		if (pcpu_size[i] < 0 || pcpu_size[i] < extra + size)
			continue;

		/* Transfer extra to previous block. */
		if (pcpu_size[i-1] < 0)
			pcpu_size[i-1] -= extra;
		else
			pcpu_size[i-1] += extra;

pcpu_size[0] is *always* negative: it's marked allocated at initialization
(it's the static per-cpu allocations).

Sorry I didn't examine more closely,
Rusty.
