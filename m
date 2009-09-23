Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZIWOjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZIWOjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZIWOjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZIWOjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:39:15 -0400
Message-ID: <4ABA32AF.50602@redhat.com>
Date: Wed, 23 Sep 2009 17:37:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <4AB0A070.1050400@redhat.com> <4AB0CFA5.6040104@gmail.com> <4AB0E2A2.3080409@redhat.com> <4AB0F1EF.5050102@gmail.com> <4AB10B67.2050108@redhat.com> <4AB13B09.5040308@gmail.com> <4AB151D7.10402@redhat.com> <4AB1A8FD.2010805@gmail.com> <20090921214312.GJ7182@ovro.caltech.edu> <4AB89C48.4020903@redhat.com> <4ABA3005.60905@gmail.com>
In-Reply-To: <4ABA3005.60905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 05:26 PM, Gregory Haskins wrote:
>
>    
>>> Yes, I'm having to create my own bus model, a-la lguest, virtio-pci, and
>>> virtio-s390. It isn't especially easy. I can steal lots of code from the
>>> lguest bus model, but sometimes it is good to generalize, especially
>>> after the fourth implemention or so. I think this is what GHaskins tried
>>> to do.
>>>
>>>        
>> Yes.  vbus is more finely layered so there is less code duplication.
>>      
> To clarify, Ira was correct in stating this generalizing some of these
> components was one of the goals for the vbus project: IOW vbus finely
> layers and defines what's below virtio, not replaces it.
>
> You can think of a virtio-stack like this:
>
> --------------------------
> | virtio-net
> --------------------------
> | virtio-ring
> --------------------------
> | virtio-bus
> --------------------------
> | ? undefined ?
> --------------------------
>
> IOW: The way I see it, virtio is a device interface model only.  The
> rest of it is filled in by the virtio-transport and some kind of back-end.
>
> So today, we can complete the "? undefined ?" block like this for KVM:
>
> --------------------------
> | virtio-pci
> --------------------------
>               |
> --------------------------
> | kvm.ko
> --------------------------
> | qemu
> --------------------------
> | tuntap
> --------------------------
>
> In this case, kvm.ko and tuntap are providing plumbing, and qemu is
> providing a backend device model (pci-based, etc).
>
> You can, of course, plug a different stack in (such as virtio-lguest,
> virtio-ira, etc) but you are more or less on your own to recreate many
> of the various facilities contained in that stack (such as things
> provided by QEMU, like discovery/hotswap/addressing), as Ira is discovering.
>
> Vbus tries to commoditize more components in the stack (like the bus
> model and backend-device model) so they don't need to be redesigned each
> time we solve this "virtio-transport" problem.  IOW: stop the
> proliferation of the need for pci-bus, lguest-bus, foo-bus underneath
> virtio.  Instead, we can then focus on the value add on top, like the
> models themselves or the simple glue between them.
>
> So now you might have something like
>
> --------------------------
> | virtio-vbus
> --------------------------
> | vbus-proxy
> --------------------------
> | kvm-guest-connector
> --------------------------
>               |
> --------------------------
> | kvm.ko
> --------------------------
> | kvm-host-connector.ko
> --------------------------
> | vbus.ko
> --------------------------
> | virtio-net-backend.ko
> --------------------------
>
> so now we don't need to worry about the bus-model or the device-model
> framework.  We only need to implement the connector, etc.  This is handy
> when you find yourself in an environment that doesn't support PCI (such
> as Ira's rig, or userspace containers), or when you want to add features
> that PCI doesn't have (such as fluid event channels for things like IPC
> services, or priortizable interrupts, etc).
>    

Well, vbus does more, for example it tunnels interrupts instead of 
exposing them 1:1 on the native interface if it exists.  It also pulls 
parts of the device model into the host kernel.

>> The virtio layering was more or less dictated by Xen which doesn't have
>> shared memory (it uses grant references instead).  As a matter of fact
>> lguest, kvm/pci, and kvm/s390 all have shared memory, as you do, so that
>> part is duplicated.  It's probably possible to add a virtio-shmem.ko
>> library that people who do have shared memory can reuse.
>>      
> Note that I do not believe the Xen folk use virtio, so while I can
> appreciate the foresight that went into that particular aspect of the
> design of the virtio model, I am not sure if its a realistic constraint.
>    

Since a virtio goal was to reduce virtual device driver proliferation, 
it was necessary to accommodate Xen.

-- 
error compiling committee.c: too many arguments to function

