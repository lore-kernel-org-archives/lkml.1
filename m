Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYI0BdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYI0BdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 21:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYI0BdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 21:33:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40781 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYI0BdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 21:33:08 -0400
Message-ID: <48DD8C4E.1030103@zytor.com>
Date: Fri, 26 Sep 2008 18:28:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com,
       Tim Deegan <Tim.Deegan@citrix.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1> <48DD860C.50809@goop.org>
In-Reply-To: <48DD860C.50809@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> I'm sympathetic to the idea, but it seems a bit under-defined.
> 
> Are you leaving a gap between 0x40000000 and -10 for what?  Future
> extension?  Avoiding existing hypervisor-specific leaves?
> 
> I think there's a move towards doing a scan for a signature, such as
> checking every 16 leaves after 0x40000000 for "a while" looking for
> interesting signatures, so that a hypervisor can support multiple ABIs
> at once.  Given this, it would be better to define a "Generic Hypervisor
> ABI" signature, and put all the related leaves together.
> 

That's kind of iffy, although at least it does have a modicum of being 
controlled.

There is already a de facto standard for doing this: on a (currently) 
64K boundary, add a leaf with a vendor ID and a limit; the presence is 
detectable by the limit in EAX having the proper upper bits.

Then have each vendor pick a range that they maintain.  Intel uses 
0x0000xxxx (although they claim control of the entire numberspace), AMD 
uses 0x8000xxxx, VIA uses 0xC000xxxx, Transmeta used 0x8086xxxx, and 
0x4000xxxx is being reserved for "virtualization".  There are tools 
which use this as a way to try to dump all of CPUID without knowing details.

See the problem here?  This is in effect an unmanaged space.  This means 
that without the vendor ID it is going to be meaningless, unless at 
least the major players in the virtualization industry could agree with 
how to use it, and that would still leave other users out in the cold.

Now, that would still require a vendor numberspace registry.  The 
obvious one is to use the numbers issued by PCI-SIG, which would require 
16 bits -- that would presumably mean numbers of the form 0x40SSSSxx 
with SSSS being the vendor ID; this would require scanning on a 256-byte 
granularity for a generic tool.

Overall, though, *any* generic solution requires buyin from all 
significant players in the space, *AND* a way to distinguish 
noncompliant implementations.  Designing a functional solution is the 
easy part of that[*].  Getting sufficient buyin in the hard part.

> And then, rather than having a simple "maximum leaf", it would be better
> to have cap bits for each specific feature.  For example, how would the
> "RESERVED" registers in "Timing information" ever get used?  How would
> you know that they were no longer reserved, but now meaningful?

Typically you'd define them to be zero unless usable, and define them so 
that a meaningful value would be nonzero.

> That said, I'm a bit worried about the whole idea of having these kinds
> of timing parameters.  It does assume that they're constant for the
> whole life of the VM.  What if they change due to power management or
> migration?

Presumably you'd have to have some way to notify the VM, via an 
interrupt of some sort.

	-hpa

[*] Consider the following totally half-baked example:

CPUID leaf 0x40000000
	ECX-EDX-EBX	Vendor name
	EAX		Max CPUID level supported

	Motivation: existing practice

CPUID leaf 0x40000001...
	EAX		leaf number	Pointer
	ECX		DID:VID		PCI-style
	EDX		0xcc06ab0b	Magic number
	EBX		0x7ab3857a	Magic number

	This would use the PCI vendor ID and an arbitrary "device ID"
	to point to a leaf number, which would then contain information
	starting with an identification/count leaf.  The DID:VID would
	signal who defined the specification, not necessarily who wrote
	the hypervisor.  This is similar to how Intel uses AMD-defined
	CPUID levels, for example.

	-hpa
