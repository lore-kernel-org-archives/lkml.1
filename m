Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbXE2N0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbXE2N0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXE2NYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:24:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762471AbXE2NYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:24:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=WPO0vFlUCEqnZPm52vylRn+YAxgLVcw7ZaxOvgnn1weACfFIJ9m5ZRqPMMTesl2p7
	K58Bk0nvHBu+wKkjKqqYg==
Message-Id: <20070529130104.461765000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 29 May 2007 06:01:04 -0700
From: menage@google.com
To: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com
Cc: ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: [PATCH 00/10] Containers(V10): Generic Process Containers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update to my multi-hierarchy multi-subsystem generic
process containers patch. Changes since V9 (April 27th) include:

- The patchset has been rebased over 2.6.22-rc2-mm1

- A lattice of lists linking tasks to their css_groups and css_groups
to their containers has been added to support more efficient iteration
across the member tasks of a container.

- Support for the cpusets "release agent" functionality has been added
back in; this is based on a workqueue concept similar to the changes
that Cliff Wickman has been pushing for supporting CPU hot-unplug.

- Several uses of tasklist_lock replaced by reliance on RCU

- Misc cleanups

- Tested with a tweaked version of PaulJ's cpuset_test script

Still TODO:

- decide whether "Containers" is an acceptable name for the system
given its usage by some other development groups, or whether something
else (ProcessSets? ResourceGroups? TaskGroups?) would be better. I'm
inclined to leave this political decision to Andrew/Linus once they're
happy with the technical aspects of the patches.

- add a hash-table based lookup for css_group objects.

- use seq_file properly in container tasks files to avoid having to
 allocate a big array for all the container's task pointers.

- lots more testing

- define standards for container file names

--

Generic Process Containers
--------------------------

There have recently been various proposals floating around for
resource management/accounting and other task grouping subsystems in
the kernel, including ResGroups, User BeanCounters, NSProxy
containers, and others.  These all need the basic abstraction of being
able to group together multiple processes in an aggregate, in order to
track/limit the resources permitted to those processes, or control
other behaviour of the processes, and all implement this grouping in
different ways.

Already existing in the kernel is the cpuset subsystem; this has a
process grouping mechanism that is mature, tested, and well documented
(particularly with regards to synchronization rules).

This patchset extracts the process grouping code from cpusets into a
generic container system, and makes the cpusets code a client of the
container system, along with a couple of simple example subsystems.

The patch set is structured as follows:

1) Basic container framework - filesystem and tracking structures

2) Simple CPU Accounting example subsystem

3) Support for the "tasks" control file

4) Hooks for fork() and exit()

5) Support for the container_clone() operation

6) Add /proc reporting interface

7) Make cpusets a container subsystem

8) Share container subsystem pointer arrays between tasks with the
   same assignments

9) Simple container debugging subsystem

10) Support for a userspace "release agent", similar to the cpusets
    release agent functionality

The intention is that the various resource management and
virtualization efforts can also become container clients, with the
result that:

- the userspace APIs are (somewhat) normalised

- it's easier to test out e.g. the ResGroups CPU controller in
 conjunction with the BeanCounters memory controller, or use either of
them as the resource-control portion of a virtual server system.

- the additional kernel footprint of any of the competing resource
 management systems is substantially reduced, since it doesn't need
 to provide process grouping/containment, hence improving their
 chances of getting into the kernel

Signed-off-by: Paul Menage <menage@google.com>
