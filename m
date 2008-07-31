Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYGaNhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYGaNhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYGaNhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:37:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36872 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751496AbYGaNhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:37:08 -0400
Date: Thu, 31 Jul 2008 08:37:06 -0500
From: Paul Jackson <pj@sgi.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
Message-Id: <20080731083706.e6bd4acc.pj@sgi.com>
In-Reply-To: <4891B9E0.2090900@cn.fujitsu.com>
References: <48912FDD.8060006@cn.fujitsu.com>
	<20080731072355.b582b2d6.pj@sgi.com>
	<4891B9E0.2090900@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai wrote:
> cgroup_task_count() was called twice in every loop. IMO, it's not need.

Ah - true - but I suspect you are trying to optimize the code runtime
(reduce CPU cycles) whereas I am trying to optimize the source code
readability for humans.

Optimizing out the second cgroup_task_count() then requires more
subtle semantics on the pre and post conditions on the ntasks variable
at various points in the code.  This makes it slightly harder for
humans to understand the code.  That in turn increases the chances
of a subsequent change to the code introducing a bug, because the
author of that subsequent change didn't quite realize all the details
that mattered.  Contributing to the introduction of just one bug in
that code loop, at anytime in our lifetimes, would probably cause far
more grief than anything we are trying to fix today.

> My patch has an additional line: fudge += fudge >> 3;
> This line will reduce loop times remarkably when loop times is large.
> (but also loop times is large just in theory)

Agreed to this much at least: "just in theory".

I don't usually add code lines to optimize a case that is just in
theory, in code paths that are not critical, when even without the
added code line, it would still work just fine.  For one thing, that
hurts all the normal cases by slightly increasing the kernel text size,
hence slightly increasing the number of cache hit misses executing this
piece of code.

But more importantly, it is one more bit of stuff for humans to
have to read in the code.

I prefer to only add kernel source code complexity when it is needed
in practice for correct function or necessary performance.  The above
more rapid growth of fudge is not needed for either reason, so far as
I can tell.

Bottom line - my priorities for non-critical code paths, most important first:
 1) It must work.
 2) Keep it easy for humans to understand.
 3) Reduce kernel text size.
 4) Reduce CPU cycles.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
