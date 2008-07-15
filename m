Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYGPJT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYGPJT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGPJTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:19:21 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60850 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYGPJTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:19:20 -0400
Message-Id: <20080715211407.423625725@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 23:14:07 +0200
From: <Solofo.Ramangalahy@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH -mm v2 0/3] sysv ipc: increase msgmnb with the number of cpus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size in bytes of a SysV IPC message queue, msgmnb, is too small
for large machines, but we don't want to bloat small machines.

This series increase ("scale") the default value of
/proc/sys/kernel/msgmnb.

Several methods are used already to modify (mainly increase) msgmnb:
. distribution specific patch (e.g. openSUSE)
. system wide sysctl.conf
. application specific tuning via /proc/sys/kernel/msgmnb

Integrating this series would:
. reflect hardware and software evolutions and diversity,
. reduce configuration/tuning for the applications.

Here is the timeline of the evolution of MSG* #defines:
Year             1994    1999    1999    2008     2008
Version           1.0  2.3.27  2.3.30  2.6.25   2.6.26
#define MSGMNI    128     128      16      16 16-32768
#define MSGMAX   4056    8192    8192    8192     8192
#define MSGMNB  16384   16384   16384   16384    16384

This series increases msgmnb with respect to the number of cpus/cores
for larger machines. For uniprocessor machines the value does not
increase. The scaling factor is at most 4x, which leads to a value of
65536.

This series is similar to (and depends on) the series which scales
msgmni, the number of IPC message queue identifiers, to the amount of
low memory.

While Nadia's series scaled msgmni along the memory axis, hence the
message pool (msgmni x msgmnb), this series uses a second axis: the
number of online CPUs.
As well as covering the (cpu,memory) space of machines size, this
reflects the parallelism allowed by lockless send/receive for
in-flight messages in queues (msgmnb / msgmax messages).

The initial scaling is done at initialization of the ipc namespace.
Furthermore, the value becomes dynamic with respect to cpu hotplug,
decreasing/increasing when a cpu is taken offline/online.

As /proc/sys/kernel/msgmni scaling which can be desactived with
/proc/sys/kernel/auto_msgmni, /proc/sys/kernel/msgmnb scaling can be
desactived via /proc/sys/kernel/auto_msgmnb.

The msgmni and msgmnb values become dependent, as the value of msgmni
is computed with respect to the value of msgmnb.

Other solutions could be possible, like using a dbus/hal daemon. This
patches seems light enough not to go to user space. In particular, the
computation formula is simple and the limit rather low (x4 in more
than 10 years) which limits memory consumption for 0-sized messages.

The series is as follows:
. patch 1 introduces the scaling function 
. patch 2 deals with cpu hotplug
. patch 3 deals with auto_msgmnb desactivation/reactivation
--- 

The series applies to 2.6.26-rc8-mm1 + Nadia's patch
"[PATCH 1/1] IPC - Do not use a negative value to re-enable msgmni automatic recomputing"
http://lkml.org/lkml/2008/7/3/135

 Documentation/sysctl/kernel.txt |   35 +++++++++++++++++
 include/linux/ipc_namespace.h   |    6 ++
 include/linux/msg.h             |    7 +++
 ipc/ipc_sysctl.c                |   81 +++++++++++++++++++++++++++++++++++++---
 ipc/ipcns_notifier.c            |   67 ++++++++++++++++++++++++++++++---
 ipc/msg.c                       |   22 ++++++++--
 ipc/namespace.c                 |    2 
 ipc/util.c                      |   29 ++++++++++++++
 ipc/util.h                      |    1 
 9 files changed, 235 insertions(+), 15 deletions(-)

Changelog:

The following changes have been compared to the patch (V1) for
2.6.26-rc5-mm3 (http://lkml.org/lkml/2008/6/24/272):

. adapt to new auto_ method to avoid using a negative value.
  This also addresses the remark about not fully using
  notifiers [Nadia]
  (http://lkml.org/lkml/2008/6/10/31)
. corrected incremental patch compilation [Andrew]
  (http://lkml.org/lkml/2008/7/1/490)
. renamed recompute_msgmnb to ipc_recompute_msgmnb [Andrew]
  (http://lkml.org/lkml/2008/7/1/490)
. Add note about 0-sized messages [Manfred, Nadia]
  (http://lkml.org/lkml/2008/6/25/112)
  if needed, an additional constraint on memory could easily be added.

The following changes have been made compared to the RFC,
(http://lkml.org/lkml/2008/6/6/30):

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
. corrected a bug in the last patch
  (forgot to add braces when adding statement in if) 

-- 
