Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXIOSYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXIOSYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXIOSX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:23:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47477 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXIOSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:23:58 -0400
Message-ID: <46EC233B.5010209@us.ibm.com>
Date: Sat, 15 Sep 2007 13:23:55 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com> <46EB6556.5020506@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com>
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Nakajima, Jun wrote:
>>     
>>> The hypervisor detection machanism is generic, and the signature
>>> returned is implentation specific. Having a list of all hypervisor
>>> signatures sounds fine to me as we are detecting vendor-specific
>>> processor(s) in the native. And I don't expect the list is large.
>>>
>>>
>>>       
>> I'm confused about what you're proposing.  I was thinking that a
>>     
> kernel
>   
>> looking for the generic hypervisor interface would check for a
>>     
> specific
>   
>> signature at some cpuid leaf, and then go about using it from there.
>>     
> If
>   
>> not, how does is it supposed to detect the generic hypervisor
>>     
> interface?
>   
>>     J
>>     
>
> I'm suggesting that we use CPUID.0x4000000Y (Y: TBD, e.g. 6) for Linux
> paravirtualization.  The ebx, ecx and edx return the Linux
> paravirtualization features available on that hypervisor. Those features
> are defined architecturally (not VMM specific).
>
> Like CPUID.0, CPUID.0x40000000 is used to detect the hypervisor with the
> vendor identification string returned in ebx, edx, and ecx (as we are
> doing in Xen). The eax returns the max leaf (which is 0x40000002 on Xen
> today).

I don't understand the purpose of returning the max leaf.  Who is that 
information useful for?

I like Jeremy's suggesting of starting with 0x40001000 for KVM.  Xen has 
an established hypercall interface and that isn't going to change.  
However, in the future, if other Operating Systems (like the BSDs) 
choose to implement the KVM paravirtualization interface, then that 
leaves open the possibility for Xen to also support this interface to 
get good performance for those OSes.  It's necessary to be able to 
support both at once if you wish to support these interfaces without 
user interaction.

There's no tangible benefit to us to use 0x40000000.  Therefore I'm 
inclined to lean toward making things easier for others.

Regards,

Anthony Liguori

>  And like CPUID.1, CPUID.0x40000001 returns the version number in
> eax, and each VMM should be able to define a number of VMM-specific
> features available in ebx, ecx, and edx returned (which are reserved,
> i.e. not used in Xen today). 
>
> Suppose we knew (i.e. tested) Xen and KVM supported Linux
> paravirtualization, the Linux code does:
> 1. detect Xen or KVM <the list> using CPUID.0x40000000 
> 2. Check the version if necessary using CPUID.0x40000001
> 3. Check the Linux paravirtualization features available using
> CPUID.0x4000000Y.
>
> Jun
> ---
> Intel Open Source Technology Center
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>   

