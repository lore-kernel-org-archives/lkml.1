Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbXBPNev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbXBPNev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964841AbXBPNev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:34:51 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52719 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbXBPNeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:34:50 -0500
Message-ID: <45D5B2E3.3030607@hitachi.com>
Date: Fri, 16 Feb 2007 22:34:27 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: [PATCH 0/4] coredump: core dump masking support v3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is version 3 of the core dump masking feature,
which provides a per-process flag not to dump anonymous shared
memory segments.

In this version, /proc/<pid>/coredump_omit_anonymous_shared file
is provided as an interface instead of the previous
/proc/<pid>/core_flags. If you have written a non-zero value to the
file, anonymous shared memory segments of the process not to be
dumped.

Another change of this version is removal of kernel.core_flags_enables
sysctl which enables/disables core dump flags globally.  The purpose
of this sysctl is for the system administrator to force all anonymous
memory to be dumped.  But ulimit -c 0 breaks it.  So this sysctl is
not helpful for the current linux.

This patch series can be applied against 2.6.20-mm1.
The supported core file formats are ELF and ELF-FDPIC. ELF has been
tested, but ELF-FDPIC has not been build and tested because I don't
have the test environment.


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
Get all shared memory segments of pid 1234 not to dump:

  $ echo 1 > /proc/1234/coredump_omit_anonymous_shared

When a new process is created, the process inherits the flag status
from its parent. It is useful to set the core dump flags before the
program runs. For example:

  $ echo 1 > /proc/self/coredump_omit_anonymous_shared
  $ ./some_program


ChangeLog:
v3:
  - remove `/proc/<pid>/core_flags' proc entry
  - add `/proc/<pid>/coredump_anonymous_shared' as a named flag
  - remove kernel.core_flags_enable sysctl parameter

v2:
http://groups.google.com/group/linux.kernel/browse_frm/thread/cb254465971d4a42/
http://groups.google.com/group/linux.kernel/browse_frm/thread/da78f2702e06fa11/
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
http://groups.google.com/group/linux.kernel/browse_frm/thread/1381fc54d716e3e6/

-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory
E-mail: hidehiro.kawai.ez@hitachi.com


