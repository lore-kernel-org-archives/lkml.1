Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZIWCpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZIWCpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZIWCpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:45:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZIWCpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:45:43 -0400
Message-ID: <4AB98BD2.2030002@redhat.com>
Date: Tue, 22 Sep 2009 19:45:38 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: SystemTap <systemtap@sourceware.org>
CC: LKML <linux-kernel@vger.kernel.org>, LWN <lwn@lwn.net>
Subject: SystemTap release 1.0
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SystemTap team announces release 1.0.

  experimental support for unprivileged users, cross-compiling for
  foreign architectures, matching C++ class and namespace scopes,
  reduced runtime memory consumption, reduced dormant overhead in
  userspace markers, bug fixes, and more...

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-1.0.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-1.0 (commit 6a7aa1a1)

= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree
  Further information at http://sourceware.org/systemtap/wiki/

= SystemTap frontend (stap) changes

- There is now EXPERIMENTAL support for unprivileged users.  Such users
  are restricted to only probes and tapset functions that have been
  explicitly deemed safe.  See the NEWS file for more information on the
  restrictions and how to enable this feature.

- It is now possible to cross-compile systemtap scripts for foreign
  architectures, using the new '-a ARCH' and '-B OPT=VALUE' flags.  For
  example, put arm-linux-gcc etc. into your $PATH, and point systemtap
  at the target kernel build tree with:
     stap -a arm -B CROSS_COMPILE=arm-linux- -r /build/tree  [...]
  The -B option is passed to kbuild make.  -r identifies the already
  configured/built kernel tree and -a its architecture (kbuild's
  ARCH=...).  Systemtap will infer -p4.

- stap-start-server now accepts the -r, -R, -I, -B and -a options in
  order to start a cross compiling server. The server will correctly
  advertise itself with respect to the kernel release and architecture
  that it compiles for.

- When specified on stap-client, the -r and -a options will be
  considered when searching for a suitable server.

- Support output file switching by SIGUSR2. Users can command running
  stapio to switch output file by sending SIGUSR2.

- Memory consumption for scripts involving many uprobes has been
  dramatically reduced.

- The systemtap notion of "architecture" now matches the kernel's,
  rather than that of "uname -m".  This means that 32-bit i386 family
  are all known as "i386" rather than "i386" or "i686"; "ppc64" as
  "powerpc"; "s390x" as "s390", and so on.  This is consistent between
  the new "-a ARCH" flag and the script-level %( arch ... %)
  conditional.

- A new experimental transport mechanism, using ftrace's ring_buffer,
  has been added.  This may become the default transport mechanism in
  future versions of systemtap.  To test this new transport mechanism,
  define 'STP_USE_RING_BUFFER'.

- Support for recognizing DW_OP_{stack,implicit}_value DWARF expressions
  as emitted by GCC 4.5.

= SystemTap script language changes

- The function spec for dwarf probes now supports C++ scopes, so you can
  limit the probes to specific namespaces or classes.  Multiple scopes
  can be specified, and they will be matched progressively outward.
      probe process("foo").function("std::vector<*>::*") { }
      probe process("foo").function("::global_function") { }

- The preprocessor now supports || and && in the conditions.
  e.g. %( arch == "x86_64" || arch == "ia64" %: ... %)

- It is now possible to define multiple probe aliases with the same
  name.  A probe will expand to all matching aliases.
    probe foo = bar { }
    probe foo = baz { }
    probe foo { } # expands twice, once to bar and once to baz

= SystemTap tapset changes

- process().mark() probes now use an enabling semaphore to reduce the
  computation overhead of dormant probes.

- Many functions have been marked for use by unprivileged users.  The
  general rule is that the functions must only return information that
  is either globally available or specific to one's own processes.

- The netdev tapset has many new probe points for monitoring network
  traffic and device configurations.

- The function task_backtrace returns the current hex backtrace of any
  arbitrary task in the system.

- The function is_myproc returns whether the current process is owned by
  the same user that launched the systemtap script.

= New script examples

- general/badname.stp     Bad filename filter
- memory/mmanonpage.stp   Track VM system actions on anonymous pages
- memory/mmfilepage.stp   Track VM system actions on file-backed pages
- memory/mmreclaim.stp    Track VM system page reclamation
- memory/mmwriteback.stp  Track VM system writing to disk
- network/netdev.stp      Trace activity on network devices

= Contributors for this release

  Breno Leitao, Dave Brolley, David Smith, Eugeniy Meshcheryakov,
  Frank Ch. Eigler, Jim Keniston, Josh Stone, Maran Pakkirisamy,
  Mark Wielaard, Masami Hiramatsu, Przemysław Pawełczyk, Robb Romans,
  Roland McGrath, Stan Cox, Tim Moore, Wenji Huang, William Cohen

= Examples of tested kernel versions

  2.6.9 (el4/i686)
  2.6.18 (el5/ia64/i686/x86_64)
  2.6.27.30 (f10/i686/x86_64)
  2.6.30.5 (f11/i686/x86_64)
  2.6.31 (f12/i686/x86_64)

= Known issues with this release

- When using the systemtap client and server udp port 5353 must be open
  in your firewall in order for the clent to find servers using
  avahi-browse.

- Some kernel crashes continue to be reported when a script probes broad
  kernel function wildcards.

= Bugs fixed for this release

   2475 Inlines don't match filenames correctly
   4186 cross-architecture compilation
   4541 systemtap.stress/current.stp fails to build on ia64
   5679 inline documentation for scripts/tapsets
   6866 Extend stp_symbol_snprintf for user space
   6905 process("a").statement("main@/root/a.c:*") fails
  10084 dropwatch fails on kernels without kfree_skb tracepoint
  10155 Switching output files by signal
  10204 Place userspace markers in systemtap itself
  10294 .statement("*@FILE:NNN-MMM") line-range probes broken
  10301 adding '?' to the end of a probe results in a script failure
  10408 IA-32 - stap unable to decode parameter location using DWARF
  10417 Support DW_OP_{implicit,stack}_value
  10424 All tracepoints are unusable if any one header is bad
  10467 Failure in source:line matching aborts further searching
  10486 raise default MAXSTRINGLEN on 64-bit hosts
  10491 Compilation error on running para-callgraph.stp ia64/s390
  10495 Allow multiple, same name, probe point alias alternatives
  10499 Missing @file:line info from resolved probes
  10506 uprobes.ko load broken by module-signing checks
  10507 overhuge BSS for many-uprobe module
  10509 Compilation error on systems not having NSS support
  10512 STAP_PROBES don't work in c++ constructors/destructors
  10521 Add support for DECLARE_TRACE_WITH_CALLBACK
  10524 oversize DATA for uprobe-intensive scripts
  10533 inlined vars are not always found
  10537 process().function().label() doesn't select multiple inlines
  10538 Handle anonymous structs and unions nicer
  10539 ioblktime.stp fails in s390x
  10543 cache cleaning with cache_mb_limit=0 cleans up new module
  10544 buildrun.cxx "Error %d ..." messages uninformative
  10551 pax/grsecurity linux/module.h build compatibility
  10552 document '-M' (bulk merge) flag
  10568 translator issue with tapsets
  10572 stap misses functions with the same name in one CU
  10573 Identical inline instances may be probed from multiple CUs
  10574 Some functions resolve to pc=0x0
  10589 runtime _stp_{dbug,warn,err} should not use _stp_vscnprinf
  10594 Cache dwarf iterations to improve translator speed
  10602 REG_IP() used as lvalue fails on s390x, probably ia64
  10604 new memory examples fail when mm_* tracepoints unavailable.
  10605 Unknown symbol in module error (Unknown symbol si_swapinfo)
  10608 don't attempt 32-bit syscall tests without 32-bit devel env.
  10613 32-bit statfs [ustat] test fails on 2.6.30 kernels
  10617 make "make uninstall" work
  10618 Unable to find member 'nr_sectors' for struct request
  10642 improve performance of .return saved-$variable translation

= Test results on various systems

- After running "sudo make installcheck" from the test suite, on a
  suitably equipped machine (kernel debugging data and other stuff
  installed), you should see 1000-1100 passes and a small handful of
  failures.

