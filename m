Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXDJDFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXDJDFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXDJDFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:05:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbXDJDFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:05:08 -0400
Date: Mon, 9 Apr 2007 23:05:00 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Preemption Broken:  centrino_target busted under SMP on 2.6.20.4
Message-ID: <20070410030500.GA15509@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Linux kernel <linux-kernel@vger.kernel.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <46155CFF.70701@wolfmountaingroup.com> <20070405205034.GB3605@redhat.com> <20070409172651.9bc619d6.akpm@linux-foundation.org> <20070410023108.GA14081@redhat.com> <20070409194142.88f0a5e5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409194142.88f0a5e5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 07:41:42PM -0700, Andrew Morton wrote:

 > >  > This means we'll call set_cpus_allowed() while in atomic state, but
 > >  > set_cpus_allowed() does sleepy stuff.
 > > 
 > > Puzzled. This diff shouldn't change anything about the context we're in
 > > when we call set_cpus_allowed, and as we're not seeing warnings now,
 > > I'm not sure what I'm missing?
 > 
 > set_cpus_allowed() will only sleep in special circumstances: when we're
 > telling the target task that it is not allwed to run on a CPU upon which it
 > is presently executing.  So it needs to be synchronously migrated off that
 > CPU, which requires that the set_cpus_allowed() caller block.
 > 
 > You're probably just not hitting that case.

Oh, now I see it. The set_cpus_allowed that was inside the preempt stuff
I was adding. (that the diff elided).  Yeah, that's a problem. Bugger.

 > Probably we should have a might_sleep() in set_cpus_allowed(), although
 > there might be callers who are guaranteeed to never hit that case and who
 > might legitimately want special treatment to avoid the warning.

This whole file is going away in .22, and we have a viable alternative in
.21 (acpi-cpufreq), so I'm not overly worried about fixing this up
given it only shows up in debug kernels, especially at this stage in -rc.

(Yeah, it's a cop-out, but unless someone with more interest in this problem
 steps up, I've bigger fishes to fry).

	Dave

-- 
http://www.codemonkey.org.uk
