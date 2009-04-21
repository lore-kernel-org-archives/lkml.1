Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZDUJPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZDUJPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZDUJOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:14:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbZDUJOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:14:37 -0400
Message-ID: <49ED8E6D.80005@redhat.com>
Date: Tue, 21 Apr 2009 11:14:21 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Xenner design and kvm msr handling
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com> <49EC7C5F.2000006@redhat.com>
In-Reply-To: <49EC7C5F.2000006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/09 15:45, Avi Kivity wrote:

> Please elaborate. What hypercalls are so simple that an exit into the
> hypervisor is not necessary?

Ok, that becomes a longer story.  I try to keep it short though ...


xenner today (pure-pv only)
===========================

There is the xenner userspace application.  Handles start-of-day 
creation and the guest <=> host communication (well, not all of it, but 
these details are not relevant here).

There is emu.  Lives in guest address space, in the xen hypervisor 
address space hole.  Kida micro-kernel.  Handles all the hypercalls. 
Most stuff it can do internally, without leaving guest contect.  In a 
few cases it has to ask the xenner application for help.  That is the 
case for guest <-> host communication things, event channel setup for 
example.

xenner and emu talk to each other using an ioport based interface.


xenner future plans
===================

I want merge the userspace bits into qemu, so qemu can emulate xen 
guests (both tcg and kvm mode).

xenner application goes away.
emu will stay the same.
Likewise the ioport interface for emu.


xenner & pv-on-hvm
==================

Once we have all this in qemu it is just a small step to also support 
xenish pv-on-hvm drivers in qemu using the xenner emulation bits. 
Hypercalls are handled by a small pic binary loaded into the hypercall 
pages.  Loading of the binary is triggered by the msr writes discussed. 
Size of the binary is only two pages: one hypercall entry points, one 
code.  Communication path is the very same ioport interface also used by 
emu, i.e. it does *not* use vmcall and thus no opcode changes are needed 
on migration.

Hope the whole picture is more clear now ...

cheers,
   Gerd

PS: bitrotted (and IIRC also broken) code is here:
http://git.et.redhat.com/?p=qemu-kraxel.git;a=shortlog;h=refs/heads/xenner-old

Needs un-rotting once the first batch of xen patches is merged.
