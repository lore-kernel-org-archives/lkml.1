Return-Path: <linux-kernel-owner+w=401wt.eu-S1762611AbXEYM5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611AbXEYM5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbXEYM46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:56:58 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:52574 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbXEYM45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:56:57 -0400
Message-ID: <4656DBFB.2050501@hitachi.com>
Date: Fri, 25 May 2007 21:52:11 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 0/7] coredump: core dump masking support v5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is version 5 of the core dump masking feature,
which controls which VMAs should be dumped based on their
memory types and per-process flags.

I adopted most of Andrew's suggestion at the previous version.
He also suggested using system call instead of /proc/<pid>/
interface, I decided to use the latter continuously because
adding new system call with pid argument will give a big impact
on the kernel. 


You can access the per-process flags via /proc/<pid>/coredump_filter
interface.  coredump_filter represents a bitmask of memory types,
and if a bit is set, VMAs of corresponding memory type are written
into a core file when the process is dumped.  The bitmask is
inherited from the parent process when a process is created.

The original purpose is to avoid longtime system slowdown when a
number of processes which share a huge shared memory are dumped at
the same time.  To achieve this purpose, this patch series adds an
ability to suppress dumping anonymous shared memory for specified
processes.  In this version, three other memory types are also
supported.

Here are the coredump_filter bits:
  bit 0: anonymous private memory
  bit 1: anonymous shared memory
  bit 2: file-backed private memory
  bit 3: file-backed shared memory

The default value of coredump_filter is 0x3.  This means the
new core dump routine has the same behavior as conventional
behavior by default.

In this version, coredump_filter bits and mm.dumpable are merged
into mm.flags, and it is accessed by atomic bitops.

This patch series can be applied against 2.6.22-rc2-mm1.
The supported core file formats are ELF and ELF-FDPIC. ELF has been
tested, but ELF-FDPIC has not been built and tested because I don't
have the test environment.

Any coments are welcome.

Best regards.

ChangeLog
=========
v5:
  - map three-value dumpable to two flags and store into mm.flags
  - enable to control anonymous private, file-backed private and
    file-backed shared memory
  - provide /proc/<pid>/coredump_filter interface instead of
    /proc/<pid>/coredump_omit_anonymous_shared
  - use bitops to atomically access the core dump setting instead
    of using a spinlock
  - pass the core dump setting to maydump() through its argument
    again

v4:
http://lkml.org/lkml/2007/3/1/501
  - in maydump(), retrieve the core dump setting from mm_struct
    directly, instead of its additional argument
  - writing to /proc/<pid>/coredump_omit_anonymous_shared returns
    EBUSY while core dumping.

v3:
http://lkml.org/lkml/2007/2/16/149
  - remove `/proc/<pid>/core_flags' proc entry
  - add `/proc/<pid>/coredump_anonymous_shared' as a named flag
  - remove kernel.core_flags_enable sysctl parameter

v2:
http://lkml.org/lkml/2007/1/26/108
http://lkml.org/lkml/2007/1/26/189
  - rename `coremask' to `core_flags'
  - change `core_flags' member in mm_struct to a bit field
    next to `dumpable'
  - introduce a global spin lock to protect adjacent two bit fields
    (core_flags and dumpable) from race condition
  - fix a bug that the generated core file can be corrupted when
    core dumping and updating core_flags occur concurrently
  - add kernel.core_flags_enable sysctl parameter to enable/disable
    flags in /proc/<pid>/core_flags
  - support ELF-FDPIC binary format, but not tested

v1:
http://lkml.org/lkml/2006/12/13/17

-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory


