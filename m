Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXDTHqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXDTHqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDTHqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:46:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbXDTHqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:46:07 -0400
Date: Fri, 20 Apr 2007 00:45:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tom Alsberg <alsbergt@cs.huji.ac.il>
Cc: Linux-Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CPU time limit patch / setrlimit(RLIMIT_CPU, 0) cheat fix
Message-Id: <20070420004547.87bd8b94.akpm@linux-foundation.org>
In-Reply-To: <20070417135755.GA55049@cs.huji.ac.il>
References: <20070417135755.GA55049@cs.huji.ac.il>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 16:57:55 +0300 Tom Alsberg <alsbergt@cs.huji.ac.il> wrote:

> Hi there.
> 
> As discovered here today, the change in Kernel 2.6.17 intended to
> inhibit users from setting RLIMIT_CPU to 0 (as that is equivalent to
> unlimited) by "cheating" and setting it to 1 in such a case, does not
> make a difference, as the check is done in the wrong place (too late),
> and only applies to the profiling code.

hm, I tested that.  I guess I must have only tested the profiling limit.

> On all systems I checked running kernels above 2.6.17, no matter what
> the hard and soft CPU time limits were before, a user could escape
> them by issuing in the shell (sh/bash/zsh) "ulimit -t 0", and then the
> user's process was not ever killed.
> 
> Attached is a trivial patch to fix that.  Simply moving the check to a
> slightly earlier location (specifically, before the line that actually
> assigns the limit - *old_rlim = new_rlim), does the trick.
> 
> Do note that at least the zsh (but not ash, dash, or bash) shell has
> the problem of "caching" the limits set by the ulimit command, so when
> running zsh the fix will not immediately be evident - after entering
> "ulimit -t 0", "ulimit -a" will show "-t: cpu time (seconds) 0", even
> though the actual limit as returned by getrlimit(...) will be 1.  It
> can be verified by opening a subshell (which will not have the values
> of the parent shell in cache) and checking in it, or just by running a
> CPU intensive command like "echo '65536^1048576' | bc" and verifying
> that it dumps core after one second.
> 
> Regardless of whether that is a misfeature in the shell, perhaps it
> would be better to return -EINVAL from setrlimit in such a case
> instead of cheating and setting to 1, as that does not really reflect
> the actual state of the process anymore.  I do not however know what
> the ground for that decision was in the original 2.6.17 change, and
> whether there would be any "backward" compatibility issues, so I
> preferred not to touch that right now.

The 2.6.17 changes was done that way allegedly for 2.4 compatibility.
