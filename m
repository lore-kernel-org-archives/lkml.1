Return-Path: <linux-kernel-owner+w=401wt.eu-S964871AbXBOCkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871AbXBOCkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbXBOCkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:40:45 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:55582 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871AbXBOCkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:40:45 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: Andi Kleen <ak@suse.de>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Date: Thu, 15 Feb 2007 03:34:23 +0100
Message-Id: <11715068631914-git-send-email-blaisorblade@yahoo.it>
X-Mailer: git-send-email 1.4.4.4.ga596b
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
Index: linux-2.6.git/arch/x86_64/ia32/ptrace32.c
===================================================================
--- linux-2.6.git.orig/arch/x86_64/ia32/ptrace32.c
+++ linux-2.6.git/arch/x86_64/ia32/ptrace32.c
@@ -246,6 +246,7 @@ asmlinkage long sys32_ptrace(long reques
 	case PTRACE_SINGLESTEP:
 	case PTRACE_DETACH:
 	case PTRACE_SYSCALL:
+	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
