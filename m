Return-Path: <linux-kernel-owner+w=401wt.eu-S1161169AbXCVWco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169AbXCVWco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXCVWcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:32:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161169AbXCVWcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:32:42 -0400
Date: Thu, 22 Mar 2007 15:32:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: dino@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpusets/sched_domain reconciliation
Message-Id: <20070322153233.3c8551c7.akpm@linux-foundation.org>
In-Reply-To: <20070322223945.GA22206@sgi.com>
References: <4600329B.mailxHGH16L00Y@eag09.americas.sgi.com>
	<20070322142152.5f6fa41c.akpm@linux-foundation.org>
	<20070322223945.GA22206@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 16:39:45 -0600
Cliff Wickman <cpw@sgi.com> wrote:

> Hello Andrew,
> 
> On Thu, Mar 22, 2007 at 02:21:52PM -0700, Andrew Morton wrote:
> > On Tue, 20 Mar 2007 13:14:35 -0600
> > cpw@sgi.com (Cliff Wickman) wrote:
> > 
> > > This patch reconciles cpusets and sched_domains that get out of sync
> > > due to disabling and re-enabling of cpu's.
> > 
> > I get three-out-of-three rejects in cpuset.c.  I could fix them, but I
> > wouldn't be very confident that the result works at runtime.  2.6.20-rc6 was
> > a long time ago - please, always raise patches against the latest mainline
> > kernel (the daily git snapshot suffices).
> 
> Will do.
>  
> > Recursion is a big no-no in kernel.  Is there any way in which it can be
> > avoided?  Is Dinakar's implementation also recursive?
> 
> I was a little reluctant to use recursion, but this use parallels another,
> existing such use in cpuset.c  The depth of the recursion is only the depth of
> the cpuset hierarchy, which is set up by an administrator, and which is
> logically limited by the number of cpus in the system.  e.g. it would be
> hard to even deliberately organize 16 cpus into a hierarchy greater
> than 16 layers deep, even if you wanted cpusets of single cpus.
> We've not run into such a problem on systems of hundreds of cpus.
> I would think it's safe.  What do you think?

It isn't very nice.  It probably won't crash, but it _can_ crash and when
it does, the results will be very obscure and people who will be affected
by the crash will be badly $impacted$ by it.

Perhaps as a middle-ground thing we could simply ban the creation of
cpusets hierarchies which are more than <mumble> layers deep.

Or, worse, we could take a peek at the depth of the tree before starting
the recursion, then just fail out if it exceeds <mumble>

Or, worse still, we could allow the recursion to proceed down <mumble>
levels, then refuse to apply the reconciliation any deeper.

Best would be to avoid the recursion ;) lib/radix-tree.c has a similar
problem, and has a possibly-conceptually-applicable solution.  It has a
fixed maximum depth so it uses a local array, but it could use kmalloc()
for the radix_tree_path.

Is there any sane way in which we can perform the recursion in userspace? 
Get the application to walk the hierarchy and do the fixups at each node? 
Probably not...

> Dinakar's solution is not written yet, as far as I know.  I'll copy him
> for his status.

Good idea.
