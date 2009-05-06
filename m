Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZEFNwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZEFNwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZEFNwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:52:24 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:15599 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZEFNwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:52:23 -0400
Message-ID: <4A019614.9080702@codemonkey.ws>
Date: Wed, 06 May 2009 08:52:20 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [RFC PATCH 1/3] add generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <20090505132437.19891.42922.stgit@dev.haskins.net>
In-Reply-To: <20090505132437.19891.42922.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> We add a generic hypercall() mechanism for use by IO code which is
> compatible with a variety of hypervisors, but which prefers to use
> hypercalls over other types of hypervisor traps for performance and/or
> feature reasons.
>
> For instance, consider an emulated PCI device in KVM.  Today we can chose
> to do IO over MMIO or PIO infrastructure, but they each have their own
> distinct disadvantages:
>
> *) MMIO causes a page-fault, which must be decoded by the hypervisor and is
>    therefore fairly expensive.
>
> *) PIO is more direct than MMIO, but it poses other problems such as:
>       a) can have a small limited address space (x86 is 2^16)
>       b) is a narrow-band interface (one 8, 16, 32, 64 bit word at a time)
>       c) not available on all archs (PCI mentions ppc as problematic) and
>          is therefore recommended to avoid.
>
> Hypercalls, on the other hand, offer a direct access path like PIOs, yet
> do not suffer the same drawbacks such as a limited address space or a
> narrow-band interface.  Hypercalls are much more friendly to software
> to software interaction since we can pack multiple registers in a way
> that is natural and simple for software to utilize.
>   

No way.  Hypercalls are just about awful because they cannot be 
implemented sanely with VT/SVM as Intel/AMD couldn't agree on a common 
instruction for it.  This means you either need a hypercall page, which 
I'm pretty sure makes transparent migration impossible, or you need to 
do hypercall patching which is going to throw off attestation.

If anything, I'd argue that we shouldn't use hypercalls for anything in 
KVM because it will break run-time attestation.

Hypercalls cannot pass any data either.  We pass data with hypercalls by 
relying on external state (like register state).  It's just as easy to 
do this with PIO. VMware does this with vmport, for instance.  However, 
in general, you do not want to pass that much data with a notification.  
It's better to rely on some external state (like a ring queue) and have 
the "hypercall" act simply as a notification mechanism.

Regards,

Anthony Liguori
