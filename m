Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbZDAINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbZDAINs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761392AbZDAIN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:13:27 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50577 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544AbZDAIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:13:26 -0400
Message-ID: <49D32212.80607@cosmosbay.com>
Date: Wed, 01 Apr 2009 10:13:06 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>
Subject: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 01 Apr 2009 10:13:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While playing with new percpu_{read|write|add|sub} stuff in network tree,
I found x86 asm was a litle bit optimistic.

We need to tell gcc that percpu_{write|add|sub|or|xor} are modyfing
memory and possibly eflags. We could add another parameter to percpu_to_op()
to separate the plain "mov" case (not changing eflags),
but let keep it simple for the moment.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index aee103b..fd4f8ec 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -82,22 +82,26 @@ do {							\
 	case 1:						\
 		asm(op "b %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)val)			\
+		    : "memory", "cc");			\
 		break;					\
 	case 2:						\
 		asm(op "w %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)val)			\
+		    : "memory", "cc");			\
 		break;					\
 	case 4:						\
 		asm(op "l %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)val)			\
+		    : "memory", "cc");			\
 		break;					\
 	case 8:						\
 		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "re" ((T__)val));			\
+		    : "re" ((T__)val)			\
+		    : "memory", "cc");			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
