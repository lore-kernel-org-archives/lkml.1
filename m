Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYCLL6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYCLL6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYCLL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25759 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYCLL5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:12 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com
Subject: [PATCH 0/7] IO CPU affinity testing series
Date: Wed, 12 Mar 2008 12:55:33 +0100
Message-Id: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a new round of patches to play with io cpu affinity. It can,
as always, also be found in the block git repo. The branch name is
'io-cpu-affinity'.

The major change since last post is the abandonment of the kthread
approach. It was definitely slower then may 'add IPI to signal remote
block softirq' hack. So I decided to base this on the scalable
smp_call_function_single() that Nick posted. I tweaked it a bit to
make it more suitable for my use and also faster.

As for functionality, the only change is that I added a bio hint
that the submitter can use to ask for completion on the same CPU
that submitted the IO. Pass in BIO_CPU_AFFINE for that to occur.

Otherwise the modes are the same as last time:

- You can set a specific cpumask for queuing IO, and the block layer
  will move submitters to one of those CPUs.
- You can set a specific cpumask for completion of IO, in which case
  the block layer will move the completion to one of those CPUs.
- You can set rq_affinity mode, in which case IOs will always be
  completed on the CPU that submitted them.

Look in /sys/block/<dev>/queue/ for the three sysfs variables that
modify this behaviour.

I'd be interested in getting some testing done on this, to see if
it really helps the larger end of the scale. Dave, I know you
have a lot of experience in this area and would appreciate your
input and/or testing. I'm not sure if any of the above modes will
allow you to do what you need for eg XFS - if you want all meta data
IO completed on one (or a set of) CPU(s), then I can add a mode
that will allow you to play with that. Or if something else, give me
some input and we can take it from there!

Patches are against latest -git.

-- 
Jens Axboe


