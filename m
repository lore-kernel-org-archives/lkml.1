Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbXFAUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbXFAUnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762435AbXFAUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:43:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35180 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762327AbXFAUnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:43:07 -0400
Date: Fri, 1 Jun 2007 13:43:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601131950.0f3a507b.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0706011340110.4323@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
 <20070601121114.b165f1e8.pj@sgi.com> <Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
 <20070601124757.fe91a002.pj@sgi.com> <Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
 <20070601130212.7be4432a.pj@sgi.com> <Pine.LNX.4.64.0706011305230.3976@schroedinger.engr.sgi.com>
 <20070601131950.0f3a507b.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Paul Jackson wrote:

> > There are no checks necessary. Your function worked fine so far for 
> > the case of zero objects with the pointer returned by kmalloc. If the 
> > code is correct then it will not dereference the pointer to the zero 
> > sized array. If not then we may find a bug and fix it.
> 
> I suspect you got lucky.  The check for a full pidarray[] in the routine
> pid_array_load() occurs -after- a pid is put in the array.  If a task
> showed up in this cpuset at the wrong time, we would fall over and die
> in the code:

Then you are deferencing an element in the pidarray that you did not 
allocate! This is a bug in cpuset code. So we would need to allocate at 
mininum one array element? Or would we need to allocate npids + 1 to be 
safe???


---
 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c	2007-06-01 13:41:24.000000000 -0700
+++ linux-2.6/kernel/cpuset.c	2007-06-01 13:42:08.000000000 -0700
@@ -1741,7 +1741,7 @@ static int cpuset_tasks_open(struct inod
 	 * show up until sometime later on.
 	 */
 	npids = atomic_read(&cs->count);
-	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+	pidarray = kmalloc(max(1, npids) * sizeof(pid_t), GFP_KERNEL);
 	if (!pidarray)
 		goto err1;
 
