Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbXFUBlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbXFUBlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 21:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbXFUBk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 21:40:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35017 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbXFUBk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 21:40:56 -0400
Date: Thu, 21 Jun 2007 07:19:35 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: pj@sgi.com
Cc: clameter@sgi.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dinakar Guniguntala <dino@in.ibm.com>,
       akpm@linux-foundation.org
Subject: cpuset attach_task to touch per-cpu kernel threads?
Message-ID: <20070621014935.GF10980@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,
	You had once revealed a cute one-line command to move all tasks from 
one cpuset to another [1], which was:

	# move all tasks from top cpuset to 'foo' cpuset
	sed -nu p < /dev/cpuset/tasks > /dev/cpuset/foo/tasks

I somewhat regret now having fallen for it and using it in my scripts.

To my agony, I found that it moves per-cpu kernel threads too, forcibly
breaking their affinity. In my case, rq->migration thread
(kernel/sched.c) was moved off cpu3 and started running on cpu2, which
caused nasty problems for me. I am sure this can lead to problems for
other per-cpu kernel threads, if their assumption of per-cpu'ness is
broken this way.

One could argue that 'root' user did this and nothing wrong in assuming
he knows what he is doing.

But I am wondering if attach_task() should leave kernel threads alone and
act only upon user-space threads. Or maybe allow movement if it doesn't
result in changing kernel-threads's cpu affinity.

Do you have anything to say regarding this?


Fyi, this was what I was doing (as root):

	#!/bin/bash

	mount -t container -o cpuset none /dev/cpuset
	cd /dev/cpuset
	mkdir sys	# create a cpuset to move all tasks into
	mkdir test	# test cpuset in which my tests will run

	# Assign cpus to both cpusets
	cd sys; echo 0-2 > cpus; echo 0 > mems; echo 1 > cpu_exclusive; cd ..
	cd test; echo 3 > cpus; echo 0 > mems; echo 1 > cpu_exclusive; cd ..

	# Move all tasks to 'sys' cpuset so that cpu3 is dedicated to 
	# only my chosen tasks

	sed -nu p < /dev/cpuset/tasks > /dev/cpuset/tasks

	echo $$ > test/tasks
	/path_to/test_prg


References:

1.  http://marc.info/?l=linux-kernel&m=115627306628524

-- 
Regards,
vatsa
