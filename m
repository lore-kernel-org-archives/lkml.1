Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZDVF5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZDVF5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZDVF5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:57:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZDVF53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:57:29 -0400
Message-ID: <49EEB1BC.7020709@redhat.com>
Date: Wed, 22 Apr 2009 08:57:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws> <49EE25CB.6070709@redhat.com> <49EE27C2.3060505@codemonkey.ws> <49EE304D.5060108@redhat.com> <49EE3794.1070904@codemonkey.ws>
In-Reply-To: <49EE3794.1070904@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>>
>> Example: SMP.
>
> There was no KVM support in QEMU at the time when SMP was introduced.  
> Had there been, I see no reason not to do it in upstream QEMU.
>

Marcelo's been working on getting iothread (needed for smp) into qemu 
for a while.  It will take still more time.  All this with the previous 
implementation available.

In contrast, initial smp support was hacked into kvm-userspace in a few 
days.  Sure we didn't have an iothread (vcpu 0 did all the work) and it 
was horribly ugly and buggy, but we got the feature out for testing and 
got feedback, not only on the userspace bits, but also on the kernel 
bits which were new.

Going through qemu would have delayed the work significantly, as well as 
slowed down kernel development.

>> Example: vlan API.
>
> You'll have to be more specific.  Do you mean the up coming vlan API 
> refactoring?  That absolutely should be happening in upstream QEMU.

The refactoring, absolutely.  But if I have kernel support for zero copy 
tomorrow, do I wait until qemu completes refactoring the VLAN API, or do 
I hack something in so I can test it and get the benefit to users?

>>> As long as people are using kvm-userspace.git instead of qemu.git, 
>>> we're failing IMHO.  If kvm-userspace.git is basically the 
>>> equivalent of the x86 git kernel tree, linux-next, or something like 
>>> that, then that's a good thing.
>>
>> That's definitely a long term goal, but qemu is not yet at a point 
>> where it is easy to implement new features efficiently.  Once it 
>> reaches that state, kvm-userspace will become a simple staging ground 
>> (or even disappear entirely).
>
> The simple fact is that right now, Fedora ships kvm-userspace and 
> calls it QEMU.  It builds packages for non-KVM enabled boards.  There 
> is a very large userspace that consumes packages derived from 
> kvm-userspace.  Like it or not, kvm-userspace is not an experimental 
> staging ground for QEMU.

It depends on how fast qemu development is.  If everything took no time, 
sure, but that is not the case.

>
> The only reasonable things to do IMHO is for as much as humanly 
> possible to be deferred to QEMU or for you to comes to terms with your 
> role as a defacto QEMU maintainer and start pushing back more on patch 
> sets that don't take into consideration TCG/non-KVM environments :-)

I do that whenever possible -- and it most often is possible.

But neither kvm nor tcg are not going to be supersets of the other.  Of 
course qemu is not a subset of kvm as it has a much wider target/host 
variety.  But also kvm will always have features that tcg does not 
have.  For example AVX is easy to implement with a few lines in the 
kernel and qemu, but would take a massive effort in tcg.  It would have 
a large performance impact for AVX-enabled apps/guests/hosts 
combinations, not so much for tcg.

kvm wants features for large-scale production deployment.  This means 
focus on performance and managebility.  qemu/tcg is more for hobbyist 
use or as a developer tool for developing operating system kernels.  
This means more focus on ease of use.
>
> MCE is a perfect example of something that really has no reason to go 
> in via kvm-userspace since we have enough KVM support in upstream QEMU. 

I agree.  But the requirement that everything in kvm have a counterpart 
in tcg is not realistic.  The primary use of MCE for example is used to 
allow a guest to survive bad hardware.  I don't see this as being useful 
in any way on qemu/tcg.  A secondary is is to debug mce handling in 
guests OSes; now this is useful with tcg, but I'd hesitate to call it a 
requirement, it's more of a nice to have.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

