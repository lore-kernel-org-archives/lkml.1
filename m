Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYJHAkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYJHAkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJHAkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:40:19 -0400
Received: from gw.goop.org ([64.81.55.164]:37433 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYJHAkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:40:18 -0400
Message-ID: <48EC016E.4040708@goop.org>
Date: Tue, 07 Oct 2008 17:40:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       "akataria@vmware.com" <akataria@vmware.com>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1> <48E3FDD5.7040106@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com> <48E422CA.2010606@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com> <48E6AB15.8060405@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com> <48E6BA5B.2090804@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DE4F934@orsmsx505.amr.corp.intel.com> <48EBF396.8000502@goop.org> <48EBF49E.9030803@zytor.com>
In-Reply-To: <48EBF49E.9030803@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>>
>>> The big difference here is that you could create a VM at runtime (by 
>>> combining the existing interfaces) that did not exist before (or was 
>>> not tested before). For example, a hypervisor could show hyper-v, 
>>> osx-v (if any), linux-v, etc., and a guest could create a VM with 
>>> hyper-v MMU, osx-v interrupt handling, Linux-v timer, etc. And such 
>>> combinations/variations can grow exponentially.
>>
>> That would be crazy.
>>
>
> Not necessarily, although the example above is extreme.  Redundant 
> interfaces is the norm in an evolving platform.

Sure.  A common feature across all hypervisor-specific ABIs may get 
subsumed into a generic interface which is equivalent to all the 
others.  That's fine.  But nobody should expect to be able to mix 
hyperV's lazy tlb interface with KVM's pv mmu updates and expect to get 
a working result.

>>> Or are you suggesting that multiple interfaces be _available_ to 
>>> guests at runtime but the guest chooses one of them?
>>
>> Right, that's what I've been suggesting.    I think hypervisors 
>> should be able to offer multiple ABIs to guests, but a guest has to 
>> commit to using one exclusively (ie, once they start to use one then 
>> the others turn themselves off, kill the domain, etc).
>
> Not inherently.  Of course, there may be interfaces which are 
> interently or by policy mutually exclusive, but a hypervisor should 
> only export the interfaces it wants a guest to be able to use.

It should export any interface that it implements fully, but those 
interfaces may have contradictory or inconsistent semantics which 
prevent them from being used concurrently.

> This is particularly so with CPUID, which is a *data export* 
> interface, it doesn't perform any action. 

Well, sure.  There's two distinct issues:

   1. Using cpuid to get information about the kernel's environment.  If
      the environment is sane, then cpuid is a read-only, side-effect
      free way of getting information, and any information gathered is
      fair game.
   2. One of the pieces of information you can get with cpuid is a
      discovery of what paravirtual hypercall interfaces the environment
      supports, which the guest can compare against its list of
      interfaces that it supports.  If there's some amount of
      intersection, it can decide to use one of those interfaces.

I'm saying that *in general* a guest should expect to be able to use one 
and only one of those interfaces.  There will be explicitly defined 
exceptions to that - such as using generic ABIs in addition to 
hypervisor specific ABIs - but a guest can't expect to to be able to mix 
and match.

A tricky issue with selecting an ABI is if two hypervisors end up using 
exactly the same mechanism for implementing hypercalls (or whatever), so 
that there needs to be some explicit way for the guest to nominate which 
interface its actually using...

    J
