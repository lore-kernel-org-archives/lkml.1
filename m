Return-Path: <linux-kernel-owner+w=401wt.eu-S1763305AbYEMUVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305AbYEMUVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761002AbYEMUPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:15:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:38552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbYEMUPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:15:44 -0400
Date: Tue, 13 May 2008 13:12:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/37] sparc: Fix ptrace() detach.
Message-ID: <20080513201227.GY31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-fix-ptrace-detach.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: 986bef854fab44012df678a5b51817d5274d3ca1 ]

Forever we had a PTRACE_SUNOS_DETACH which was unconditionally
recognized, regardless of the personality of the process.

Unfortunately, this value is what ended up in the GLIBC sys/ptrace.h
header file on sparc as PTRACE_DETACH and PT_DETACH.

So continue to recognize this old value.  Luckily, it doesn't conflict
with anything we actually care about.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/ptrace.c   |    2 ++
 arch/sparc64/kernel/ptrace.c |    4 ++++
 include/asm-sparc/ptrace.h   |    1 +
 include/asm-sparc64/ptrace.h |    1 +
 4 files changed, 8 insertions(+)

--- a/arch/sparc64/kernel/ptrace.c
+++ b/arch/sparc64/kernel/ptrace.c
@@ -944,6 +944,8 @@ long compat_arch_ptrace(struct task_stru
 		break;
 
 	default:
+		if (request == PTRACE_SPARC_DETACH)
+			request = PTRACE_DETACH;
 		ret = compat_ptrace_request(child, request, addr, data);
 		break;
 	}
@@ -1036,6 +1038,8 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	default:
+		if (request == PTRACE_SPARC_DETACH)
+			request = PTRACE_DETACH;
 		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
--- a/arch/sparc/kernel/ptrace.c
+++ b/arch/sparc/kernel/ptrace.c
@@ -441,6 +441,8 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	default:
+		if (request == PTRACE_SPARC_DETACH)
+			request = PTRACE_DETACH;
 		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
--- a/include/asm-sparc64/ptrace.h
+++ b/include/asm-sparc64/ptrace.h
@@ -263,6 +263,7 @@ extern void __show_regs(struct pt_regs *
 #define SF_XXARG  0x5c
 
 /* Stuff for the ptrace system call */
+#define PTRACE_SPARC_DETACH       11
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
 #define PTRACE_GETFPREGS          14
--- a/include/asm-sparc/ptrace.h
+++ b/include/asm-sparc/ptrace.h
@@ -149,6 +149,7 @@ extern void show_regs(struct pt_regs *);
 #define SF_XXARG  0x5c
 
 /* Stuff for the ptrace system call */
+#define PTRACE_SPARC_DETACH       11
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
 #define PTRACE_GETFPREGS          14

-- 
