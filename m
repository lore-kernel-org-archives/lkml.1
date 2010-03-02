Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0CBGwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:52:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:34063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0CBGwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:52:34 -0500
Date: Tue, 2 Mar 2010 17:52:25 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when __GFP_COLD is
 set"
Message-ID: <20100302065225.GC8653@laptop>
References: <4B742C2C.5080305@linux.vnet.ibm.com>
 <20100212100519.GA29085@laptop>
 <4B796C6D.80800@linux.vnet.ibm.com>
 <20100216112517.GE1194@csn.ul.ie>
 <4B7ACC1E.9080205@linux.vnet.ibm.com>
 <4B7BBCFC.4090101@linux.vnet.ibm.com>
 <20100218114310.GC32626@csn.ul.ie>
 <4B7D664C.20507@linux.vnet.ibm.com>
 <4B7E73BF.5030901@linux.vnet.ibm.com>
 <20100219151934.GA1445@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100219151934.GA1445@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 03:19:34PM +0000, Mel Gorman wrote:
> On Fri, Feb 19, 2010 at 12:19:27PM +0100, Christian Ehrhardt wrote:
> > Eventually it might come down to a discussion of allocation priorities and
> > we might even keep them as is and accept this issue - I still would prefer
> > a good second chance implementation, other page cache allocation flags or
> > something else that explicitly solves this issue.
> >
> 
> In that line, the patch that replaced congestion_wait() with a waitqueue
> makes some sense.
> 
> > Mel's patch that replaces congestion_wait with a wait for the zone watermarks
> > becoming available again is definitely a step in the right direction and
> > should go into upstream and the long term support branches.
> 
> I'll need to do a number of tests before I can move that upstream but I
> don't think it's a merge candidate. Unfortunately, I'll be offline for a
> week starting tomorrow so I won't be able to do the testing.
> 
> When I get back, I'll revisit those patches with the view to pushing
> them upstream. I hate to treat symptoms here without knowing the
> underlying problem but this has been spinning in circles for ages with
> little forward progress :(

The zone pressure waitqueue patch makes sense. We may even want to make
it more strictly FIFO (eg. check upfront if there are waiters on the
queue before allocating a page, and if yes then add ourself to the back
of the waitqueue). And also possibly even look at doing the wakeups in
the page-freeing path. Although that might start adding too much
overhead, so it's quite possible your sloppy-but-lighter timeout
approach is preferable.

