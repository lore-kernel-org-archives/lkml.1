Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYCNRpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYCNRpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYCNRpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:45:35 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:52695 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbYCNRpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:45:34 -0400
Date: Fri, 14 Mar 2008 18:45:09 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 1/4] introduce explicit signed/unsigned 64bit divide
In-Reply-To: <20080313133459.8d7d870d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803141839080.1791@scrub.home>
References: <20080313002235.351414762@linux-m68k.org> <20080313004902.808083566@linux-m68k.org>
 <Pine.LNX.4.64.0803131110520.9727@vixen.sonytel.be>
 <Pine.LNX.4.64.0803131546420.1791@scrub.home> <20080313133459.8d7d870d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Mar 2008, Andrew Morton wrote:

> I think what happened was that [patch 3/4] fixed this up.  Of course,
> that patch doesn't apply on this updated [1/4].  I _could_ just take the
> old [1/4] (I think), but I don't know if that wouild be bisection-friendly.
> 
> Anyway, please redo&resend?  Thanks.

Done.

> Please have a think about that code in arch/x86/kvm/i8254.c too.  It is
> painful to see remote subsystems (re)implementing generic infrastructure.
> Can KVM use existing code?  Should we hoist what KVM has done there into
> generic code?  Did it have to use a(nother bleeding) macro?

Looker closer at it, div64_u64() seems to be a bit overkill, as the 
divisor is a 32bit value, so the following should do the same job (only 
compile tested):

u64 muldiv64(u64 a, u32 b, u32 c)
{       
	union { 
		u64 ll;
		struct {
			u32 low, high;
		};
	} u, res, rl, rh;

	u.ll = a;
	rl.ll = (u64)b * u.low;
	rh.ll = (u64)b * u.high;
	rh.ll += rl.high;
	res.high = div_u64_rem(rh.ll, c, &rl.high);
	res.low = div_u64(rl.ll, c);
	return res.ll;
}

Moving it to a more generic location shouldn't be a big problem.

bye, Roman
