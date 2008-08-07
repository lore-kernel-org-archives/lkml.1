Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYHGAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYHGAjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYHGAjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:39:04 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:44618 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbYHGAjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:39:01 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Thu, 7 Aug 2008 02:38:58 +0200
User-Agent: KMail/1.9.9
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, vegard.nossum@gmail.com
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <20080806212152.GB607@linux-os.sc.intel.com>
In-Reply-To: <20080806212152.GB607@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 4020
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200808070238.58959.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your answer.

On Wednesday 06 August 2008, Suresh Siddha wrote:
> On Wed, Aug 06, 2008 at 01:14:02PM -0700, Siddha, Suresh B wrote:
> > On Wed, Aug 06, 2008 at 10:33:25AM -0700, Wolfgang Walter wrote:
> > > Hello Herbert,
> > >
> > > I think I finally found the problem.
> > >
> > > Here a short description again: all our routers with a via C3 using 
> > > padlock for AES-encryption are
> > > crashing with 2.6.26 while they work fine with 2.6.25. Not using padlock
> > > (i.e. using the i386 assembler version of AES) they just work fine.
> > 
> > Both the padlock version or asm version don't use FP/math registers, 
> > right?
> > It is interesting that you don't see the problem with asm version
> > but see the problem with padlock version.

I don't know how padlock exactly works and I don't know anything of i386's 
architecture on hardware and assembler level. So I can only speculate:

Maybe padlock aes does influence FP/math.

http://linux.via.com.tw/support/beginDownload.action?eleid=181&fid=261

states:

3. SSE instructions must be enabled via the standard x86 method of enabling
the FXSAVE/FXRSTOR instructions using CR4[9] This enables the full set of SSE
instructions. If CR4[9] is not set, PadLock behaves as if it were disabled via
the MSR, regardless of the setting of the enable bits MSRs.


> > 
> > Does disabling CONFIG_PREEMPT in 2.6.26 change anything? And also,
> > can you provide the complete kernel log till the point of failure(oops
> > that you sent doesn't have the call trace info)
> 
> BTW, in one of your oops, I see:
> 
> note: cron[1207] exited with preempt_count 268435459
> 
> I smell some kind of stack corruption here which is corrupting
> thread_info (in the above case preempt_count in the thread_info).
> 
> Similarly, if the status field(in thread_info) gets corrupted(setting
> TS_USEDFPU) without proper math state allocated(present in thread_struct),
> we can end up oops in __switch_to.
> 
> But you seem to say, reverting recent fpu patches make the problem go away.
> hmm, just wondering if your test kernel (with fpu patches reverted) is 
stable
> enough and don't see other oops/issues?

No oops yet.

2.6.26 crashes here within 1 or 2 minutes if (and only) if there is ipsec 
traffic using padlock aes and there are actually processes running (i.e. 
ssh).

The modified 2.6.26 did not crash yet (now running hours).

Unmodified 2.6.26 where we use i386 assembler aes instead of padlock runs 
since 2 weeks.

We further use almost same kernels (only compiled for K7 or Intel Core Duo, 
respectively) on K7 and an Intel Quad Core without problems.

> 
> Recently Vegard also noticed some stack corruptions (in network stack) 
leading
> to similar problems. Not sure if Vegard has root caused his issue. copying 
him
> for his comments.
> 
> thanks,
> suresh
> 
> 

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
