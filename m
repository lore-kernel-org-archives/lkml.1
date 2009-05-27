Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZE0HRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZE0HRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbZE0HQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:16:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbZE0HQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:16:28 -0400
Date: Wed, 27 May 2009 09:23:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, x86@kernel.org, Huang Ying <ying.huang@intel.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/31] x86: MCE: Improve mce_get_rip v3
Message-ID: <20090527072302.GR846@one.firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com> <4A1CC19C.3010409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1CC19C.3010409@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:29:16PM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> > From: Huang Ying <ying.huang@intel.com>
> > 
> > Assume RIP is valid when either EIPV or RIPV are set.
> 
> Bad description.
> If RIP means "restart IP" that is valid only if RIPV is set,
> this sentence doesn't make sense completely.

No it doesn't mean restart IP, it just means normal instruction
pointer like everywhere else.

> 
> > This influences
> > whether the machine check exception handler decides to return or panic.
> 
> I suppose you are pointing logics in:

Yes.

> 
>                 mce_get_rip(&m, regs);
>  :
>                         panicm = m;
>  :
>                 /*
>                  * If the EIPV bit is set, it means the saved IP is the
>                  * instruction which caused the MCE.
>                  */
>                 if (m.mcgstatus & MCG_STATUS_EIPV)
>                         user_space = panicm.ip && (panicm.cs & 3);
> 
>                 /*
>                  * If we know that the error was in user space, send a
>                  * SIGBUS.  Otherwise, panic if tolerance is low.
>                  *
>                  * force_sig() takes an awful lot of locks and has a slight
>                  * risk of deadlocking.
>                  */
>                 if (user_space) {
>                         force_sig(SIGBUS, current);
>                 } else if (panic_on_oops || tolerant < 2) {
>                         mce_panic("Uncorrected machine check",
>                                 &panicm, mcestart);
>                 }
> 
> So EIPV without RIPV will be no ip and will result in panic,
> while expected result is SIGBUS. 

First this is only for the !MCA recovery case. In the MCA recovery
case we have more information and can decide better.

In this case no EIPV means that the kernel isn't sure where the 
error occurred so it cannot safely decide if it was user space 
or kernel space and in the tolerant == 2 case has to panic
just in case a kernel kill would cause deadlock.

With MCA recovery this whole this is replaced by a new improved
mechanism using the high level handler.

> > 
> > Also in addition do not force the RIP to be valid with the exact
> > register MSRs.
> 
> I think the forced one is EIP:
> > -		m->mcgstatus |= MCG_STATUS_EIPV;

True. Changed.

> 
> And please note that it keep use CS on stack even if MSR is available.
> 
> I made an alternative patch for this, with no functional change.
> Please consider replacing.

No, sorry I got burned too much last time you touched the description
of this simple patch. I think my description is simple and to the point
and this patch doesn't really deserve anything more.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
