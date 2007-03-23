Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbXCWFHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbXCWFHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933631AbXCWFHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:07:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56816 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933634AbXCWFHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:07:16 -0400
Date: Thu, 22 Mar 2007 22:07:13 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cpw@sgi.com, dino@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpusets/sched_domain reconciliation
Message-Id: <20070322220713.10072423.pj@sgi.com>
In-Reply-To: <20070322153233.3c8551c7.akpm@linux-foundation.org>
References: <4600329B.mailxHGH16L00Y@eag09.americas.sgi.com>
	<20070322142152.5f6fa41c.akpm@linux-foundation.org>
	<20070322223945.GA22206@sgi.com>
	<20070322153233.3c8551c7.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> It isn't very nice.  It probably won't crash, but it _can_ crash and when

I guess I got lucky, Cliff, when I snuck in the recursion in the
other cpuset.c routines that you were using as an example here ;).

Since the current kernel/cpuset.c recursion seems only to be in code
paths for cpu hot unplug, it's not surprising that no one has actually
hit it enough times so far to motivate them to hunt me down and
exterminate me.  The intersection of the worlds heavy cpuset users
with the worlds heavy cpu unpluggers is a very small set indeed.

Maybe we should do something about this before that set of people grows
to include someone with violent tendencies.

I suppose it would work to set a hard coded limit to how deep one
could make the cpuset hierarchy, and perhaps provide a kernel tunable
for those rare cases where someone needed more than this limit.

We could avoid the recursion here, by converting it to its iterative
equivalent.  This equivlaent would have to keep track in a dynamically
allocator vector the cpuset pointers being worked, and if it got to the
end of that vector, reallocate a longer one.

It's not that much more code - and it's a fairly simple transformation
of a simple recursion on one variable to an iteration using a vector
of that variable.

Since the iterative code, using a dynamically sized vector, probably
doesn't add much more kernel text than the code to limit the depth and
provide for a kernel tunable to tweak the limit, and since the iterative
approach avoids imposing some arbitrary small limit on the user visible
API for what is really a small corner case, the iterative approach seems
like the better idea.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
