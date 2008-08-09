Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYHIP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYHIP5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYHIP5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:57:36 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:57257 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbYHIP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:57:35 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sat, 9 Aug 2008 17:57:32 +0200
User-Agent: KMail/1.9.9
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809143727.GA30499@gondor.apana.org.au>
In-Reply-To: <20080809143727.GA30499@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808091757.32999.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Herbert Xu wrote:
> On Fri, Aug 08, 2008 at 04:11:21PM -0700, Suresh Siddha wrote:
> >
> > With out the recent dynamic fpu allocation changes, while we don't see 
oops,
> > there is a possible race still present in older kernels(for example,
> > while kernel is using kernel_fpu_begin() in some optimized clear/copy
> > page and an interrupt/softirq happens which uses these padlock
> > instructions generating DNA fault).
> 
> No this wasn't a problem because kernel_fpu_begin clears TS and
> therefore we don't get faults on SSE instructions.
> 
> However, with your patch it will become a problem due to the
> fact that it wasn't designed to be nested.
> 


I don't exactly understand this. You think that

kernel_fpu_begin();
XCRYPT....
kernel_fpu_end();

is a problem and wasn't before?

Say we have a software crypt-alg which uses optimized memcpy implemented with 
SSE instructions. These are protected with kernel_fpu_begin(); 
kernel_fpu_end();

So we have also code

kernel_fpu_begin();
SSE....
kernel_fpu_end();

in crypto called under same circumstances.

If XCRYPT may be interrupted and the interrupt code again uses this optimized 
memcpy implementation and so nesting kernel_fpu_begin then why should this 
not happen with the other alg.

How could any kernel code use MMX/SSE/FPU when the interrupt case isn't 
handled?


Or is your argument that its lazy allocation itself is the problem: this 
nesting could always happen and was a bug but only with lazy allocation it is 
dangerous (as it may cause a spurious math fault in the race window).

If this were right than any kernel code executing SSE may trigger now a oops 
in __switch_to() under some special circumstances.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196-276
Fax: +49 89 38196-144
wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
