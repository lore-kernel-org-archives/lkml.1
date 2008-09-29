Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYI2SrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYI2SrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYI2Sq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:46:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43368 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYI2Sq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:46:57 -0400
Message-ID: <48E1227B.9040809@redhat.com>
Date: Mon, 29 Sep 2008 20:46:19 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
In-Reply-To: <1222710924.30247.21.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi Gerd,
> 
>> Shouldn't you check the hypervisor signature here?
> 
> Nope the whole idea of not checking the hypervisor signature is that we
> should keep this interface generic. 

Nice idea.  Problem with that is that approach is that we don't have
full control here.  It probably isn't that a hard to have vmware, xen
and kvm agree here, given vmware proposes this and for xen+kvm one can
send patches.  But even that you can't take for granted, see the
discussion of the "tsc-may-change-on-migration" problem.

The real big problem are other closed-source hypervisors (VirtualPC /
Hyper-V / Parallels / ...).  How can we be sure they don't define that
leaf to something different?

> Also one thing to remember is, that a hypervisor can decide to not
> implement this level and just return "0" the kernel can then just ignore
> that value. That's what we do currently in native_calibrate_tsc.

The fudamental issue outlined above aside:  Even the "ignore 0" part
isn't in the patch right now.

>> Right now both kvm and xen use the first one or two leafes (after info),
>> but in incompatible ways, so for these the signature *must* be checked
>> before using the info found there.
> 
> Hmm that's unfortunate, but we can have exceptions for these one of
> cases and AFAIK these are only checked in the kvm/xen code path and not
> in any generic code as of now, right ? 

Yes.

> btw, i could only find the semantics for 0x40000001 leaf in KVM's header
> file but don't see Xen using that leaf, can you please point me which
> leafs are you referring to here. 

pv drivers in hvm guests use that (and query very xen-specific stuff
which wouldn't make much sense in other hypervisors).  It isn't in the
kernel source tree, look here instead:

http://xenbits.xensource.com/xen-3.3-testing.hg?file/19201eebab16/unmodified_drivers/linux-2.6/platform-pci/platform-pci.c

cheers,
  Gerd


