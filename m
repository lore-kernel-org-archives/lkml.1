Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXD0ATG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXD0ATG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXD0ATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:19:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45883 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755220AbXD0ATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:19:04 -0400
Date: Thu, 26 Apr 2007 17:19:00 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427001900.GB413996@sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com> <20070426135033.GU65285596@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426135033.GU65285596@melbourne.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 11:50:33PM +1000, David Chinner wrote:
> On Thu, Apr 26, 2007 at 04:10:32AM -0600, Eric W. Biederman wrote:
> > > And then there's the problem that most hardware is limited to 128
> > > s/g entries and that means 128 non-contiguous pages in memory is the
> > > maximum I/O size we can issue to these devices. We have RAID arrays
> > > that go twice as fast if we can send them 1MB I/Os instead of 512k
> > > I/Os and that means we need contiguous pages to be handled to the
> > > devices....
> > 
> > Ok.  Now why are high end hardware manufacturers building crippled
> > hardware?  Or is there only an 8bit field in SCSI for describing
> > scatter gather entries?  Although I would think this would be
> > move of a controller ranter than a drive issue.
> 
> scsi.h:
> 
> /*
>  *      The maximum sg list length SCSI can cope with
>  *      (currently must be a power of 2 between 32 and 256)
>  */
> #define SCSI_MAX_PHYS_SEGMENTS  MAX_PHYS_SEGMENTS
> 
> And from blkdev.h:
> 
> #define MAX_PHYS_SEGMENTS 128
> #define MAX_HW_SEGMENTS 128
> 
> So currentlt on SCSI we are limited to 128 s/g entries, and the
> maximum is 256.  So I'd say we've got good grounds for needing
> contiguous pages to go beyond 1MB I/O size on x86_64.

Right, and there are also RAID devices that really want a 2 MiB I/O
size.  Even if we could use 512 s/g entries (which would take two
pages), the other big problem is that many I/O chips/cards are limited
in the amount of space they have for s/g lists.  So, you'd face the
possibility that you could do a 2MiB I/O request with 512 s/g entries,
but then you couldn't start a second request on that host until the
first one finished.

jeremy
