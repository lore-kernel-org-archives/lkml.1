Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYFDKT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYFDKT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYFDKTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:19:18 -0400
Received: from gw.goop.org ([64.81.55.164]:44140 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYFDKTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:19:17 -0400
Message-ID: <48466BFB.40004@goop.org>
Date: Wed, 04 Jun 2008 11:18:35 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: collapse the various size-dependent percpu accessors
 together
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080604003018.538497000@polaris-admin.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use gcc's %z modifier to emit the appropriate size suffix for
an instruction, so we don't need to duplicate the asm statement for
each size.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/percpu.h |   56 +++-------------------------------------------
 1 file changed, 4 insertions(+), 52 deletions(-)

===================================================================
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -75,22 +75,10 @@
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b %1,"__percpu_seg"%0"		\
-		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
-		break;					\
 	case 2:						\
-		asm(op "w %1,"__percpu_seg"%0"		\
-		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
-		break;					\
 	case 4:						\
-		asm(op "l %1,"__percpu_seg"%0"		\
-		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
-		break;					\
 	case 8:						\
-		asm(op "q %1,"__percpu_seg"%0"		\
+		asm(op "%z0 %1,"__percpu_seg"%0"	\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
@@ -103,22 +91,10 @@
 	typeof(var) ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b "__percpu_seg"%1,%0"		\
-		    : "=r" (ret__)			\
-		    : "m" (var));			\
-		break;					\
 	case 2:						\
-		asm(op "w "__percpu_seg"%1,%0"		\
-		    : "=r" (ret__)			\
-		    : "m" (var));			\
-		break;					\
 	case 4:						\
-		asm(op "l "__percpu_seg"%1,%0"		\
-		    : "=r" (ret__)			\
-		    : "m" (var));			\
-		break;					\
 	case 8:						\
-		asm(op "q "__percpu_seg"%1,%0"		\
+		asm(op "%z1 "__percpu_seg"%1,%0"	\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
@@ -131,19 +107,10 @@
 ({							\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b "__percpu_seg"%0"		\
-				: : "m"(var));		\
-		break;					\
 	case 2:						\
-		asm(op "w "__percpu_seg"%0"		\
-				: : "m"(var));		\
-		break;					\
 	case 4:						\
-		asm(op "l "__percpu_seg"%0"		\
-				: : "m"(var));		\
-		break;					\
 	case 8:						\
-		asm(op "q "__percpu_seg"%0"		\
+		asm(op "%z0 "__percpu_seg"%0"		\
 				: : "m"(var));		\
 		break;					\
 	default: __bad_percpu_size();			\
@@ -155,25 +122,10 @@
 	typeof(var) prev;						\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("cmpxchgb %b1, "__percpu_seg"%2"			\
-				     : "=a"(prev)			\
-				     : "q"(new), "m"(var), "0"(old)	\
-				     : "memory");			\
-		break;							\
 	case 2:								\
-		asm("cmpxchgw %w1, "__percpu_seg"%2"			\
-				     : "=a"(prev)			\
-				     : "r"(new), "m"(var), "0"(old)	\
-				     : "memory");			\
-		break;							\
 	case 4:								\
-		asm("cmpxchgl %k1, "__percpu_seg"%2"			\
-				     : "=a"(prev)			\
-				     : "r"(new), "m"(var), "0"(old)	\
-				     : "memory");			\
-		break;							\
 	case 8:								\
-		asm("cmpxchgq %1, "__percpu_seg"%2"			\
+		asm("cmpxchg%z1 %1, "__percpu_seg"%2"			\
 				     : "=a"(prev)			\
 				     : "r"(new), "m"(var), "0"(old)	\
 				     : "memory");			\


