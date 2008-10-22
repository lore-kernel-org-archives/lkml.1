Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYJVGYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYJVGYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYJVGYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:24:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38885
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYJVGYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:24:43 -0400
Date: Tue, 21 Oct 2008 23:24:21 -0700 (PDT)
Message-Id: <20081021.232421.212159699.davem@davemloft.net>
To: galak@kernel.crashing.org
CC: linux-kernel@vger.kernel.org
Subject: minor bug in invalid exception patch
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While looking over some recent changes to op-common.h I found
a minor error in:

commit 48d6c64311ddb6417b901639530ccbc47bdc7635
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Fri Jun 27 09:39:00 2008 -0500

    math-emu: Add support for reporting exact invalid exception

that I didn't catch in my initial review :)  Sorry.

Specifically:

@@ -490,11 +490,15 @@ do {							\
     break;						\
 							\
   case _FP_CLS_COMBINE(FP_CLS_INF,FP_CLS_INF):		\
+    R##_s = _FP_NANSIGN_##fs;				\
+    R##_c = FP_CLS_NAN;					\
+    _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
+    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_IDI);\
   case _FP_CLS_COMBINE(FP_CLS_ZERO,FP_CLS_ZERO):	\
     R##_s = _FP_NANSIGN_##fs;				\
     R##_c = FP_CLS_NAN;					\
     _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
-    FP_SET_EXCEPTION(FP_EX_INVALID);			\
+    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_ZDZ);\
     break;						\
 							\
   default:						\

That first case statement code block falls through to
the next one, which is probably not as you intended.

Seems there is a missing break there.
