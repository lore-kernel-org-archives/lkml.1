Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYBDElK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYBDElK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYBDEk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:40:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:35790 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752083AbYBDEk4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:40:56 -0500
Date: Mon, 4 Feb 2008 15:40:20 +1100
From: David Chinner <dgc@sgi.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       jens.axboe@oracle.com, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204044020.GE155407@sgi.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com> <47A69135.3060306@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A69135.3060306@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 08:14:45PM -0800, Arjan van de Ven wrote:
> David Chinner wrote:
> >Hi Nick,
> >
> >When Matthew was describing this work at an LCA presentation (not
> >sure whether you were at that presentation or not), Zach came up
> >with the idea that allowing the submitting application control the
> >CPU that the io completion processing was occurring would be a good
> >approach to try.  That is, we submit a "completion cookie" with the
> >bio that indicates where we want completion to run, rather than
> >dictating that completion runs on the submission CPU.
> >
> >The reasoning is that only the higher level context really knows
> >what is optimal, and that changes from application to application.
> 
> well.. kinda. One of the really hard parts of the submit/completion stuff 
> is that
> the slab/slob/slub/slib allocator ends up basically "cycling" memory 
> through the system;
> there's a sink of free memory on all the submission cpus and a source of 
> free memory
> on the completion cpu. I don't think applications are capable of working 
> out what is
> best in this scenario..

Applications as in "anything that calls submit_bio()". i.e, direct I/O,
filesystems, etc. i.e. not userspace but in-kernel applications.

In XFS, simultaneous io completion on multiple CPUs can contribute greatly to
contention of global structures in XFS. By controlling where completions are
delivered, we can greatly reduce this contention, especially on large,
mulitpathed devices that deliver interrupts to multiple CPUs that may be far
distant from each other.  We have all the state and intelligence necessary
to control this sort policy decision effectively.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
