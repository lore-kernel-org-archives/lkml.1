Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897Ab0A1DSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0A1DSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 22:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726Ab0A1DSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 22:18:49 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55910 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0A1DSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 22:18:48 -0500
Date: Wed, 27 Jan 2010 21:18:42 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       cl@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix unmap_vma() bug related to mmu_notifiers
Message-ID: <20100128031841.GG6616@sgi.com>
References: <20100125174556.GA23003@sgi.com>
 <20100125190052.GF5756@random.random>
 <20100125211033.GA24272@sgi.com>
 <20100125211615.GH5756@random.random>
 <20100126212904.GE6653@sgi.com>
 <20100126213853.GY30452@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126213853.GY30452@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 10:38:53PM +0100, Andrea Arcangeli wrote:
> On Tue, Jan 26, 2010 at 03:29:04PM -0600, Robin Holt wrote:
> > On Mon, Jan 25, 2010 at 10:16:15PM +0100, Andrea Arcangeli wrote:
> > > The old patches are in my ftp area, they should still apply, you
> > > should concentrate testing with those additional ones applied, then it
> > > will work for xpmem too ;)
> > 
> > Andrea, could you point me at your ftp area?
> 
> Sure, this is the very latest version I maintained:
> 
> http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/

Let me start with what XPMEM currently has.

We adjusted xpmem so that the mmu_notifier_invalidate_page() callout
does not need to sleep.  It takes the arguments passed in and adds them
to a queue for clearing the pages.  We added a seperate kernel thread
which manages this clearing.

The mmu_notifier_invalidate_range_end() likewise does not really need
to sleep either.

That leaves the mmu_notifier_invalidate_range_start() callout.  This does
not need to drop the mm_sem.  It does need to be able to sleep waiting
for the invalidations to complete on the other process.  That other
process may be on a different SSI connected to the same Numalink fabric.

I think that with the SRCU patch, we have enough.  Is that true or have
I missed something?

Thanks,
Robin
