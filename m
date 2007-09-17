Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbXIQTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbXIQTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXIQTPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:15:35 -0400
Received: from gw.goop.org ([64.81.55.164]:35124 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbXIQTPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:15:34 -0400
Message-ID: <46EED256.40801@goop.org>
Date: Mon, 17 Sep 2007 12:15:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com> <46EB6556.5020506@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379EDA0@scsmsx412.amr.corp.intel.com> <46EC233B.5010209@us.ibm.com> <97D612E30E1F88419025B06CB4CF1BE1037F83EC@scsmsx412.amr.corp.intel.com> <46EEC6FE.5060306@us.ibm.com>
In-Reply-To: <46EEC6FE.5060306@us.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Nakajima, Jun wrote:
>>> I don't understand the purpose of returning the max leaf.  Who is that
>>> information useful for?
>>>     
>>
>> Well, this is the key info to the user of CPUID. It tells which leaves
>> are valid to use. Otherwise, the user cannot tell whether the results of
>> CPUID.0x4000000N are valid or not (i.e. junk). BTW, this is what we are
>> doing on the native (for the leaf 0, 0x80000000, for example). The fact
>> that Xen returns 0x40000002 means it only uses 3 leaves today.   
>
> Then it's just a version ID.  You pretty much have to treat it as a
> version id because if it returns 0x4000 0003 and you only know what
> 0002 is, then you can't actually use it.

Yeah.  It's the way all the other cpuid leaf/level stuff works, so it's
reasonable to do the same thing here.  The question it helps answer is
"I understand leaf 33, does the [v]CPU?".

> I much prefer the current use of CPUID in KVM.  If 1000 returns the
> KVM signature, then 1001 *must* be valid and contain a set of feature
> bits.  If we wish to use additional CPUID leaves in the future, then
> we can just use a feature bit.  The real benefit to us is that we can
> use a discontiguous set of leaves whereas the Xen approach is forced
> to use a linear set (at least for the result to be meaningful).

Well, its also what the CPU itself does.  The feature bits tend to
relate to specific CPU features rather than CPUID instruction leaves. 
The features themselves may also have corresponding leaves, but that's
secondary.  IOW, if feature bit X is set, it may use leaf 0x4000101f,
but that doesn't mean leaves 0x40001001-1f are necessarily defined.

> I'm starting to lean toward just using 0000.  If for no other reason
> than the hypercall space is unsharable.

Well, it could be, but it would take affirmative action on the guest's
part.  If there's feature bits for each supported hypercall interface,
then you could have a magic MSR to select which interface you want to
use now.  That would allow a generic-interface-using guest to probe for
the generic interface at cpuid leaf 0x40001000, use 40001001 to
determine whether the hypercall interface is available, 4000100x to find
the base of the magic msrs, and write appropriate msr to set the desired
hypercall style (and all this can be done without using vmcall, so it
doesn't matter that hypercall interface is initially established).

    J
