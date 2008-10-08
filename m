Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYJHTnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYJHTnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbYJHTkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1894 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbYJHTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fx81zQ9FZlr9aLmOHfYbI6v8sg9AffBRtkYCCob0yCLRNe/SeqUN+W6gkw8VZtdEBb
         gn1DrMVhrYACwna7EJNkmNfl12le6nMovGh3/BDs0lG2L0IM/Jk2T5MBaaUpXl+qlnw+
         rjZ1AxHwmNLCDRl1dEO7Pt5iusHAjP/+kQusk=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 07/10] ixj: Refactor DTMF tone setting
Date: Wed,  8 Oct 2008 14:41:42 -0600
Message-Id: <d9e83f28187798f57dc2174a19eda735af09a90f.1223497217.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <4f6d77649769072c98fa1e6bcafd963b6b050190.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
 <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
 <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
 <4f6d77649769072c98fa1e6bcafd963b6b050190.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the DAA_Ceoff_* functions use the same set of DTMF tones so they are
refactored into a common function.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |  130 +++++++++-------------------------------------
 1 files changed, 26 insertions(+), 104 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index a1bbe81..3b1315f 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7769,6 +7769,26 @@ static void zero_caller_id(IXJ *j)
 	}
 }
 
+static void set_dtmf_tones(IXJ *j)
+{
+	/* DTMF Tone 1       (0B): 11,B3,5A,2C ;  697 Hz   */
+	/*                         12,33,5A,C3 ;  770 Hz   */
+	/*                         13,3C,5B,32 ;  852 Hz   */
+	/*                         1D,1B,5C,CC ;  941 Hz   */
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
+	/* DTMF Tone 2      (0C): 32,32,52,B3 ;  1209 Hz   */
+	/*                        EC,1D,52,22 ;  1336 Hz   */
+	/*                        AA,AC,51,D2 ;  1477 Hz   */
+	/*                        9B,3B,51,25 ;  1633 Hz   */
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
+	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+}
+
 static void DAA_Coeff_US(IXJ *j)
 {
 	j->daa_country = DAA_US;
@@ -7888,24 +7908,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.XOP_xr6_W.reg = 0x00;
 /* Ext. Reg. 7 (Vdd)              (xr7):40 */
 	j->m_DAAShadowRegs.XOP_REGS.XOP.xr7.reg = 0x40;		/* 0x40 ??? Should it be 0x00? */
-	/*  */
-	/* DTMF Tone 1                     (0B): 11,B3,5A,2C ;   697 Hz   */
-	/*                                       12,33,5A,C3 ;  770 Hz   */
-	/*                                       13,3C,5B,32 ;  852 Hz   */
-	/*                                       1D,1B,5C,CC ;  941 Hz   */
-
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
-/* DTMF Tone 2                     (0C): 32,32,52,B3 ;  1209 Hz   */
-	/*                                       EC,1D,52,22 ;  1336 Hz   */
-	/*                                       AA,AC,51,D2 ;  1477 Hz   */
-	/*                                       9B,3B,51,25 ;  1633 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+	set_dtmf_tones(j);
 }
 
 static void DAA_Coeff_UK(IXJ *j)
@@ -8024,23 +8027,7 @@ static void DAA_Coeff_UK(IXJ *j)
 	j->m_DAAShadowRegs.XOP_xr6_W.reg = 0x00;
 /* Ext. Reg. 7 (Vdd)               (xr7):46 */
 	j->m_DAAShadowRegs.XOP_REGS.XOP.xr7.reg = 0x46;		/* 0x46 ??? Should it be 0x00? */
-	/* DTMF Tone 1                     (0B): 11,B3,5A,2C    ;   697 Hz   */
-	/*                                       12,33,5A,C3    ;  770 Hz   */
-	/*                                       13,3C,5B,32    ;  852 Hz   */
-	/*                                       1D,1B,5C,CC    ;  941 Hz   */
-
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
-/* DTMF Tone 2                     (0C): 32,32,52,B3    ;  1209 Hz   */
-	/*                                       EC,1D,52,22    ;  1336 Hz   */
-	/*                                       AA,AC,51,D2    ;  1477 Hz   */
-	/*                                       9B,3B,51,25    ;  1633 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+	set_dtmf_tones(j);
 }
 
 
@@ -8161,23 +8148,7 @@ static void DAA_Coeff_France(IXJ *j)
 	j->m_DAAShadowRegs.XOP_xr6_W.reg = 0x00;
 /* Ext. Reg. 7 (Vdd)               (xr7):46 */
 	j->m_DAAShadowRegs.XOP_REGS.XOP.xr7.reg = 0x46;		/* 0x46 ??? Should it be 0x00? */
-	/* DTMF Tone 1                     (0B): 11,B3,5A,2C    ;   697 Hz   */
-	/*                                       12,33,5A,C3    ;  770 Hz   */
-	/*                                       13,3C,5B,32    ;  852 Hz   */
-	/*                                       1D,1B,5C,CC    ;  941 Hz   */
-
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
-/* DTMF Tone 2                     (0C): 32,32,52,B3    ;  1209 Hz   */
-	/*                                       EC,1D,52,22    ;  1336 Hz   */
-	/*                                       AA,AC,51,D2    ;  1477 Hz   */
-	/*                                       9B,3B,51,25    ;  1633 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+	set_dtmf_tones(j);
 }
 
 
@@ -8318,23 +8289,7 @@ static void DAA_Coeff_Germany(IXJ *j)
 	j->m_DAAShadowRegs.XOP_xr6_W.reg = 0x00;
 /* Ext. Reg. 7 (Vdd)               (xr7):40 ; VDD=4.25 V */
 	j->m_DAAShadowRegs.XOP_REGS.XOP.xr7.reg = 0x40;		/* 0x40 ??? Should it be 0x00? */
-	/* DTMF Tone 1                     (0B): 11,B3,5A,2C    ;   697 Hz   */
-	/*                                       12,33,5A,C3    ;  770 Hz   */
-	/*                                       13,3C,5B,32    ;  852 Hz   */
-	/*                                       1D,1B,5C,CC    ;  941 Hz   */
-
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
-/* DTMF Tone 2                     (0C): 32,32,52,B3    ;  1209 Hz   */
-	/*                                       EC,1D,52,22    ;  1336 Hz   */
-	/*                                       AA,AC,51,D2    ;  1477 Hz   */
-	/*                                       9B,3B,51,25    ;  1633 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+	set_dtmf_tones(j);
 }
 
 
@@ -8454,24 +8409,7 @@ static void DAA_Coeff_Australia(IXJ *j)
 	j->m_DAAShadowRegs.XOP_xr6_W.reg = 0x00;
 /* Ext. Reg. 7 (Vdd)               (xr7):40 */
 	j->m_DAAShadowRegs.XOP_REGS.XOP.xr7.reg = 0x40;		/* 0x40 ??? Should it be 0x00? */
-
-	/* DTMF Tone 1                     (0B): 11,B3,5A,2C    ;  697 Hz   */
-	/*                                       12,33,5A,C3    ;  770 Hz   */
-	/*                                       13,3C,5B,32    ;  852 Hz   */
-	/*                                       1D,1B,5C,CC    ;  941 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
-
-	/* DTMF Tone 2                     (0C): 32,32,52,B3    ;  1209 Hz   */
-	/*                                       EC,1D,52,22    ;  1336 Hz   */
-	/*                                       AA,AC,51,D2    ;  1477 Hz   */
-	/*                                       9B,3B,51,25    ;  1633 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+	set_dtmf_tones(j);
 }
 
 static void DAA_Coeff_Japan(IXJ *j)
@@ -8590,23 +8528,7 @@ static void DAA_Coeff_Japan(IXJ *j)
 	j->m_DAAShadowRegs.XOP_xr6_W.reg = 0x00;
 /* Ext. Reg. 7 (Vdd)               (xr7):40 */
 	j->m_DAAShadowRegs.XOP_REGS.XOP.xr7.reg = 0x40;		/* 0x40 ??? Should it be 0x00? */
-	/* DTMF Tone 1                     (0B): 11,B3,5A,2C    ;   697 Hz   */
-	/*                                       12,33,5A,C3    ;  770 Hz   */
-	/*                                       13,3C,5B,32    ;  852 Hz   */
-	/*                                       1D,1B,5C,CC    ;  941 Hz   */
-
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[3] = 0x11;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[2] = 0xB3;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[1] = 0x5A;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone1Coeff[0] = 0x2C;
-/* DTMF Tone 2                     (0C): 32,32,52,B3    ;  1209 Hz   */
-	/*                                       EC,1D,52,22    ;  1336 Hz   */
-	/*                                       AA,AC,51,D2    ;  1477 Hz   */
-	/*                                       9B,3B,51,25    ;  1633 Hz   */
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[2] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[1] = 0x52;
-	j->m_DAAShadowRegs.COP_REGS.COP.Tone2Coeff[0] = 0xB3;
+	set_dtmf_tones(j);
 }
 
 static s16 tone_table[][19] =
-- 
1.5.6.4

