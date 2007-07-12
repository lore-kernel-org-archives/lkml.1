Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbXGLHsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbXGLHsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbXGLHsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:48:01 -0400
Received: from il.qumranet.com ([82.166.9.18]:46551 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbXGLHsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:48:00 -0400
Message-ID: <4695DCAD.70507@qumranet.com>
Date: Thu, 12 Jul 2007 10:47:57 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] lguest: disable SYSENTER for guests
References: <1184224595.6005.772.camel@localhost.localdomain>
In-Reply-To: <1184224595.6005.772.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 12 Jul 2007 10:47:57 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> The SYSENTER instruction jumps to a pre-programmed address at
> privilege level 0.  We must not allow execution of guest code at that
> privilege level, so disable sysenter when we enter the guest (and
> re-enable it on return).  This fixes current case where guest
> userspace can crash host.
>
> This save/restore adds 3% to guest context switch times.  (If only
> there were some kind of scheduler hook or something which would tell
> us when we were being preempted so we could fix this up lazily.  But
> what kind of daredevil coder would propose such a thing?)
>
>   

Ah, so this is why you want ->next in preempt hooks.  Well, my plan for
this sort of thing (for kvm has the same issues with the *STAR family of
msrs) is to add a new hook on switching from kernel to userspace, and
swap those msrs there.  This allows not only the guest1->guest2 case to
be optimized, but also guest->kthread->guest, which is a common pattern
with I/O (and very common with -rt, which runs interrupts in threads).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

