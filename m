Return-Path: <linux-kernel-owner+w=401wt.eu-S1422762AbXCGR6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422762AbXCGR6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422755AbXCGRNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:13:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:42721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422762AbXCGRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:31 -0500
Message-Id: <20070307171122.943356363@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Dike <jdike@addtoit.com>,
       Andi Kleen <ak@suse.de>, user-mode-linux-devel@lists.sourceforge.net,
       Paolo Blaisorblade Giarrusso <blaisorblade@yahoo.it>
Subject: [patch 002/101] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Content-Disposition: inline; filename=x86_64-fix-2.6.18-regression-ptrace_oldsetoptions-should-be-accepted.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Also PTRACE_OLDSETOPTIONS should be accepted, as done by kernel/ptrace.c and
forced by binary compatibility. UML/32bit breaks because of this - since it is wise
enough to use PTRACE_OLDSETOPTIONS to be binary compatible with 2.4 host
kernels.

Until 2.6.17 (commit f0f2d6536e3515b5b1b7ae97dc8f176860c8c2ce) we had:

       default:
                return sys_ptrace(request, pid, addr, data);

Instead here we have:
        case PTRACE_GET_THREAD_AREA:
	case ...:
                return sys_ptrace(request, pid, addr, data);

        default:
                return -EINVAL;

This change was a style change - when a case is added, it must be explicitly
tested this way. In this case, not enough testing was done.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/ia32/ptrace32.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20.1.orig/arch/x86_64/ia32/ptrace32.c
+++ linux-2.6.20.1/arch/x86_64/ia32/ptrace32.c
@@ -243,6 +243,7 @@ asmlinkage long sys32_ptrace(long reques
 	case PTRACE_SINGLESTEP:
 	case PTRACE_DETACH:
 	case PTRACE_SYSCALL:
+	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:

--
