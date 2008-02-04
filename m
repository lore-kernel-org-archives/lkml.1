Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYBDCLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYBDCLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYBDCLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:11:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49554 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755104AbYBDCLc (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:11:32 -0500
Date: Mon, 4 Feb 2008 13:10:52 +1100
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@SteelEye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204021052.GD155407@sgi.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203095252.GA11043@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 10:52:52AM +0100, Nick Piggin wrote:
> On Fri, Jul 27, 2007 at 06:21:28PM -0700, Suresh B wrote:
> > 
> > Second experiment which we did was migrating the IO submission to the
> > IO completion cpu. Instead of submitting the IO on the same cpu where the
> > request arrived, in this experiment  the IO submission gets migrated to the
> > cpu that is processing IO completions(interrupt). This will minimize the
> > access to remote cachelines (that happens in timers, slab, scsi layers). The
> > IO submission request is forwarded to the kblockd thread on the cpu receiving
> > the interrupts. As part of this, we also made kblockd thread on each cpu as the
> > highest priority thread, so that IO gets submitted as soon as possible on the
> > interrupt cpu with out any delay. On x86_64 SMP platform with 16 cores, this
> > resulted in 2% performance improvement and 3.3% improvement on two node ia64
> > platform.
> > 
> > Quick and dirty prototype patch(not meant for inclusion) for this io migration
> > experiment is appended to this e-mail.
> > 
> > Observation #1 mentioned above is also applicable to this experiment. CPU's
> > processing interrupts will now have to cater IO submission/processing
> > load aswell.
> > 
> > Observation #2: This introduces some migration overhead during IO submission.
> > With the current prototype, every incoming IO request results in an IPI and
> > context switch(to kblockd thread) on the interrupt processing cpu.
> > This issue needs to be addressed and main challenge to address is
> > the efficient mechanism of doing this IO migration(how much batching to do and
> > when to send the migrate request?), so that we don't delay the IO much and at
> > the same point, don't cause much overhead during migration.
> 
> Hi guys,
> 
> Just had another way we might do this. Migrate the completions out to
> the submitting CPUs rather than migrate submission into the completing
> CPU.

Hi Nick,

When Matthew was describing this work at an LCA presentation (not
sure whether you were at that presentation or not), Zach came up
with the idea that allowing the submitting application control the
CPU that the io completion processing was occurring would be a good
approach to try.  That is, we submit a "completion cookie" with the
bio that indicates where we want completion to run, rather than
dictating that completion runs on the submission CPU.

The reasoning is that only the higher level context really knows
what is optimal, and that changes from application to application.
The "complete on the submission CPU" policy _may_ be more optimal
for database workloads, but it is definitely suboptimal for XFS and
transaction I/O completion handling because it simply drags a bunch
of global filesystem state around between all the CPUs running
completions. In that case, we really only want a single CPU to be
handling the completions.....

(Zach - please correct me if I've missed anything)

Looking at your patch - if you turn it around so that the
"submission CPU" field can be specified as the "completion cpu" then
I think the patch will expose the policy knobs needed to do the
above. Add the bio -> rq linkage to enable filesystems and DIO to
control the completion CPU field and we're almost done.... ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
