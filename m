Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbXJBFtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbXJBFtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXJBFs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:48:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:60990 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXJBFs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:48:58 -0400
Message-ID: <4701DBB9.9020202@qumranet.com>
Date: Tue, 02 Oct 2007 07:48:41 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH RFC] paravirt: cleanup lazy mode handling
References: <470186C4.5080208@goop.org>
In-Reply-To: <470186C4.5080208@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Currently, the set_lazy_mode pv_op is overloaded with 5 functions:
>  1. enter lazy cpu mode
>  2. leave lazy cpu mode
>  3. enter lazy mmu mode
>  4. leave lazy mmu mode
>  5. flush pending batched operations
>
> This complicates each paravirt backend, since it needs to deal with
> all the possible state transitions, handling flushing, etc. In
> particular, flushing is quite distinct from the other 4 functions, and
> seems to just cause complication.
>
> This patch removes the set_lazy_mode operation, and adds "enter" and
> "leave" lazy mode operations on mmu_ops and cpu_ops.  All the logic
> associated with enter and leaving lazy states is now in common code
> (basically BUG_ONs to make sure that no mode is current when entering
> a lazy mode, and make sure that the mode is current when leaving).
> Also, flush is handled in a common way, by simply leaving and
> re-entering the lazy mode.
>
> The result is that the Xen and VMI lazy mode implementations are much
> simpler; as would lguest's be.
>
>   

The code doesn't support having both lazy modes active at once.  Maybe 
that's not an issue, but aren't the two modes orthogonal?

> --- a/arch/i386/xen/multicalls.h
> +++ b/arch/i386/xen/multicalls.h
> @@ -35,7 +35,7 @@ void xen_mc_flush(void);
>  /* Issue a multicall if we're not in a lazy mode */
>  static inline void xen_mc_issue(unsigned mode)
>  {
> -	if ((xen_get_lazy_mode() & mode) == 0)
> +	if ((paravirt_get_lazy_mode() & mode) == 0)
>  		xen_mc_flush();

This snippet looks like it wants to support concurrently active lazy modes.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

