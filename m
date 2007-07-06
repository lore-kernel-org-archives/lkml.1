Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXGFIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXGFIDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbXGFIDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 04:03:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14656 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbXGFIDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 04:03:30 -0400
Message-ID: <468DF6F7.1010906@openvz.org>
Date: Fri, 06 Jul 2007 12:01:59 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 0/16] Pid namespaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is "submition for inclusion" of hierarchical, not kconfig
configurable, zero overheaded ;) pid namespaces.

The overall idea is the following:

The namespace are organized as a tree - once a task is cloned
with CLONE_NEWPIDS (yes, I've also switched to it :) the new
namespace becomes the parent's child and tasks living in the
parent namespace see the tasks from the new one. The numerical
ids are used on the kernel-user boundary, i.e. when we export
pid to user we show the id, that should be used to address the
task in question from the namespace we're exporting this id to.

The main difference from Suka's patches are the following:

0. Suka's patches change the kernel/pid.c code too heavy.
   This set keeps the kernel code look like it was without
   the patches. However, this is a minor issue. The major is:

1. Suka's approach is to remove the notion of the task's 
   numerical pid from the kernel at all. The numbers are 
   used on the kernel-user boundary or within the kernel but
   with the namespace this nr belongs to. This results in 
   massive changes of struct's members fro int pid to struct
   pid *pid, task->pid becomes the virtual id and so on and
   so forth.
   My approach is to keep the good old logic in the kernel. 
   The task->pid is a global and unique pid, find_pid() finds
   the pid by its global id and so on. The virtual ids appear
   on the user-kernel boundary only. Thus drivers and other 
   kernel code may still be unaware of pids unless they do not
   communicate with the userspace and get/put numerical pids.

And some more minor differences:

2. Suka's patches have the limit of pid namespace nesting. 
   My patches do not.

3. Suka assumes that pid namespace can live without proc mount
   and tries to make the code work with pid_ns->proc_mnt change
   from NULL to not-NULL from times to times.
   My code calls the kern_mount() at the namespace creation and
   thus the pid_namespace always works with proc.

There are some small issues that I can describe if someone is
interested.

The tests like nptl perf, unixbench spawn, getpid and others
didn't reveal any performance degradation in init_namespace
with the RHEL5 kernel .config file. I admit, that different
.config-s may show that patches hurt the performance, but the
intention was *not* to make the kernel work worse with popular
distributions.

This set has some ways to move forward, but this is some kind
of a core, that do not change the init_pid_namespace behavior
(checked with LTP tests) and may require some hacking to do 
with the namespaces only.

Patches apply to 2.6.22-rc6-mm1.
