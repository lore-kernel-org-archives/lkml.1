Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYFSAaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYFSAaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbYFSA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:29:53 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:38038 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbYFSA3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:29:52 -0400
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>
Subject: [RFC/PATCH 0/3] sched: allow arch override of cpu power
Date: Wed, 18 Jun 2008 19:29:31 -0500
Message-Id: <1213835374-10868-1-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
X-Pobox-Relay-ID: D25C744A-3D96-11DD-AF7D-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an "interesting" quality of POWER6 cores, which each have 2
hardware threads: assuming one thread on the core is idle, the primary
thread is a little "faster" than the secondary thread.  To illustrate:

for cpumask in 0x1 0x2 ; do
    taskset $cpumask /usr/bin/time -f "%e elapsed, %U user, %S sys" \
            /bin/sh -c "i=1000000 ; while (( i-- )) ; do : ; done"
done

17.05 elapsed, 16.83 user, 0.22 sys
17.54 elapsed, 17.32 user, 0.22 sys

(The first result is for a primary thread; the second result for a
secondary thread.)

So it would be nice to have the scheduler slightly prefer primary
threads on POWER6 machines.  These patches, which allow the
architecture to override the scheduler's CPU "power" calculation, are
one possible approach, but I'm open to others.  Please note: these
seemed to have the desired effect on 2.6.25-rc kernels (2-3%
improvement in a kernbench-like make -j <nr_cores>), but I'm not
seeing this improvement with 2.6.26-rc kernels for some reason I am
still trying to track down.

Nathan Lynch (3):
  sched: support arch override of sched_group cpu power
  add cpu_power to machdep_calls, override SD_SIBLING_INIT
  adjust cpu power for secondary threads on POWER6

 arch/powerpc/kernel/setup-common.c     |    7 ++++++
 arch/powerpc/platforms/pseries/setup.c |   37 ++++++++++++++++++++++++++++++++
 include/asm-powerpc/cputable.h         |    3 +-
 include/asm-powerpc/machdep.h          |    2 +
 include/asm-powerpc/topology.h         |   31 ++++++++++++++++++++++++++
 include/linux/sched.h                  |    1 +
 kernel/sched.c                         |   14 ++++++++++++
 7 files changed, 94 insertions(+), 1 deletions(-)

