Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZIGR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZIGR40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZIGR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZIGR4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:56:25 -0400
Message-ID: <4AA54AA7.9080709@redhat.com>
Date: Mon, 07 Sep 2009 21:02:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk>
In-Reply-To: <20090907094953.GP18599@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2009 12:49 PM, Jens Axboe wrote:
>
> I ran a simple test as well, since I was curious to see how it performed
> wrt interactiveness. One of my pet peeves with the current scheduler is
> that I have to nice compile jobs, or my X experience is just awful while
> the compile is running.
>    

I think the problem is that CFS is optimizing for the wrong thing.  It's 
trying to be fair to tasks, but these are meaningless building blocks of 
jobs, which is what the user sees and measures.  Your make -j128 
dominates your interactive task by two orders of magnitude.  If the 
scheduler attempts to bridge this gap using heuristics, it will fail 
badly when it misdetects since it will starve the really important 
100-thread job for a task that was misdetected as interactive.

I think that bash (and the GUI shell) should put any new job (for bash, 
a pipeline; for the GUI, an application launch from the menu) in a 
scheduling group of its own.  This way it will have equal weight in the 
scheduler's eyes with interactive tasks; one will not dominate the 
other.  Of course if the cpu is free the compile job is welcome to use 
all 128 threads.

(similarly, different login sessions should be placed in different jobs 
to avoid a heavily multithreaded screensaver from overwhelming ed).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

