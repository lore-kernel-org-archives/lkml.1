Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbYDCTeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbYDCTeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbYDCTc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:58 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53004
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151AbYDCTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 03/35] KVM: x86 emulator: fix sparse warnings in x86_emulate.c
Date: Thu,  3 Apr 2008 22:32:18 +0300
Message-Id: <1207251170-5013-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Nesting __emulate_2op_nobyte inside__emulate_2op produces many shadowed
variable warnings on the internal variable _tmp used by both macros.

Change the outer macro to use __tmp.

Avoids a sparse warning like the following at every call site of __emulate_2op
arch/x86/kvm/x86_emulate.c:1091:3: warning: symbol '_tmp' shadows an earlier one
arch/x86/kvm/x86_emulate.c:1091:3: originally declared here
[18 more warnings suppressed]

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index cacdcf5..f59ed93 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -371,7 +371,7 @@ static u16 group2_table[] = {
 
 #define __emulate_2op(_op,_src,_dst,_eflags,_bx,_by,_wx,_wy,_lx,_ly,_qx,_qy) \
 	do {								     \
-		unsigned long _tmp;					     \
+		unsigned long __tmp;					     \
 		switch ((_dst).bytes) {				             \
 		case 1:							     \
 			__asm__ __volatile__ (				     \
@@ -379,7 +379,7 @@ static u16 group2_table[] = {
 				_op"b %"_bx"3,%1; "			     \
 				_POST_EFLAGS("0", "4", "2")		     \
 				: "=m" (_eflags), "=m" ((_dst).val),	     \
-				  "=&r" (_tmp)				     \
+				  "=&r" (__tmp)				     \
 				: _by ((_src).val), "i" (EFLAGS_MASK));      \
 			break;						     \
 		default:						     \
-- 
1.5.4.5

