Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbXD0LPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbXD0LPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXD0LPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:15:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbXD0LPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:15:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=ENVcSaxVE7f24St7C7qpPBbLCIP+0MFNN1YHOGbbGX6xHJKNl2Y9ba+d2BZsMNM2c
	gxR4ybJrJaXRr5FFOQ6dQ==
Message-Id: <20070427104607.252541000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Fri, 27 Apr 2007 03:46:07 -0700
From: menage@google.com
To: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com
Cc: ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: [PATCH 0/9] Containers (V9): Generic Process Containers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--

This is an update to my multi-hierarchy multi-subsystem generic
process containers patch. Changes since V8 (April 6th) include:

- The patchset has been rebased over 2.6.21-rc7-mm1

- The patchset has been restructured based on feedback; more
  functionality is now split out into separate patches where
  practical.

- The container_group structure has been renamed css_group since this
  is more descriptive of its true function

- Added a simplified file registration interface, and a simple
  interface for the common operation of returning a single number to
  userspace from a container control file

- Added a simple "debug" subsystem that is both an example of how to
  use the container system and a useful debugging tool for checking
  reference counts, etc.

Still TODO:

- decide whether "Containers" is an acceptable name for the system
given its usage by some other development groups, or whether something
else (ProcessSets? ResourceGroups? TaskGroups?) would be better

- decide whether merging css_group and nsproxy is desirable

- add a hash-table based lookup for css_group objects.

- use seq_file properly in container tasks files to avoid having to
  allocate a big array for all the container's task pointers.

- add back support for the "release agent" functionality

- lots more testing

- define standards for container file names

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
