Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbXFAUyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbXFAUyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764200AbXFAUy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:54:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35689 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764154AbXFAUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:54:24 -0400
Date: Fri, 1 Jun 2007 13:54:22 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601135422.eab28766.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011340110.4323@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
	<20070601121114.b165f1e8.pj@sgi.com>
	<Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
	<20070601124757.fe91a002.pj@sgi.com>
	<Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
	<20070601130212.7be4432a.pj@sgi.com>
	<Pine.LNX.4.64.0706011305230.3976@schroedinger.engr.sgi.com>
	<20070601131950.0f3a507b.pj@sgi.com>
	<Pine.LNX.4.64.0706011340110.4323@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> Then you are deferencing an element in the pidarray that you did not 
> allocate! This is a bug in cpuset code.

Absolutely - as I described in more detail in a reply Jeremy a
few minutes ago.  Thanks for smoking it out.

If, as I suggested in my previous message to which you are
responding:

> Perhaps if you moved the "if (unlikely(n == npids))" test before the
> "pidarray[n++] = p->pid" assignment, it would be safe.

then it looks safe to me, without having to add the bogus "+1" to
the allocated size.  That is, I suspect the following patch fixes
this long standing cpuset bug (warning - white space mangled):

--- kernel/cpuset.c     2006-12-10 12:27:37.000000000 -0800
+++ kernel/cpuset.c.new 2007-06-01 13:53:00.271010074 -0700
@@ -1661,9 +1661,9 @@ static int pid_array_load(pid_t *pidarra

        do_each_thread(g, p) {
                if (p->cpuset == cs) {
-                       pidarray[n++] = p->pid;
                        if (unlikely(n == npids))
                                goto array_full;
+                       pidarray[n++] = p->pid;
                }
        } while_each_thread(g, p);


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
