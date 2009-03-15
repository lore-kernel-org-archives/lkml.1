Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZCOVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZCOVDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbZCOVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:03:14 -0400
Received: from gw.goop.org ([64.81.55.164]:50540 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbZCOVDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:03:13 -0400
Message-ID: <49BD6D0E.1010107@goop.org>
Date: Sun, 15 Mar 2009 14:03:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-11-git-send-email-jeremy@goop.org> <49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org> <49BD4CE1.6040100@zytor.com>
In-Reply-To: <49BD4CE1.6040100@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Jan Beulich wrote:
>>     
>>> As pointed out on an earlier thread, it seems inappropriate to do probing
>>> like this when there is a cpuid feature flag (osxsave) that can be
>>> used to
>>> determine whether XSAVE can be used. And even without that flag,
>>> simply reading CR4 and checking whether osxsave is set there would
>>> suffice. This is under the assumption that Xen's to-be-done
>>> implementation
>>> of XSAVE support would match that of FXSAVE (Xen turns its support on
>>> unconditionally and for all [pv] guests).
>>>       
>> I didn't want to make too many assumptions about how Xen's XSAVE support
>> would look.  In particular, I thought it might virtualize the state of
>> OSXSAVE to give the guest the honour of appearing to enable it.  A guest
>> kernel may get confused if it starts with OSXSAVE set, as it may use it
>> to control its own init logic.
>>     
>
> That wouldn't be an issue if you use the *native* CPUID to look for
> OSXSAVE early on, since such virtualization would only be visible though
> the PV interface, right?
>
> It seems cleaner than probing, to be sure...
>   

Well, at the moment the problem is that cpuid (both PV and native) show 
XSAVE, but Xen prevents cr4.OSXSAVE from being set, crashing the 
kernel.  There's now a patch in Xen to mask XSAVE in CPUID, so that 
guests don't try to use it; the patch in the kernel is just to support 
non-bleeding-edge versions of Xen.

There have been some patches floating around for Xen support of XSAVE, 
but I think there are some issues with the variable-sized CPU context 
and save/restore/migrate, so they've been put on the backburner until 
there's a real need for them.  I haven't looked at them, but I wouldn't 
have assumed that Xen would necessarily set OSXSAVE for itself, or 
require guests to do so (if a guest can make do with a simpler CPU 
context structure, then that might be simpler for things like 
cross-architecture migration, etc).  I think that the only safe 
assumption is that XSAVE is available iff cpuid.XSAVE is set, modulo the 
bug mentioned above.

I guess if we support XSAVE for any vcpu, all the pcpus must have 
OSXSAVE set, and we rely on the fact that the XSAVE format is compatible 
with FXSAVE where they overlap.  But I really don't know what happens 
when guests use xsetbv and how that might be virtualized/paravirtualized.

    J
