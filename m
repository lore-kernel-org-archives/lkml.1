Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYJWFLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYJWFLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYJWFLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:11:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57135
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYJWFLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:11:16 -0400
Date: Wed, 22 Oct 2008 22:10:54 -0700 (PDT)
Message-Id: <20081022.221054.254871632.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: minor bug in invalid exception patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081021.232421.212159699.davem@davemloft.net>
References: <20081021.232421.212159699.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 21 Oct 2008 23:24:21 -0700 (PDT)

> Specifically:
> 
> @@ -490,11 +490,15 @@ do {							\
>      break;						\
>  							\
>    case _FP_CLS_COMBINE(FP_CLS_INF,FP_CLS_INF):		\
> +    R##_s = _FP_NANSIGN_##fs;				\
> +    R##_c = FP_CLS_NAN;					\
> +    _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
> +    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_IDI);\
>    case _FP_CLS_COMBINE(FP_CLS_ZERO,FP_CLS_ZERO):	\
>      R##_s = _FP_NANSIGN_##fs;				\
>      R##_c = FP_CLS_NAN;					\
>      _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
> -    FP_SET_EXCEPTION(FP_EX_INVALID);			\
> +    FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_ZDZ);\
>      break;						\
>  							\
>    default:						\
> 
> That first case statement code block falls through to
> the next one, which is probably not as you intended.
> 
> Seems there is a missing break there.

I'm going to commit the following to fix this:

--------------------

math-emu: Fix thinko in _FP_DIV

In commit 48d6c64311ddb6417b901639530ccbc47bdc7635 ("math-emu: Add
support for reporting exact invalid exception") code was added to
set the new FP_EX_INVALID_{IDI,ZDZ} exception flag bits.

However there is a missing break statement for the
_FP_CLS_COMBINE(FP_CLS_INF,FP_CLS_INF) switch case, the
code just falls into _FP_CLS_COMBINE(FP_CLS_ZERO,FP_CLS_ZERO)
which then proceeds to overwrite all of the settings.

Fix by adding the missing break.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/math-emu/op-common.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index bc50aa0..f456534 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -503,6 +503,8 @@ do {							\
     R##_c = FP_CLS_NAN;					\
     _FP_FRAC_SET_##wc(R, _FP_NANFRAC_##fs);		\
     FP_SET_EXCEPTION(FP_EX_INVALID | FP_EX_INVALID_IDI);\
+    break;						\
+							\
   case _FP_CLS_COMBINE(FP_CLS_ZERO,FP_CLS_ZERO):	\
     R##_s = _FP_NANSIGN_##fs;				\
     R##_c = FP_CLS_NAN;					\
-- 
1.5.6.5

