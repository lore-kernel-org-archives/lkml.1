Return-Path: <linux-kernel-owner+w=401wt.eu-S1751348AbYBDKKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbYBDKKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYBDKKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:10:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:42126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYBDKKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:10:04 -0500
Date: Mon, 4 Feb 2008 11:09:59 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       jens.axboe@oracle.com, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204100959.GA15210@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com> <47A69135.3060306@linux.intel.com> <20080204044020.GE155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204044020.GE155407@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 03:40:20PM +1100, David Chinner wrote:
> On Sun, Feb 03, 2008 at 08:14:45PM -0800, Arjan van de Ven wrote:
> > David Chinner wrote:
> > >Hi Nick,
> > >
> > >When Matthew was describing this work at an LCA presentation (not
> > >sure whether you were at that presentation or not), Zach came up
> > >with the idea that allowing the submitting application control the
> > >CPU that the io completion processing was occurring would be a good
> > >approach to try.  That is, we submit a "completion cookie" with the
> > >bio that indicates where we want completion to run, rather than
> > >dictating that completion runs on the submission CPU.
> > >
> > >The reasoning is that only the higher level context really knows
> > >what is optimal, and that changes from application to application.
> > 
> > well.. kinda. One of the really hard parts of the submit/completion stuff 
> > is that
> > the slab/slob/slub/slib allocator ends up basically "cycling" memory 
> > through the system;
> > there's a sink of free memory on all the submission cpus and a source of 
> > free memory
> > on the completion cpu. I don't think applications are capable of working 
> > out what is
> > best in this scenario..
> 
> Applications as in "anything that calls submit_bio()". i.e, direct I/O,
> filesystems, etc. i.e. not userspace but in-kernel applications.
> 
> In XFS, simultaneous io completion on multiple CPUs can contribute greatly to
> contention of global structures in XFS. By controlling where completions are
> delivered, we can greatly reduce this contention, especially on large,
> mulitpathed devices that deliver interrupts to multiple CPUs that may be far
> distant from each other.  We have all the state and intelligence necessary
> to control this sort policy decision effectively.....

Hi Dave,

Thanks for taking a look at the patch... yes it would be easy to turn
this bit of state into a more flexible cookie (eg. complete on submitter;
complete on interrupt; complete on CPUx/nodex etc.). Maybe we'll need
something that complex... I'm not sure, it would probably need more
fine tuning. That said, I just wanted to get this approach out there
early for rfc.

I guess both you and Arjan have points. For a _lot_ of things, completing
on the same CPU as submitter (whether that is migrating submission as in
the original patch in the thread, or migrating completion like I do).

You get better behaviour in the slab and page allocators and locality
and cache hotness of memory. For example, I guess in a filesystem /
pagecache heavy workload, you have to touch each struct page, buffer head,
fs private state, and also often have to wake the thread for completion.
Much of this data has just been touched at submit time, so doin this on
the same CPU is nice...

I'm surprised that the xfs global state bouncing would outweigh the
bouncing of all the per-page/block/bio/request/etc data that gets touched
during completion. We'll see.

