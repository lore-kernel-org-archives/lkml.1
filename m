Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXDWF6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXDWF6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161199AbXDWF6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:58:54 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:44248 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160997AbXDWF6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:58:53 -0400
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Transparently handle <.symbol> lookup for kprobes
Date: Mon, 23 Apr 2007 11:28:49 +0530
User-Agent: KMail/1.9.5
Cc: ananth@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZsELGHtcN0CF6tD"
Message-Id: <200704231128.49041.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ZsELGHtcN0CF6tD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When data symbols are not present in kernel image, user needs to add
dot(".") before function name explicitly, that he wants to probe in kprobe 
module on ppc64.

for ex:-
When data symbols are missing on ppc64,
====================
[root@llm27lp1 ~]# cat /proc/kallsyms | grep do_fork
c00000000006283c T .do_fork
==============================
User needs add "." to "do_fork"

kp.symbol_name = ".do_fork";
============================

This makes kprobe modules unportable. Below patch fixes the problem.


Signed-off-by: Srinivasa Ds <srinivasa@in.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>



--Boundary-00=_ZsELGHtcN0CF6tD
Content-Type: text/x-diff;
  charset="us-ascii";
  name="final.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="final.patch"

---
 include/asm-powerpc/kprobes.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.21-rc7/include/asm-powerpc/kprobes.h
===================================================================
--- linux-2.6.21-rc7.orig/include/asm-powerpc/kprobes.h
+++ linux-2.6.21-rc7/include/asm-powerpc/kprobes.h
@@ -64,6 +64,12 @@ typedef unsigned int kprobe_opcode_t;
 				addr = *(kprobe_opcode_t **)addr;	\
 		} else if (name[0] != '.')				\
 			addr = *(kprobe_opcode_t **)addr;		\
+	} else {							\
+		char dot_name[KSYM_NAME_LEN+1];				\
+		dot_name[0] = '.';					\
+		dot_name[1] = '\0';					\
+		strncat(dot_name, name, KSYM_NAME_LEN);			\
+		addr = (kprobe_opcode_t *)kallsyms_lookup_name(dot_name); \
 	}								\
 }
 

--Boundary-00=_ZsELGHtcN0CF6tD--
