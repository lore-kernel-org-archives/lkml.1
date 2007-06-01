Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbXFAWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbXFAWic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXFAWiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:38:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46549 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXFAWiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:38:23 -0400
Date: Fri, 1 Jun 2007 15:39:31 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
Message-ID: <20070601223931.GB13751@tree.beaverton.ibm.com>
References: <460C5D24.608@us.ibm.com> <653FFBB4508B9042B5D43DC9E18836F52DF4D8@scsmsx415.amr.corp.intel.com> <20070601184342.GA13751@tree.beaverton.ibm.com> <p73ejkvbblo.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejkvbblo.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 11:37:07PM +0200, Andi Kleen wrote:
> > On Thu, Mar 29, 2007 at 06:06:22PM -0700, Pallipadi, Venkatesh wrote:

> How would that work? You would adjust the power cap dynamically during
> runtime based on the power meter feedback?  How long would 
> the adjustment interval be?

Yep, I adjust scaling_max_frequency as needed.  The adjustment is
currently done once per minute, though I've noticed that the BMC power meter
itself can react in about 10-15 seconds.  Incidentally, the ACPI battery
meter seems to react in about 2-5 seconds on my T40.  I suspect that I
could lower that adjustment interval even further, though on the AMD box
(x3755) the power meter is slow to read under high loads.

> Not sure affected CPUs is accurate enough for your purposes anyways.
> It cannot express "other core can be independent if I'm idle, otherwise not"
> which is common on Intel systems.

Yep, this is true too.  Right now I'm using CPU offlining as a clumsy
mechanism to force a CPU into idle state; even with the incorrect
assumption that affected_cpus applies to forced idleness, it seems to
work ok.  We can end up losing more cores than we need to, but so far it
has always been the case that we don't offline cores until we've run out
of lower p-states on all cores.  But I imagine with 80-core behemoths
on the way, I ought to fix this particular bug somehow.  It will
probably involve adding a transition rule for each of the
non-lowest-numbered CPUs in a cpufreq domain between 0 and whatever
speed the lowest numbered CPU is in that domain is running at.

--D
