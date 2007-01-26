Return-Path: <linux-kernel-owner+w=401wt.eu-S965671AbXAZOFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671AbXAZOFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965677AbXAZOFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:05:14 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49873 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965671AbXAZOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:05:13 -0500
Message-ID: <45BA0A93.30004@hitachi.com>
Date: Fri, 26 Jan 2007 23:05:07 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@osdl.org, pavel@suse.cz, linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 0/4] coredump: core dump masking support v2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is version 2 of the core dump masking feature,
which enables you to specify the memory segment types you don't
want to dump into a core file. 

In this version, the setting for which memory segment types are
dumped is stored as a bit field and placed next to `dumpable'
bit field in mm_struct.  Writing to these two bit fields can cause
race condition, so I use a global spin lock to protect them from
write-write race.
In consideration of security, I adds a sysctl parameter to
enable/disable this feature.

This patch series can be applied against 2.6.20-rc4-mm1.
The supported core file formats are ELF and ELF-FDPIC. ELF has been
tested, but ELF-FDPIC has not been build and tested because I don't
have the test environment.


Description:
You can specify memory segment types you don't want to dump via
/proc/<pid>/core_flags file, which is provided per process.
This file represents a set of flags, but currently, only bit 0 is
available. If bit 0 is set, the kernel core dump routine doesn't
dump anonymous shared memory segments, which includes IPC shared
memory and some of mmap(2)'ed memory.

System administrator can enable/disable these flags one by one via
/proc/sys/kernel/core_flags_enable file. The default value is 1.
This means that bit 0 in core_flags is effective.


Background:
Some software programs share huge memory among hundreds of
processes. If a failure occurs on one of these processes, they can
be signaled by a monitoring process to generate core files and
restart the service. However, it can develop into a system-wide
failure such as system slow down for a long time and disk space
shortage because the total size of the core files is very huge!

To avoid the above situation we can limit the core file size by
setrlimit(2) or ulimit(1). But this method can lose important data
such as stack because core dumping is terminated halfway.
So I suggest keeping shared memory segments from being dumped for
particular processes. Because the shared memory attached to processes
is common in them, we don't need to dump the shared memory every time.


Usage:
If you don't want to dump all shared memory segments attached to
pid 1234, set the bit 0 of the process's core_flags to 1:

  $ echo 1 > /proc/1234/core_flags

Additionally, you can check its hexadecimal value by reading the file:

  $ cat /proc/1234/core_flags
  00000001

When a new process is created, the process inherits the core_flags
setting from its parent. It is useful to set the core_flags before
the program runs. For example:

  $ echo 1 > /proc/self/core_flags
  $ ./some_program


ChangeLog:
v2:
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


