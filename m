Return-Path: <linux-kernel-owner+w=401wt.eu-S965036AbXCFQ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbXCFQ1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965263AbXCFQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:27:43 -0500
Received: from gw.goop.org ([64.81.55.164]:57303 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965036AbXCFQ1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:27:42 -0500
Message-ID: <45ED9678.5050907@goop.org>
Date: Tue, 06 Mar 2007 08:27:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <20070306093436.GA30239@elte.hu> <45ED3F29.6000705@suse.de> <20070306102658.GA7478@elte.hu> <45ED4AD8.6020504@suse.de> <20070306115937.GA25313@elte.hu>
In-Reply-To: <20070306115937.GA25313@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> legacy support has to be ensured, but it does not hugely matter in terms 
> of the designing our future. What matters is that once we change some 
> fundamental aspect of Linux, we can adopt lguest/KVM immediately. With 
> 'external' hypervisors there is no such compulsory forward motion, and 
> my fear is that by giving them ABI interfaces to the innards of the 
> Linux guest they will just stick with those ABIs - and worse, drag Linux 
> along with them. (because distros will be forced by the legacy 
> assumptions to carry those ABIs along.)
>   

So what's your argument here?  That if Xen/ESX/whatever are evolved
separately from Linux, then they should be tied together behind one ABI,
so that even if one could support a new Linux feature it can't move
until everyone else implementing the ABI too?  How does that help anyone?

The big practical difficulty is that there are no examples of an ABI
with multiple implementations all being sufficiently cross-compatible
that a user of that ABI can actually rely on it working consistently
(and certainly not to the extent that it actually reduces the test
matrix size).  There are masses of subtle details that are hard to get
right, and making sure that multiple implementations get all this right
is apparently impossible (otherwise ACPI would be a dream to work with...).

> lguest/KVM is fundamentally special because its future evolution is 
> naturally aligned with that of Linux.

lguest is special, because it is purely kernel-internal (and because
Rusty wrote it, of course).  kvm is not, and I don't see why you think
it is.  In its simplest form its a thin layer which exposes hardware
virtualization to usermode, which happens to be qemu at the moment.  Its
evolving some bells and whistles, but at heart it's being developed by a
company with just as much commercial interest and backing as Xen and
VMI, and it has the scope to be just as cross-platform.

>  Sure, legacies will have to be 
> taken care of (just like Linux supports old system-calls and even old 
> driver APIs in some circumstances), but there is no danger of KVM 
> staying in legacy land forever.

Sure there is.  It needs the usermode part to keep sync; that's easy if
its qemu, but you're stuck if its a proprietary usermode implementing
that end of the kvm equation.

>  With Xen and VMWare i see no guarantee 
> at all that Linux wont be hindered by their legacies (or by any plain 
> diverging approaches) forever.
>   

Well, if the kernel goes one way and Xen doesn't follow, then that
pretty severely restricts Xen's usefulness - there's a pretty strong
incentive for Xen to keep supporting Linux.  And besides, Xen is all
GPL, so anyone who's sufficiently motivated can do this work.

> so for example, if we change some fundamental thing that can be 
> implemented via the legacy ABI but only slowly, that's not a problem 
> because new-lguest/new-KVM will use the new approach, so there's a 
> straightforward technology-based migratory path out of the legacy. But 
> if Xen or VMWare were to stick with that legacy ABI forever (for 
> whatever reason), we couldnt solve that situation on the Linux side at 
> all, via technological measures.
>   

Well, that's the reason for minimizing Linux's exposure to any ABI. 
Clearly the interface to a hypervisor has to be *some* ABI.  But it
doesn't help anyone if there's an extra uber-ABI which is a superset of
all the underlying hypervisor ABIs; that's just a big rigid, brittle mess.

The whole point of pv_ops is to allow the hypervisors interfaces to
evolve at their own pace without having to constrain the core kernel's
development

> yes - although obviously a KVM Linux guest does not need such an 
> interface - but it's a nice proof of concept to integrate other guest 
> OSs into KVM.
>   

Well, if there were any other guests that used VMI that might be
useful.  You'd get further using the Xen ABI.


    J
