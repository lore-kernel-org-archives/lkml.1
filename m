Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYDCVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYDCVEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYDCVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:03:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49511 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbYDCVDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:03:22 -0400
Message-Id: <20080403210316.397506379@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Apr 2008 14:03:16 -0700
From: matthltc@us.ibm.com
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>
Subject: [RFC PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: Due to problems with my MTA configuration two earlier attempts reached linux-pm
but not linux-kernel. Please cc linux-pm@lists.linux-foundation.org on replies.

This patchset is a prototype using the container infrastructure and
the swsusp freezer to freeze a group of tasks. I've merely taken Cedric's
patches, forward-ported them to 2.6.25-rc8-mm1 and done a small amount of
testing.

2 files are defined by the freezer subsystem in the container
filesystem :

   * "freezer.freeze"

     writing 1 will freeze all tasks and 0 unfreeze
     reading will return the status of the freezer
 
   * "freezer.kill"

     writing <n> will send signal number <n> to all tasks

* Usage :

   # mkdir /containers/freezer
   # mount -t container -ofreezer freezer  /containers/freezer
   # mkdir /containers/freezer/0
   # echo $some_pid > /containers/freezer/0/tasks

to get status of the freezer subsystem :

   # cat /containers/freezer/0/freezer.freeze
   RUNNING

to freeze all tasks in the container :

   # echo 1 > /containers/freezer/0/freezer.freeze
   # cat /containers/freezer/0/freezer.freeze
   FREEZING
   # cat /containers/freezer/0/freezer.freeze
   FROZEN

to unfreeze all tasks in the container :

   # echo 1 > /containers/freezer/0/freezer.freeze
   # cat /containers/freezer/0/freezer.freeze
   RUNNING

to kill all tasks in the container :

   # echo 9 > /containers/freezer/0/freezer.kill

* Caveats: 

  - the FROZEN status is calculated and changed when the container
    file "freezer.freeze" is read.
  - frozen containers will be unfrozen when a system is resumed after 
    a suspend. This is addressed by the last patch.

* Series

  Applies to 2.6.25-rc8-mm1

  The first patches make the freezer available to all architectures
  before implementing the freezer subsystem.

[RFC PATCH 1/4] Add TIF_FREEZE flag to all architectures
[RFC PATCH 2/4] Make refrigerator always available
[RFC PATCH 3/4] Implement freezer cgroup subsystem
[RFC PATCH 4/4] Skip frozen cgroups during power management resume

  Each patch compiles, boots, and survives basic LTP containers and controllers 
  	tests.
  
Comments are welcome.

Cheers,
	-Matt Helsley

-- 
