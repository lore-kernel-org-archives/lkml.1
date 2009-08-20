Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZHTKRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZHTKRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZHTKRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:17:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60112 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZHTKRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:51 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 0/6] Lazy workqueues
Date: Thu, 20 Aug 2009 12:17:35 +0200
Message-Id: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After yesterdays rant on having too many kernel threads and checking
how many I actually have running on this system (531!), I decided to 
try and do something about it.

My goal was to retain the workqueue interface instead of coming up with
a new scheme that required conversion (or converting to slow_work which,
btw, is an awful name :-). I also wanted to retain the affinity
guarantees of workqueues as much as possible.

So this is a first step in that direction, it's probably full of races
and holes, but should get the idea across. It adds a
create_lazy_workqueue() helper, similar to the other variants that we
currently have. A lazy workqueue works like a normal workqueue, except
that it only (by default) starts a core thread instead of threads for
all online CPUs. When work is queued on a lazy workqueue for a CPU
that doesn't have a thread running, it will be placed on the core CPUs
list and that will then create and move the work to the right target.
Should task creation fail, the queued work will be executed on the
core CPU instead. Once a lazy workqueue thread has been idle for a
certain amount of time, it will again exit.

The patch boots here and I exercised the rpciod workqueue and
verified that it gets created, runs on the right CPU, and exits a while
later. So core functionality should be there, even if it has holes.

With this patchset, I am now down to 280 kernel threads on one of my test
boxes. Still too many, but it's a start and a net reduction of 251
threads here, or 47%!

The code can also be pulled from:

  git://git.kernel.dk/linux-2.6-block.git workqueue

-- 
Jens Axboe

