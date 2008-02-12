Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYBLI2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYBLI2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYBLI2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:28:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43436 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbYBLI2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:28:42 -0500
Date: Tue, 12 Feb 2008 00:28:39 -0800
From: Jeremy Higdon <jeremy@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com,
       arjan@linux.intel.com
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080212082839.GA216917@sgi.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk> <20080208073859.GE9730@wotan.suse.de> <20080208074747.GY15220@kernel.dk> <20080208075324.GG9730@wotan.suse.de> <20080208075954.GA15220@kernel.dk> <20080211052211.GS155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211052211.GS155407@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 04:22:11PM +1100, David Chinner wrote:
> 
> What I think Nick is referring to is the comments I made that at a
> higher layer (e.g. filesystems) migrating completions to the
> submitter CPU may be exactly the wrong thing to do. I don't recall
> making any comments on migrating submitters - I think others have
> already commented on that so I'll ignore that for the moment and
> try to explain why completion on submitter CPU /may/ be bad.
> 
> For example, in the case of XFS it is fine for data I/O but it is
> wrong for transaction I/O completion. We want to direct all
> transaction completions to as few CPUs as possible (one, ideally) so
> that all the completion processing happens on the same CPU, rather
> than bouncing global cachelines and locks between all the CPUs
> taking completion interrupts.

So what you want is all XFS processing (for a given filesystem,
presumably) on a limited set of cores (ideally 1) and all block
and SCSI processing (for a given device) on a similarly limited
set.

On Altix, that was far more important than having the interrupt
and issue CPU be close to the hardware -- at least with typical
LSI or Qlogic controllers where there are only one or two MMIO
reads per command issued, and completions can be stacked up.

There is still an advantage to being close to the hardware, but
a much bigger advantage to not bouncing cachelines.

Maybe what you want is a multistage completion mechanism where
each stage can run on a different CPU, if thread context switches
are cheaper than bouncing data structures around....

jeremy
