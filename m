Return-Path: <linux-kernel-owner+w=401wt.eu-S1761883AbYFXPPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883AbYFXPPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbYFXPPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:15:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47652 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbYFXPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:15:39 -0400
Message-Id: <20080624093452.946878437@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 11:34:52 +0200
From: <Solofo.Ramangalahy@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH -mm 0/3] sysv ipc: increase msgmnb with the number of cpus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size in bytes of a SysV IPC message queue, msgmnb, is too small
for large machines, but we don't want to bloat small machines.

This series change ("scale") the default value of
/proc/sys/kernel/msgmnb.

Several methods are used already to modify (mainly increase) msgmnb:
. distribution specific patch (e.g. openSUSE)
. system wide sysctl.conf
. application specific tuning via /proc/sys/kernel/msgmnb

Integrating this series would:
. reflect hardware and software evolutions and diversity,
. reduce configuration/tuning for the applications.

Here is the timeline of the evolution of MSG* #defines:
Year             1994         1999         1999          2008
Version           1.0       2.3.27       2.3.30        2.6.24
#define MSGMNI    128          128           16            16
#define MSGMAX   4056         8192         8192          8192
#define MSGMNB  16384        16384        16384         16384

This patch series increases msgmnb with respect to the number of
cpus/cores for larger machines. For uniprocessor machines the value
does not increase.

This series is similar to (and depends on) the series which scales
msgmni, the number of IPC message queue identifiers, to the amount of
low memory.
While Nadia's previous series scaled msgmni along the memory axis,
hence the message pool (msgmni x msgmnb), this series uses a second
axis: the number of online CPUs.
As well as covering the (cpu,memory) space of machines size, this
reflects the parallelism allowed by lockless send/receive for
in-flight messages in queues (msgmnb / msgmax messages).

The initial scaling is done at initialization of the ipc namespace.
Furthermore, the value becomes dynamic with respect to cpu hotplug,
decreasing/increasing when a cpu is taken offline/online.

The msgmni and msgmnb values become dependent, as the value of msgmni
is computed with respect to the value of msgmnb.

Other solutions could be possible, like using a dbus/hal daemon. This
patches seems light enough not to go to user space. In particular, the
computation formula is simple.

The series is as follows:
. patch 1 introduces the scaling function 
. patch 2 deals with cpu hotplug
. patch 3 finer grain disabling/reenabling scaling mechanism
          (disconnect msgmnb and msgmni)
--- 

The series applies to 2.6.26-rc5-mm3

Compared to the RFC, the following changes have been made:

. reduce use of "scale" word which leads to confusion about the fact
  that this is not directly a performance patch [Nick]
. mention that the formula is simple, not needing logarithm (or user
  space) [Nick]
. example of distribution using patch [Manfred]
. mention hal/dbus daemon [Manfred]
. do not reenable msgmni recomputation when reenabling msgmnb. It
  suffices to do a one shot recomputation [Nadia]
. patch 3 and 4 have been merged with patch 1 [Nadia]
. Integrated documentation with patch [Matt]

Thanks for the help!

. corrected a bug in the last patch
  (forgot to add braces when adding statement in if) 



The last remark of Nadia about the third patch has not been addressed
(other than keeping it like that):
"Doing this, we are completly loosing the benefits of the notification
chains: since the the notifier blocks remain registered + we are
unconditionally adding a test at the top of each recompute routine. But
the other choice would have been to define another notifier chain
dedicated to msgmnb. I'm not convinced about what is the best solution?"

 Documentation/sysctl/kernel.txt |   27 +++++++++++++++++++
 include/linux/ipc_namespace.h   |    4 ++
 include/linux/msg.h             |    5 +++
 ipc/ipc_sysctl.c                |   56 ++++++++++++++++++++++++++++++----------
 ipc/ipcns_notifier.c            |   23 ++++++----------
 ipc/msg.c                       |   23 +++++++++++++---
 ipc/util.c                      |   28 ++++++++++++++++++++
 ipc/util.h                      |    1
 8 files changed, 135 insertions(+), 32 deletions(-)

-- 
