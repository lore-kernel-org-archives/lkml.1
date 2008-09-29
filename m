Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYI2V2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYI2V2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYI2V2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:28:38 -0400
Received: from gw.goop.org ([64.81.55.164]:52621 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYI2V2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:28:37 -0400
Message-ID: <48E1486C.3060306@goop.org>
Date: Mon, 29 Sep 2008 14:28:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       "akataria@vmware.com" <akataria@vmware.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1> <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com> <48E1437D.7080606@zytor.com>
In-Reply-To: <48E1437D.7080606@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Nakajima, Jun wrote:
>>
>> For example, we can set the following ranges so that so that each VMM
>> vender can define and implement features avoiding conflicts:
>> vmware to define 0x4000001X
>> xen to define 0x4000002X
>> kvm to define 0x4000003X
>> ...
>>
>
> Unless there is a central authority assigning these, "we" can do all
> we want, enough people will not pay attention.
>
> Basically, there needs to be a standards document that describes the
> architecture, *and* needs to either have universal buy-in with all the
> vendors or imposed by an authority with enough clout to do so (Intel
> might.)

I think using fixed offsets is unwise, since there's already contention
for the same leaves.  Making sure that each block of leaves (where a
block is 16, 256 or some other number of leaves) is self-describing via
ABI signatures is the only sane way to go.  There's still the issue of
assigning ABI signatures to vendors, but that's 1) less of an issue, and
2) can be self-assigned with very low likelihood of collision.  That way
a guest can scan that region of leaf space for ABI signatures it
understand, and can pick and choose among what it finds (but not mix and
match - that sounds like a course for disaster).

If we use such a scheme, we can 1) avoid any existing users of that
space, 2) cleanly delimit a hypervisor-agnostic ABI portion of the leaf
space, and 3) allow hypervisors to implement multiple ABIs at once.

    J
