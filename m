Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbZEGTo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbZEGTo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZEGTor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:44:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48640 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZEGToq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:44:46 -0400
Message-ID: <4A0339D2.3050600@redhat.com>
Date: Thu, 07 May 2009 22:43:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <4A033101.8050106@gmail.com>
In-Reply-To: <4A033101.8050106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> Don't - it's broken.  It will also catch device assignment mmio and
>> hypercall them.
>>
>>     
> Ah.  Crap.
>
> Would you be conducive if I continue along with the dynhc() approach then?
>   

Oh yes.  But don't call it dynhc - like Chris says it's the wrong semantic.

Since we want to connect it to an eventfd, call it HC_NOTIFY or HC_EVENT 
or something along these lines.  You won't be able to pass any data, but 
that's fine.  Registers are saved to memory anyway.

And btw, given that eventfd and the underlying infrastructure are so 
flexible, it's probably better to go back to your original "irqfd gets 
fd from userspace" just to be consistent everywhere.

(no, I'm not deliberately making you rewrite that patch again and 
again... it's going to be a key piece of infrastructure so I want to get 
it right)

Just to make sure we have everything plumbed down, here's how I see 
things working out (using qemu and virtio, use sed to taste):

1. qemu starts up, sets up the VM
2. qemu creates virtio-net-server
3. qemu allocates six eventfds: irq, stopirq, notify (one set for tx 
ring, one set for rx ring)
4. qemu connects the six eventfd to the data-available, 
data-not-available, and kick ports of virtio-net-server
5. the guest starts up and configures virtio-net in pci pin mode
6. qemu notices and decides it will manage interrupts in user space 
since this is complicated (shared level triggered interrupts)
7. the guest OS boots, loads device driver
8. device driver switches virtio-net to msix mode
9. qemu notices, plumbs the irq fds as msix interrupts, plumbs the 
notify fds as notifyfd
10. look ma, no hands.

Under the hood, the following takes place.

kvm wires the irqfds to schedule a work item which fires the interrupt.  
One day the kvm developers get their act together and change it to 
inject the interrupt directly when the irqfd is signalled (which could 
be from the net softirq or somewhere similarly nasty).

virtio-net-server wires notifyfd according to its liking.  It may 
schedule a thread, or it may execute directly.

And they all lived happily ever after.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

