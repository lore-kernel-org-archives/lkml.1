Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXHUUv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXHUUv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXHUUvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:51:47 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61917 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752974AbXHUUvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:51:46 -0400
Date: Tue, 21 Aug 2007 16:41:45 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821204145.GA23795@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070821173849.GA8360@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:37:56 up 22 days, 20:56,  4 users,  load average: 0.37, 0.55, 0.57
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Ok, I played with your patch a bit, and the results are quite
> interesting:
> 
...
> Summary:
> 
> (tests repeated 10000 times on a 3GHz Pentium 4)
> (kernel DEBUG menuconfig options are turned off)
> results are in cycles per iteration
> I did 2 runs of the slab.git HEAD to have an idea of errors associated
> to the measurements:
> 
>              |     slab.git HEAD slub (min-max)    |  cmpxchg_local slub
> kmalloc(8)   |         190 - 201                   |         83
> kfree(8)     |         351 - 351                   |        363
> kmalloc(64)  |         224 - 245                   |        115
> kfree(64)    |         389 - 394                   |        397
> kmalloc(16384)|        713 - 741                   |        724
> kfree(16384) |         843 - 856                   |        843
> 
> Therefore, there seems to be a repeatable gain on the kmalloc fast path
> (more than twice faster). No significant performance hit for the kfree
> case, but no gain neither, same for large kmalloc, as expected.
> 

Having no performance improvement for kfree seems a little weird, since
we are moving from irq disable to cmpxchg_local in the fast path. A
possible explanation would be that we are always hitting the slow path.
I did a simple test, counting the number of fast vs slow paths with my
cmpxchg_local slub version:

(initial state before the test)
[  386.359364] Fast slub free: 654982
[  386.369507] Slow slub free: 392195
[  386.379660] SLUB Performance testing
[  386.390361] ========================
[  386.401020] 1. Kmalloc: Repeatedly allocate then free test
...
(after test 1)
[  387.366002] Fast slub free: 657338 diff (2356)
[  387.376158] Slow slub free: 482162 diff (89967)

[  387.386294] 2. Kmalloc: alloc/free test
...
(after test 2)
[  387.897816] Fast slub free: 748968 (diff 91630)
[  387.907947] Slow slub free: 482584 diff (422)

Therefore, in the test where we have separate passes for slub allocation
and free, we hit mostly the slow path. Any particular reason for that ?

Note that the alloc/free test (test 2) seems to hit the fast path as
expected.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
