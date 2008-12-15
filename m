Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYLOOxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYLOOxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYLOOxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:53:21 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:35778 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbYLOOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:53:20 -0500
Message-Id: <20081215143437.843064041@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 15:34:37 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: mingo@elte.hu, akpm@linux-foundation.org
Cc: maxk@qualcomm.com, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH/RESEND 0/2] sched: re-add removed arch_update_cpu_topology call
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduced with
e761b7725234276a802322549cee5255305a0930 ("cpu hotplug, sched:
Introduce cpu_active_map and redo sched domain managment (take 2)":

arch_reinit_sched_domains used to call arch_update_cpu_topology
via arch_init_sched_domains. This call got lost with the above
mentioned patch.

So we might end up with outdated and missing cpus in the cpu core
maps (s390 used to call arch_reinit_sched_domains if cpu topology changed).

This patch set changes arch_update_cpu_topology so that it can indicate
if the cpu topology changed and adds a call to arch_update_cpu_topology
in partition_sched_domains which gets called whenever scheduling domains
get updated.
So whenever architecture code detects that cpu topology changed it might
force an update of the scheduling domains by calling arch_reinit_sched_domains
or rebuild_sched_domains.

Besides that the first patch also adds a comment to arch_update_cpu_topology
so that its purpose gets described, since most people seem to expect that
cpu core mappings are stable which isn't necessarily the case.
