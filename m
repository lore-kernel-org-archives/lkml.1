Return-Path: <linux-kernel-owner+w=401wt.eu-S1764770AbYECPcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764770AbYECPcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYECPcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:32:13 -0400
Received: from www.tglx.de ([62.245.132.106]:51328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbYECPcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:32:13 -0400
Date: Sat, 3 May 2008 17:31:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: jamal <hadi@cyberus.ca>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <1209810775.6972.37.camel@localhost>
Message-ID: <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
References: <1209810775.6972.37.camel@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, jamal wrote:
>  =======================
> Code: 8d 74 26 00 8d bc 27 00 00 00 00 55 89 c2 8b 40 04 89 e5 f6 40 0c
> 01 74 32 8b 82 60 02 00 00 0f ae 00 0f ba 60 02 07 73 02 db e2 <0f> 1f
> 00 90 8d b4 26 00 00 00 00 89 f6 8b 42 04 83 60 0c fe 0f

This looks bad.

  0f ae 00		fxsave (%eax)
  0f ba 60 02 07       	btl    $0x7,0x2(%eax)
  73 02                	jae    (skip fnclex)
  db e2                	fnclex 
  0f 1f 00             	nopl   (%eax)

 ^^^^ This is a P4+ instruction. So it's not surprising that the P2
 chokes. The question is where this comes from.

we have:
#define P6_NOP3 ".byte 0x0f,0x1f,0x00\n"

So the alternatives code applies the wrong nop padding for your
CPU. This was probably introduced with commit
32c464f5d9701db45bc1673288594e664065388e. 

Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I
have to dig up the manuals.

Jamal, does the following patch solve your problem ? Please provide
also output of /proc/cpuinfo.

Thanks,
	tglx
---

--- linux-2.6.orig/arch/x86/kernel/alternative.c
+++ linux-2.6/arch/x86/kernel/alternative.c
@@ -158,7 +158,6 @@ static const struct nop {
 	{ X86_FEATURE_K8, k8_nops },
 	{ X86_FEATURE_K7, k7_nops },
 	{ X86_FEATURE_P4, p6_nops },
-	{ X86_FEATURE_P3, p6_nops },
 	{ -1, NULL }
 };
 
