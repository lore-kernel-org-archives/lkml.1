Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbXFASNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbXFASNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762014AbXFASNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:13:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55968 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760692AbXFASNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:13:46 -0400
Date: Fri, 1 Jun 2007 11:13:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srinivasa Ds <srinivasa@in.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <200706011620.05756.srinivasa@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Srinivasa Ds wrote:

> I have modified the patch little bit, Thanks Vatsa for input and hence 
> resending it. Please let me know your comments on this.

Hmmmm.... Isnt it easier to set the pidarray to NULL in the case it
has no objects? Then any deferences will fail. Paul?


---
 kernel/cpuset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c	2007-06-01 11:09:39.000000000 -0700
+++ linux-2.6/kernel/cpuset.c	2007-06-01 11:11:59.000000000 -0700
@@ -1723,7 +1723,7 @@ static int cpuset_tasks_open(struct inod
 {
 	struct cpuset *cs = __d_cs(file->f_path.dentry->d_parent);
 	struct ctr_struct *ctr;
-	pid_t *pidarray;
+	pid_t *pidarray = NULL;
 	int npids;
 	char c;
 
@@ -1741,9 +1741,11 @@ static int cpuset_tasks_open(struct inod
 	 * show up until sometime later on.
 	 */
 	npids = atomic_read(&cs->count);
-	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
-	if (!pidarray)
-		goto err1;
+	if (npids)
+		pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+		if (!pidarray)
+			goto err1;
+	}
 
 	npids = pid_array_load(pidarray, npids, cs);
 	sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
