Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZEEPCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZEEPCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZEEPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:02:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55744 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZEEPCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:02:18 -0400
Message-ID: <4A0054F6.30701@redhat.com>
Date: Tue, 05 May 2009 18:02:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>
In-Reply-To: <4A0049CD.3080003@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> I see.  I had designed it slightly different where KVM could assign any
> top level vector it wanted and thus that drove the guest-side interface
> you see here to be more "generic hypercall".  However, I think your
> proposal is perfectly fine too and it makes sense to more narrowly focus
> these calls as specifically "dynamic"...as thats the only vectors that
> we could technically use like this anyway.
>
> So rather than allocate a top-level vector, I will add "KVM_HC_DYNAMIC"
> to kvm_para.h, and I will change the interface to follow suit (something
> like s/hypercall/dynhc).  Sound good?
>   

Yeah.

Another couple of points:

- on the host side, we'd rig this to hit an eventfd.  Nothing stops us 
from rigging pio to hit an eventfd as well, giving us kernel handling 
for pio trigger points.
- pio actually has an advantage over hypercalls with nested guests.  
Since hypercalls don't have an associated port number, the lowermost 
hypervisor must interpret a hypercall as going to a guest's hypervisor, 
and not any lower-level hypervisors.  What it boils down to is that you 
cannot use device assignment to give a guest access to a virtio/vbus 
device from a lower level hypervisor.

(Bah, that's totally unreadable.  What I want is

instead of

   hypervisor[eth0/virtio-server]   ----> 
intermediate[virtio-driver/virtio-server]  ----> guest[virtio-driver]

do

   hypervisor[eth0/virtio-server]   ----> intermediate[assign virtio 
device]  ----> guest[virtio-driver]

well, it's probably still unreadable)

-- 
error compiling committee.c: too many arguments to function

