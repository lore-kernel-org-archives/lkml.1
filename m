Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbXFAUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbXFAUoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762805AbXFAUoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:44:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762549AbXFAUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:44:08 -0400
Date: Fri, 1 Jun 2007 13:44:07 -0700
From: Paul Jackson <pj@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@sgi.com, clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601134407.6e4d72de.pj@sgi.com>
In-Reply-To: <466081DE.70205@goop.org>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<466081DE.70205@goop.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this is a good example of why having to special-case kmalloc(0)
> is a bad idea.  The original code was straightforward and, barring
> silliness, should be completely correct with npids==0.  This new code
> does nothing other than make things more complex.

Perhaps so.  Perhaps not.

Actually, the original cpuset pid_array_load() code was not correct,
and Christoph's work is smoking this out.

The original code assumed that it could access the first element of the
kmalloc'd array, before it checked if it could go even further.

But with the kmalloc call of:

	kmalloc(npids * sizeof(pid_t), GFP_KERNEL);

it is impossible for kmalloc to know how much to allocate, to guarantee
such behaviour.  If npids is zero, all kmalloc sees, in essence, is the
call:

	kmalloc(0, GFP_KERNEL);

There is no way it can guess that I might still want to access the
first "size(pid_t)" bytes of whatever it returned.

If we had a different sort of kmalloc API, such as would be called with:

	kmalloc(npids, sizeof(pid_t), GFP_KERNEL);

rather like the libc calloc() routine, having separate count and size
fields, then in theory, kmalloc could treat calls of the form:

	kmalloc(0, sz, GFP_KERNEL);	/* for sz > 0 */

as if they were actually:

	kmalloc(1, sz, GFP_KERNEL);

and then my cpuset code might not have been broken.  But, since
some of us can never remember whether it is the size or the count
that comes first in such an API, we would still have had such
bugs -- just fewer, for those who got those arguments backwards,
and finally tripped over this anyway.

That doesn't address the other likely broken code, elsewhere in
the kernel somewhere that happened to try to access the 2nd or
3rd element of such an empty array before noticing.

So ... while I started this reply agreeing with you, I end up still
agreeing with Christoph's changes here.

Thanks, Christoph, for finding a bug in the cpuset code - good work!

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
