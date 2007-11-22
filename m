Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbXKVBMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbXKVBMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 20:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXKVBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 20:12:26 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45563 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751960AbXKVBM0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 20:12:26 -0500
Date: Thu, 22 Nov 2007 12:12:14 +1100
From: David Chinner <dgc@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122011214.GR114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73oddnhzoq.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 01:49:25AM +0100, Andi Kleen wrote:
> David Chinner <dgc@sgi.com> writes:
> 
> > To ensure that log I/O is issued as the highest priority I/O, set
> > the I/O priority of the log I/O to the highest possible. This will
> > ensure that log I/O is not held up behind bulk data or other
> > metadata I/O as delaying log I/O can pause the entire transaction
> > subsystem. Introduce a new buffer flag to allow us to tag the log
> > buffers so we can discrimiate when issuing the I/O.
> 
> Won't that possible disturb other RT priority users that do not need 
> log IO (e.g. working on preallocated files)? Seems a little
> dangerous.

In all the cases that I know of where ppl are using what could
be considered real-time I/O (e.g. media environments where they
do real-time ingest and playout from the same filesystem) the
real-time ingest processes create the files and do pre-allocation
before doing their I/O. This I/O can get held up behind another
process that is not real time that has issued log I/O. 

Given there is no I/O priority inheritence and having log I/O stall
will stall the entire filesystem, we cannot allow log I/O to
stall in real-time environments. Hence it must have the highest
possible priority to prevent this.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
