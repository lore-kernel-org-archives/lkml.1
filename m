Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbZLUUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbZLUUdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZLUUdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:33:19 -0500
Received: from RELAY-01.ANDREW.CMU.EDU ([128.2.10.212]:35540 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZLUUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:33:18 -0500
Date: Mon, 21 Dec 2009 15:32:54 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       bblum@andrew.cmu.edu
Subject: [PATCH 0/4] cgroups: support for module-loadable subsystems
Message-ID: <20091221203253.GA5683@andrew.cmu.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org, lizf@cn.fujitsu.com,
	akpm@linux-foundation.org, menage@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a revision of http://lkml.org/lkml/2009/12/4/53 ]

This patch series implements support for building, loading, and
unloading subsystems as modules, both within and outside the kernel
source tree. It provides an interface cgroup_load_subsys() and
cgroup_unload_subsys() which modular subsystems can use to register and
depart during runtime. The net_cls classifier subsystem serves as the
example for a subsystem which can be converted into a module using these
changes.

Patch #1 sets up the subsys[] array so its contents can be dynamic as
modules appear and (eventually) disappear. Iterations over the array are
modified to handle when subsystems are absent, and the dynamic section
of the array is protected by cgroup_mutex.

Patch #2 implements an interface for modules to load subsystems, called
cgroup_load_subsys, similar to cgroup_init_subsys, and adds a module
pointer in struct cgroup_subsys.

Patch #3 modifies the net_cls subsystem, which already had some module
declarations, to be configurable as a module, which also serves as a
simple proof-of-concept.

Patch #4 adds a mechanism for unloading modular subsystems, which
includes a more advanced rework of the rudimentary reference counting
introduced in patch 2. It also modifies the exitcall of net_cls to use
this interface.

Part of implementing patches 2 and 4 involved updating css pointers in
each css_set when the module appears or leaves. In doing this, it was
discovered that css_sets always remain linked to the dummy cgroup,
regardless of whether or not any subsystems are actually bound to it
(i.e., not mounted on an actual hierarchy). The subsystem loading and
unloading code therefore should keep in mind the special cases where the
added subsystem is the only one in the dummy cgroup (and therefore all
css_sets need to be linked back into it) and where the removed subsys
was the only one in the dummy cgroup (and therefore all css_sets should
be unlinked from it) - however, as all css_sets always stay attached to
the dummy cgroup anyway, these cases are ignored. Any fix that addresses
this issue should also make sure these cases are addressed in the
subsystem loading and unloading code.

-- bblum

---

 Documentation/cgroups/cgroups.txt |    6
 include/linux/cgroup.h            |   16 +
 kernel/cgroup.c                   |  337 +++++++++++++++++++++++++++++++++-----
 net/sched/Kconfig                 |    5
 net/sched/cls_cgroup.c            |   40 +++-
 5 files changed, 350 insertions(+), 54 deletions(-)
