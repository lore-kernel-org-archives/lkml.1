Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYFEQIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYFEQIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYFEQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:08:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYFEQIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:08:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: ip_fast_csum() requires a memory clobber on its inline
	asm
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Date: Thu, 05 Jun 2008 17:07:35 +0100
Message-ID: <20080605160735.2801.34832.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ip_fast_csum() requires a memory clobber on its inline asm as it accesses
memory in a fashion that gcc can't predict.

The GCC manual says:

 If your assembler instructions access memory in an unpredictable
 fashion, add `memory' to the list of clobbered registers.  This will
 cause GCC to not keep memory values cached in registers across the
 assembler instruction and not optimize stores or loads to that memory.

The bug hasn't been noticed in FRV, but it has been seen in PA-RISC.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/checksum.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-frv/checksum.h b/include/asm-frv/checksum.h
index 9b16898..269da09 100644
--- a/include/asm-frv/checksum.h
+++ b/include/asm-frv/checksum.h
@@ -75,7 +75,7 @@ __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 	    : "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (inc), "=&r"(tmp)
 	    : "0" (sum), "1" (iph), "2" (ihl), "3" (4),
 	    "m"(*(volatile struct { int _[100]; } *)iph)
-	    : "icc0", "icc1"
+	    : "icc0", "icc1", "memory"
 	    );
 
 	return (__force __sum16)~sum;

