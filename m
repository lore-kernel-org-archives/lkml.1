Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbZE2Slt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbZE2Slt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZE2Sln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:41:43 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28931 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZE2Slm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:41:42 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz14c3M4015Lzz1202hzzz32i6bh17ch)
X-FB-SS: 5,
X-WSS-ID: 0KKF590-01-ENO-01
Date: Fri, 29 May 2009 20:40:23 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v2] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090529184023.GD23770@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 29 May 2009 18:41:05.0924 (UTC) FILETIME=[0667B440:01C9E08D]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Second attempt to fix CPU topology representation for multi-node
processors.

Using topology information from /sys/devices/system/cpu/cpu*/topology
you can identify

 phys_package by physical_package_id
 core         by core_id + physical_package_id

Corresponding sibling information is

  Level        | Set of CPUs
 --------------|---------------
  phys_package | core_siblings
  core         | thread_siblings
  thread       | one CPU

Example:

  cpu19: physical_package_id        : 1
  cpu19: core_id                    : 7
  cpu19: thread_siblings            : 00080000
  cpu19: thread_siblings_list       : 19
  cpu19: core_siblings              : 00fff000
  cpu19: core_siblings_list         : 12-23

I am adding cpu_node_id, cpu_node_siblings, cpu_node_siblings_list
to get the complete hierarchy. Now you can identify

 phys_package by physical_package_id
 cpu_node     by physical_package_id + cpu_node_id
 core         by physical_package_id + cpu_node_id + core_id

In contrast to first patch set I don't change the meaning of
core_siblings. Thus we have following sets of CPUs on a socket

  Level        | Set of CPUs
 --------------|---------------
  phys_package | core_siblings
  cpu_node     | cpu_node_siblings
  core         | thread_siblings
  thread       | one CPU

Example:

  cpu19: physical_package_id        : 1
  cpu19: core_id                    : 1
  cpu19: thread_siblings            : 00080000
  cpu19: thread_siblings_list       : 19
  cpu19: cpu_node_id                : 0
  cpu19: cpu_node_siblings          : 00fc0000
  cpu19: cpu_node_siblings_list     : 18-23
  cpu19: core_siblings              : 00fff000
  cpu19: core_siblings_list         : 12-23

The cpu_node level information is stored in struct cpuinfo_x86.cpu_node_id
and in cpu_node_map. It can be accessed using topology_cpu_node_id(cpu)
and topology_cpu_node_cpumask(cpu).

Note:
 A cpu_node is a functional unit. In case of AMD Magny-Cours it
 contains a number of cores, configuration registers, memory
 controler, ... A cpu_node is _not_ necessarily a NUMA node.

 If you doubt this. Think of node interleaving where strictly speaking
 you have no NUMA but spread memory accesses across all nodes
 (depending on some bits of the memory address).  The NUMA node
 topology is provided via ACPI tables (e.g. SRAT, SLIT). The contents
 of such tables might vary with different BIOS settings - the CPU
 topology is constant.

Patches are against tip/master.
Please apply.


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


