Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYBSSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYBSSnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYBSSnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:43:07 -0500
Received: from qb-out-0506.google.com ([72.14.204.235]:40536 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYBSSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OgUYvwdk3lrYZOhWzI2gUm64gHOPUxpPEswV7pNOr1liE6oUmG57zzxxoC3Db8uktV421NzW+mSegT6dNjwufWZo49Ce6V8zKKA5aw5Vor58LiA9nvaEUdqDCZWpRWDXm//RtMeXhL7z1elhHPd36cNiV707YXMCWqQpfs883s4=
Subject: [PATCH] kvm: fix sparse warnings in x86_emulate.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 10:43:11 -0800
Message-Id: <1203446591.10464.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nesting __emulate_2op_nobyte inside__emulate_2op produces many shadowed
variable warnings on the internal variable _tmp used by both macros.

Change the outer macro to use __tmp.

Avoids a sparse warning like the following at every call site of __emulate_2op
arch/x86/kvm/x86_emulate.c:1091:3: warning: symbol '_tmp' shadows an earlier one
arch/x86/kvm/x86_emulate.c:1091:3: originally declared here
[18 more warnings suppressed]

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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
1.5.4.2.200.g99e75



