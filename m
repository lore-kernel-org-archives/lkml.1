Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXCGLHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXCGLHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965083AbXCGLHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:07:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:49601 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052AbXCGLHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:07:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [RFC] [patch 4/6 -rt] powerpc 2.6.20-rt8: fix a runtime warnings for xmon
Date: Wed, 7 Mar 2007 12:06:51 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Tsutomu OWA <tsutomu.owa@toshiba.co.jp>,
       linux-kernel@vger.kernel.org
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi3b4h25jj.wl@toshiba.co.jp> <20070307091638.GC1783@elte.hu>
In-Reply-To: <20070307091638.GC1783@elte.hu>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703071206.52551.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+Qq2W+ZXTE356OsKatWZZ9dMAzf9DeAW+L4gY
 vWOSHdkfMiJfJB1AqqWIscZXppKPLETRcyzn31ckTY2bLbiKyU
 P3nGxoWb5tkmFgMp427BQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007, Ingo Molnar wrote:
> i'm not an xmon expert, but maybe it might make more sense to first 
> disable preemption, then interrupts - otherwise you could be preempted 
> right after having disabled these interrupts (and be scheduled to 
> another CPU, etc.). What is the difference between local_irq_save() and 
> the above 'disable interrupts' sequence? If it's not the same and 
> xmon_core() relied on having hardirqs disabled then it might make sense 
> to do a local_irq_save() there, instead of a preempt_disable().

Since relatively recently, powerpc does no longer actually disable
the hardware interrupts with local_irq_disable(), but rather sets
a per-cpu flag that will be checked if an actual interrupt comes
in as part of the critical section.

The mtmsr() sequence in xmon corresponds to hard_irq_disable()
and should probably changed to that, but then you still need
the extra preempt_disable() / preempt_enable().

I think you're right about the sequence having to be
1. preempt_disable()
2. hard_irq_disable()
3.
4. hard_irq_enable()
5. preempt_enable()

	Arnd <><
