Return-Path: <linux-kernel-owner+w=401wt.eu-S1031345AbXDZRKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031345AbXDZRKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXDZRJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:09:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbXDZQ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:33 -0400
Date: Thu, 26 Apr 2007 09:55:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/33] Fix compat sys_ipc() on sparc64
Message-ID: <20070426165550.GM1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-compat-sys_ipc-on-sparc64.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

The 32-bit syscall trampoline for sys_ipc() on sparc64
was sign extending various arguments, which is bogus when
using compat_sys_ipc() since that function expects zero
extended copies of all the arguments.

This bug breaks the sparc64 kernel when built with gcc-4.2.x
among other things.

[SPARC64]: Fix arg passing to compat_sys_ipc().

Do not sign extend args using the sys32_ipc stub, that is
buggy and unnecessary.

Based upon an excellent report by Mikael Pettersson.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/sys32.S   |    1 -
 arch/sparc64/kernel/systbls.S |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/sparc64/kernel/sys32.S
+++ b/arch/sparc64/kernel/sys32.S
@@ -91,7 +91,6 @@ SIGN1(sys32_select, compat_sys_select, %
 SIGN1(sys32_mkdir, sys_mkdir, %o1)
 SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
 SIGN1(sys32_sysfs, compat_sys_sysfs, %o0)
-SIGN3(sys32_ipc, compat_sys_ipc, %o1, %o2, %o3)
 SIGN2(sys32_sendfile, compat_sys_sendfile, %o0, %o1)
 SIGN2(sys32_sendfile64, compat_sys_sendfile64, %o0, %o1)
 SIGN1(sys32_prctl, sys_prctl, %o0)
--- a/arch/sparc64/kernel/systbls.S
+++ b/arch/sparc64/kernel/systbls.S
@@ -62,7 +62,7 @@ sys_call_table32:
 /*200*/	.word sys32_ssetmask, sys_sigsuspend, compat_sys_newlstat, sys_uselib, compat_sys_old_readdir
 	.word sys32_readahead, sys32_socketcall, sys32_syslog, sys32_lookup_dcookie, sys32_fadvise64
 /*210*/	.word sys32_fadvise64_64, sys32_tgkill, sys32_waitpid, sys_swapoff, sys32_sysinfo
-	.word sys32_ipc, sys32_sigreturn, sys_clone, sys32_ioprio_get, compat_sys_adjtimex
+	.word compat_sys_ipc, sys32_sigreturn, sys_clone, sys32_ioprio_get, compat_sys_adjtimex
 /*220*/	.word sys32_sigprocmask, sys_ni_syscall, sys32_delete_module, sys_ni_syscall, sys32_getpgid
 	.word sys32_bdflush, sys32_sysfs, sys_nis_syscall, sys32_setfsuid16, sys32_setfsgid16
 /*230*/	.word sys32_select, compat_sys_time, sys32_splice, compat_sys_stime, compat_sys_statfs64

-- 
