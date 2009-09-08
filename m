Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZIHQbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZIHQbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZIHQbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZIHQbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:31:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes] x86: Add MMX support for instruction decoder
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 08 Sep 2009 12:32:46 -0400
Message-ID: <20090908163246.23516.78835.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090904190651.GC6118@nowhere>
References: <20090904190651.GC6118@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MMX/SSE instructions to x86 opcode maps, since some of those
instructions are used in the kernel.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/lib/x86-opcode-map.txt |  307 +++++++++++++++++++++++++--------------
 1 files changed, 200 insertions(+), 107 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 083dd59..59e20d5 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -310,14 +310,14 @@ Referrer: 2-byte escape
 0e:
 0f:
 # 0x0f 0x10-0x1f
-10:
-11:
-12:
-13:
-14:
-15:
-16:
-17:
+10: movups Vps,Wps | movss Vss,Wss (F3) | movupd Vpd,Wpd (66) | movsd Vsd,Wsd (F2)
+11: movups Wps,Vps | movss Wss,Vss (F3) | movupd Wpd,Vpd (66) | movsd Wsd,Vsd (F2)
+12: movlps Vq,Mq | movlpd Vq,Mq (66) | movhlps Vq,Uq | movddup Vq,Wq (F2) | movsldup Vq,Wq (F3)
+13: mpvlps Mq,Vq | movlpd Mq,Vq (66)
+14: unpcklps Vps,Wq | unpcklpd Vpd,Wq (66)
+15: unpckhps Vps,Wq | unpckhpd Vpd,Wq (66)
+16: movhps Vq,Mq | movhpd Vq,Mq (66) | movlsps Vq,Uq | movshdup Vq,Wq (F3)
+17: movhps Mq,Vq | movhpd Mq,Vq (66)
 18: Grp16 (1A)
 19:
 1a:
@@ -337,12 +337,12 @@ Referrer: 2-byte escape
 27:
 28: movaps Vps,Wps | movapd Vpd,Wpd (66)
 29: movaps Wps,Vps | movapd Wpd,Vpd (66)
-2a:
-2b:
-2c:
-2d:
-2e:
-2f:
+2a: cvtpi2ps Vps,Qpi | cvtsi2ss Vss,Ed/q (F3) | cvtpi2pd Vpd,Qpi (66) | cvtsi2sd Vsd,Ed/q (F2)
+2b: movntps Mps,Vps | movntpd Mpd,Vpd (66)
+2c: cvttps2pi Ppi,Wps | cvttss2si  Gd/q,Wss (F3) | cvttpd2pi Ppi,Wpd (66) | cvttsd2si Gd/q,Wsd (F2)
+2d: cvtps2pi Ppi,Wps | cvtss2si Gd/q,Wss (F3) | cvtpd2pi Qpi,Wpd (66) | cvtsd2si Gd/q,Wsd (F2)
+2e: ucomiss Vss,Wss | ucomisd  Vsd,Wsd (66)
+2f: comiss Vss,Wss | comisd  Vsd,Wsd (66)
 # 0x0f 0x30-0x3f
 30: WRMSR
 31: RDTSC
@@ -378,56 +378,56 @@ Referrer: 2-byte escape
 4e: CMOVLE/NG Gv,Ev
 4f: CMOVNLE/G Gv,Ev
 # 0x0f 0x50-0x5f
-50:
-51:
-52:
-53:
-54:
-55:
-56:
-57:
-58:
-59:
-5a:
-5b:
-5c:
-5d:
-5e:
-5f:
+50: movmskps Gd/q,Ups | movmskpd Gd/q,Upd (66)
+51: sqrtps Vps,Wps | sqrtss Vss,Wss (F3) | sqrtpd Vpd,Wpd (66) | sqrtsd Vsd,Wsd (F2)
+52: rsqrtps Vps,Wps | rsqrtss Vss,Wss (F3)
+53: rcpps Vps,Wps | rcpss Vss,Wss (F3)
+54: andps Vps,Wps | andpd Vpd,Wpd (66)
+55: andnps Vps,Wps | andnpd Vpd,Wpd (66)
+56: orps Vps,Wps | orpd Vpd,Wpd (66)
+57: xorps Vps,Wps | xorpd Vpd,Wpd (66)
+58: addps Vps,Wps | addss Vss,Wss (F3) | addpd Vpd,Wpd (66) | addsd Vsd,Wsd (F2)
+59: mulps Vps,Wps | mulss Vss,Wss (F3) | mulpd Vpd,Wpd (66) | mulsd Vsd,Wsd (F2)
+5a: cvtps2pd Vpd,Wps | cvtss2sd Vsd,Wss (F3) | cvtpd2ps Vps,Wpd (66) | cvtsd2ss Vsd,Wsd (F2)
+5b: cvtdq2ps Vps,Wdq | cvtps2dq Vdq,Wps (66) | cvttps2dq Vdq,Wps (F3)
+5c: subps Vps,Wps | subss Vss,Wss (F3) | subpd Vpd,Wpd (66) | subsd Vsd,Wsd (F2)
+5d: minps Vps,Wps | minss Vss,Wss (F3) | minpd Vpd,Wpd (66) | minsd Vsd,Wsd (F2)
+5e: divps Vps,Wps | divss Vss,Wss (F3) | divpd Vpd,Wpd (66) | divsd Vsd,Wsd (F2)
+5f: maxps Vps,Wps | maxss Vss,Wss (F3) | maxpd Vpd,Wpd (66) | maxsd Vsd,Wsd (F2)
 # 0x0f 0x60-0x6f
-60:
-61:
-62:
-63:
-64:
-65:
-66:
-67:
-68:
-69:
-6a:
-6b:
-6c:
-6d:
-6e:
-6f:
+60: punpcklbw Pq,Qd | punpcklbw Vdq,Wdq (66)
+61: punpcklwd Pq,Qd | punpcklwd Vdq,Wdq (66)
+62: punpckldq Pq,Qd | punpckldq Vdq,Wdq (66)
+63: packsswb Pq,Qq | packsswb Vdq,Wdq (66)
+64: pcmpgtb Pq,Qq | pcmpgtb Vdq,Wdq (66)
+65: pcmpgtw Pq,Qq | pcmpgtw(66) Vdq,Wdq
+66: pcmpgtd Pq,Qq | pcmpgtd Vdq,Wdq (66)
+67: packuswb Pq,Qq | packuswb(66) Vdq,Wdq
+68: punpckhbw Pq,Qd | punpckhbw Vdq,Wdq (66)
+69: punpckhwd Pq,Qd | punpckhwd Vdq,Wdq (66)
+6a: punpckhdq Pq,Qd | punpckhdq Vdq,Wdq (66)
+6b: packssdw Pq,Qd | packssdw Vdq,Wdq (66)
+6c: punpcklqdq Vdq,Wdq (66)
+6d: punpckhqdq Vdq,Wdq (66)
+6e: movd/q/ Pd,Ed/q | movd/q Vdq,Ed/q (66)
+6f: movq Pq,Qq | movdqa Vdq,Wdq (66) | movdqu Vdq,Wdq (F3)
 # 0x0f 0x70-0x7f
-70:
+70: pshufw Pq,Qq,Ib | pshufd Vdq,Wdq,Ib (66) | pshufhw Vdq,Wdq,Ib (F3) | pshuflw VdqWdq,Ib (F2)
 71: Grp12 (1A)
 72: Grp13 (1A)
 73: Grp14 (1A)
-74:
-75:
-76:
-77:
+74: pcmpeqb Pq,Qq | pcmpeqb Vdq,Wdq (66)
+75: pcmpeqw Pq,Qq | pcmpeqw Vdq,Wdq (66)
+76: pcmpeqd Pq,Qq | pcmpeqd Vdq,Wdq (66)
+77: emms
 78: VMREAD Ed/q,Gd/q
 79: VMWRITE Gd/q,Ed/q
 7a:
 7b:
-7c:
-7d:
-7e:
-7f:
+7c: haddps(F2) Vps,Wps | haddpd(66) Vpd,Wpd
+7d: hsubps(F2) Vps,Wps | hsubpd(66) Vpd,Wpd
+7e: movd/q Ed/q,Pd | movd/q Ed/q,Vdq (66) | movq Vq,Wq (F3)
+7f: movq Qq,Pq | movdqa Wdq,Vdq (66) | movdqu Wdq,Vdq (F3)
 # 0x0f 0x80-0x8f
 80: JO Jz (f64)
 81: JNO Jz (f64)
@@ -499,11 +499,11 @@ bf: MOVSX Gv,Ew
 # 0x0f 0xc0-0xcf
 c0: XADD Eb,Gb
 c1: XADD Ev,Gv
-c2:
+c2: cmpps Vps,Wps,Ib | cmpss Vss,Wss,Ib (F3) | cmppd Vpd,Wpd,Ib (66) | cmpsd Vsd,Wsd,Ib (F2)
 c3: movnti Md/q,Gd/q
-c4:
-c5:
-c6:
+c4: pinsrw Pq,Rd/q/Mw,Ib | pinsrw Vdq,Rd/q/Mw,Ib (66)
+c5: pextrw Gd,Nq,Ib | pextrw Gd,Udq,Ib (66)
+c6: shufps Vps,Wps,Ib | shufpd Vpd,Wpd,Ib (66)
 c7: Grp9 (1A)
 c8: BSWAP RAX/EAX/R8/R8D
 c9: BSWAP RCX/ECX/R9/R9D
@@ -514,60 +514,131 @@ cd: BSWAP RBP/EBP/R13/R13D
 ce: BSWAP RSI/ESI/R14/R14D
 cf: BSWAP RDI/EDI/R15/R15D
 # 0x0f 0xd0-0xdf
-d0:
-d1:
-d2:
-d3:
-d4:
-d5:
-d6:
-d7:
-d8:
-d9:
-da:
-db:
-dc:
-dd:
-de:
-df:
+d0: addsubps Vps,Wps (F2) | addsubpd Vpd,Wpd (66)
+d1: psrlw Pq,Qq | psrlw Vdq,Wdq (66)
+d2: psrld Pq,Qq | psrld Vdq,Wdq (66)
+d3: psrlq Pq,Qq | psrlq Vdq,Wdq (66)
+d4: paddq Pq,Qq | paddq Vdq,Wdq (66)
+d5: pmullw Pq,Qq | pmullw Vdq,Wdq (66)
+d6: movq Wq,Vq (66) | movq2dq Vdq,Nq (F3) | movdq2q Pq,Uq (F2)
+d7: pmovmskb Gd,Nq | pmovmskb Gd,Udq (66)
+d8: psubusb Pq,Qq | psubusb Vdq,Wdq (66)
+d9: psubusw Pq,Qq | psubusw Vdq,Wdq (66)
+da: pminub Pq,Qq | pminub Vdq,Wdq (66)
+db: pand Pq,Qq | pand Vdq,Wdq (66)
+dc: paddusb Pq,Qq | paddusb Vdq,Wdq (66)
+dd: paddusw Pq,Qq | paddusw Vdq,Wdq (66)
+de: pmaxub Pq,Qq | pmaxub Vdq,Wdq (66)
+df: pandn Pq,Qq | pandn Vdq,Wdq (66)
 # 0x0f 0xe0-0xef
-e0:
-e1:
-e2:
-e3:
-e4:
-e5:
-e6:
-e7:
-e8:
-e9:
-ea:
-eb:
-ec:
-ed:
-ee:
-ef:
+e0: pavgb Pq,Qq | pavgb Vdq,Wdq (66)
+e1: psraw Pq,Qq | psraw Vdq,Wdq (66)
+e2: psrad Pq,Qq | psrad Vdq,Wdq (66)
+e3: pavgw Pq,Qq | pavgw Vdq,Wdq (66)
+e4: pmulhuw Pq,Qq | pmulhuw Vdq,Wdq (66)
+e5: pmulhw Pq,Qq | pmulhw Vdq,Wdq (66)
+e6: cvtpd2dq Vdq,Wpd (F2) | cvttpd2dq Vdq,Wpd (66) | cvtdq2pd Vpd,Wdq (F3)
+e7: movntq Mq,Pq | movntdq Mdq,Vdq (66)
+e8: psubsb Pq,Qq | psubsb Vdq,Wdq (66)
+e9: psubsw Pq,Qq | psubsw Vdq,Wdq (66)
+ea: pminsw Pq,Qq | pminsw Vdq,Wdq (66)
+eb: por Pq,Qq | por Vdq,Wdq (66)
+ec: paddsb Pq,Qq | paddsb Vdq,Wdq (66)
+ed: paddsw Pq,Qq | paddsw Vdq,Wdq (66)
+ee: pmaxsw Pq,Qq | pmaxsw Vdq,Wdq (66)
+ef: pxor Pq,Qq | pxor Vdq,Wdq (66)
 # 0x0f 0xf0-0xff
-f0:
-f1:
-f2:
-f3:
-f4:
-f5:
-f6:
-f7:
-f8:
-f9:
-fa:
-fb:
-fc:
-fd:
-fe:
+f0: lddqu Vdq,Mdq (F2)
+f1: psllw Pq,Qq | psllw Vdq,Wdq (66)
+f2: pslld Pq,Qq | pslld Vdq,Wdq (66)
+f3: psllq Pq,Qq | psllq Vdq,Wdq (66)
+f4: pmuludq Pq,Qq | pmuludq Vdq,Wdq (66)
+f5: pmaddwd Pq,Qq | pmaddwd Vdq,Wdq (66)
+f6: psadbw Pq,Qq | psadbw Vdq,Wdq (66)
+f7: maskmovq Pq,Nq | maskmovdqu Vdq,Udq (66)
+f8: psubb Pq,Qq | psubb Vdq,Wdq (66)
+f9: psubw Pq,Qq | psubw Vdq,Wdq (66)
+fa: psubd Pq,Qq | psubd Vdq,Wdq (66)
+fb: psubq Pq,Qq | psubq Vdq,Wdq (66)
+fc: paddb Pq,Qq | paddb Vdq,Wdq (66)
+fd: paddw Pq,Qq | paddw Vdq,Wdq (66)
+fe: paddd Pq,Qq | paddd Vdq,Wdq (66)
 ff:
 EndTable
 
 Table: 3-byte opcode 1
 Referrer: 3-byte escape 1
+# 0x0f 0x38 0x00-0x0f
+00: pshufb Pq,Qq | pshufb Vdq,Wdq (66)
+01: phaddw Pq,Qq | phaddw Vdq,Wdq (66)
+02: phaddd Pq,Qq | phaddd Vdq,Wdq (66)
+03: phaddsw Pq,Qq | phaddsw Vdq,Wdq (66)
+04: pmaddubsw Pq,Qq | pmaddubsw (66)Vdq,Wdq
+05: phsubw Pq,Qq | phsubw Vdq,Wdq (66)
+06: phsubd Pq,Qq | phsubd Vdq,Wdq (66)
+07: phsubsw Pq,Qq | phsubsw Vdq,Wdq (66)
+08: psignb Pq,Qq | psignb Vdq,Wdq (66)
+09: psignw Pq,Qq | psignw Vdq,Wdq (66)
+0a: psignd Pq,Qq | psignd Vdq,Wdq (66)
+0b: pmulhrsw Pq,Qq | pmulhrsw Vdq,Wdq (66)
+0c:
+0d:
+0e:
+0f:
+# 0x0f 0x38 0x10-0x1f
+10: pblendvb Vdq,Wdq (66)
+11:
+12:
+13:
+14: blendvps Vdq,Wdq (66)
+15: blendvpd Vdq,Wdq (66)
+16:
+17: ptest Vdq,Wdq (66)
+18:
+19:
+1a:
+1b:
+1c: pabsb Pq,Qq | pabsb Vdq,Wdq (66)
+1d: pabsw Pq,Qq | pabsw Vdq,Wdq (66)
+1e: pabsd Pq,Qq | pabsd Vdq,Wdq (66)
+1f:
+# 0x0f 0x38 0x20-0x2f
+20: pmovsxbw Vdq,Udq/Mq (66)
+21: pmovsxbd Vdq,Udq/Md (66)
+22: pmovsxbq Vdq,Udq/Mw (66)
+23: pmovsxwd Vdq,Udq/Mq (66)
+24: pmovsxwq Vdq,Udq/Md (66)
+25: pmovsxdq Vdq,Udq/Mq (66)
+26:
+27:
+28: pmuldq Vdq,Wdq (66)
+29: pcmpeqq Vdq,Wdq (66)
+2a: movntdqa Vdq,Mdq (66)
+2b: packusdw Vdq,Wdq (66)
+2c:
+2d:
+2e:
+2f:
+# 0x0f 0x38 0x30-0x3f
+30: pmovzxbw Vdq,Udq/Mq (66)
+31: pmovzxbd Vdq,Udq/Md (66)
+32: pmovzxbq Vdq,Udq/Mw (66)
+33: pmovzxwd Vdq,Udq/Mq (66)
+34: pmovzxwq Vdq,Udq/Md (66)
+35: pmovzxdq Vdq,Udq/Mq (66)
+36:
+37: pcmpgtq Vdq,Wdq (66)
+38: pminsb Vdq,Wdq (66)
+39: pminsd Vdq,Wdq (66)
+3a: pminuw Vdq,Wdq (66)
+3b: pminud Vdq,Wdq (66)
+3c: pmaxsb Vdq,Wdq (66)
+3d: pmaxsd Vdq,Wdq (66)
+3e: pmaxuw Vdq,Wdq (66)
+3f: pmaxud Vdq,Wdq (66)
+# 0x0f 0x38 0x4f-0xff
+40: pmulld Vdq,Wdq (66)
+41: phminposuw Vdq,Wdq (66)
 80: INVEPT Gd/q,Mdq (66)
 81: INVPID Gd/q,Mdq (66)
 f0: MOVBE Gv,Mv | CRC32 Gd,Eb (F2)
@@ -576,7 +647,29 @@ EndTable
 
 Table: 3-byte opcode 2
 Referrer: 3-byte escape 2
-# all opcode is for SSE
+# 0x0f 0x3a 0x00-0xff
+08: roundps Vdq,Wdq,Ib (66)
+09: roundpd Vdq,Wdq,Ib (66)
+0a: roundss Vss,Wss,Ib (66)
+0b: roundsd Vsd,Wsd,Ib (66)
+0c: blendps Vdq,Wdq,Ib (66)
+0d: blendpd Vdq,Wdq,Ib (66)
+0e: pblendw Vdq,Wdq,Ib (66)
+0f: palignr Pq,Qq,Ib | palignr Vdq,Wdq,Ib (66)
+14: pextrb Rd/Mb,Vdq,Ib (66)
+15: pextrw Rd/Mw,Vdq,Ib (66)
+16: pextrd/pextrq Ed/q,Vdq,Ib (66)
+17: extractps Ed,Vdq,Ib (66)
+20: pinsrb Vdq,Rd/q/Mb,Ib (66)
+21: insertps Vdq,Udq/Md,Ib (66)
+22: pinsrd/pinsrq Vdq,Ed/q,Ib (66)
+40: dpps Vdq,Wdq,Ib (66)
+41: dppd Vdq,Wdq,Ib (66)
+42: mpsadbw Vdq,Wdq,Ib (66)
+60: pcmpestrm Vdq,Wdq,Ib (66)
+61: pcmpestri Vdq,Wdq,Ib (66)
+62: pcmpistrm Vdq,Wdq,Ib (66)
+63: pcmpistri Vdq,Wdq,Ib (66)
 EndTable
 
 GrpTable: Grp1


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
