Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXJ1Wbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXJ1Wbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXJ1Wbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:31:43 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:42855 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXJ1Wbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:31:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAL6qJEdMQWvU/2dsb2JhbACBWg
Date: Sun, 28 Oct 2007 18:31:40 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "Martin J. Bligh" <mbligh@google.com>,
       Rebecca Schultz <rschultz@google.com>
Subject: Re: [PATCH] Fix x86_64 TIF_SYSCALL_TRACE race in entry.S
Message-ID: <20071028223140.GA11864@Krystal>
References: <20071026193738.GA1591@Krystal> <20071027180837.GA18134@Krystal> <p73sl3wnzty.fsf@bingen.suse.de> <20071028211527.GA9129@Krystal> <20071028212150.GA20321@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071028212150.GA20321@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:16:39 up 90 days, 22:35,  3 users,  load average: 0.26, 0.25, 0.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > Setting the thread flag being an atomic operation, I would expect
> > setting/clearing it asynchronously from another thread to be a valid
> 
> It could be a very short stop. Also do you start kernel tracing that often?
> 

It's not a matter of how often I start tracing, but more about what
impact I want this operation to have on a running production system. If
I start tracing on a server to try detecting particularly nasty race
conditions, I prefer not to interfere with the normal execution too
much. The same applies when we try to figure out the source of some
unexpected latencies experienced in user-space : stopping the processes
could be considered as having too much impact on the system studied.

I was already reluctant about iterating on every thread to set a flag
(this was proposed by Martin and Rebecca, in their Google ktrace
implementation), but I accepted to go forward this solution because of
the performance benefits. However, I would prefer not to go as far as
stopping each process on the system upon trace start/stop to perform
this unless it's the only solution left.

> > Here is a modified version where I add my test only in the path where we
> > know that we have work to do, therefore removing the supplementary test
> > from the performance critical path. Would it be more acceptable ?
> 
> It's better, but stopping would be even better. I wouldn't
> be surprised if there are other problems with async thread flags changing.
>  

Do you mean architectures other than x86_64 could also assume that the
thread flags will stay unchanged between two consecutive reads ? If
those thread flags were meant not to be asynchronously updated, why
would they require an atomic update at all ?


> Also I object to you calling this a bug. It's a new feature.
> 

Agreed. ptrace seems to be correct as is. It would only be needed if we
plan to use the flags as I described TIF_KERNEL_TRACE.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
