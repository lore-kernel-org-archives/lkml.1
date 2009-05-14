Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZENIGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZENIGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZENIF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:05:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29066 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbZENIFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:05:55 -0400
Message-Id: <4A0BED040200007800000DB0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 14 May 2009 09:05:56 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jun Nakajima" <jun.nakajima@intel.com>,
       "Xiaohui Xin" <xiaohui.xin@intel.com>, "Xin Li" <xin.li@intel.com>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Performance overhead of paravirt_ops on
	 nativeidentified
References: <4A0B62F7.5030802@goop.org>
In-Reply-To: <4A0B62F7.5030802@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.05.09 02:16 >>>
>One possibility is to inline _spin_lock, etc, when building an
>optimised kernel (ie, when there's no spinlock/preempt
>instrumentation/debugging enabled).  That will remove the outer
>call/return pair, returning the instruction stream to a single
>call/return, which will presumably execute the same as the non-pvops
>case.  The downsides arel 1) it will replicate the
>preempt_disable/enable code at eack lock/unlock callsite; this code is
>fairly small, but not nothing; and 2) the spinlock definitions are
>already a very heavily tangled mass of #ifdefs and other preprocessor
>magic, and making any changes will be non-trivial.
>
>The other obvious answer is to disable pv-spinlocks.  Making them a
>separate config option is fairly easy, and it would be trivial to
>enable them only when Xen is enabled (as the only non-default user).
>But it doesn't really address the common case of a distro build which
>is going to have Xen support enabled, and leaves the open question of
>whether the native performance cost of pv-spinlocks is worth the
>performance improvement on a loaded Xen system (10% saving of overall
>system CPU when guests block rather than spin).  Still it is a
>reasonable short-term workaround.

Wouldn't a third solution be to use ticket spinlocks everywhere, i.e. eliminate
the current indirection, and replace it by an indirection for just the contention
case? As I view it, the problem for Xen aren't really the ticket locks by
themselves, but rather the extra spinning involved, which is of concern only
if a lock is contended. We're using ticket locks quite happily in our kernels,
with directed instead of global wakeup from the unlock path. The only open
issue we currently have is that while for native keeping interrupts disabled
while spinning may be acceptable (though I'm not sure how -rt folks are
viewing this), in a pv environment one should really re-enable interrupts
here due to the potentially much higher latency.

Jan

