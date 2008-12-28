Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYL1OKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYL1OKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 09:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYL1OJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 09:09:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbYL1OJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 09:09:50 -0500
Message-ID: <49578896.8030703@redhat.com>
Date: Sun, 28 Dec 2008 16:09:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
References: <1230238726-17506-1-git-send-email-avi@redhat.com> <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org>
In-Reply-To: <20081228131605.GC496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restoring cc list)

Andi Kleen wrote:
> One of the other problems: NMIs and MCEs have the same problem with SYSCALL
>   

This one however looks unsolvable.  Userspace can point %rsp into 
arbitrary memory, issue a syscall, and hope for an nmi.  Since we're in 
cpl 0 and are not using IST, the processor will not switch stacks, and 
the nmi stack frame will corrupt any memory the user chooses to point to.

Even without a malicious user, %rsp could legitimately point at unmapped 
memory.

I don't see how syscall could work on i386, and indeed:

> vdso32.so-$(VDSO32-y)        += int80
> vdso32.so-$(CONFIG_COMPAT)    += syscall
> vdso32.so-$(VDSO32-y)        += sysenter

It's disabled.  Is that the reason?

-- 
error compiling committee.c: too many arguments to function

