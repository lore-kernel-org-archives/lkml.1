Return-Path: <linux-kernel-owner+w=401wt.eu-S1767592AbXCIWwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767592AbXCIWwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767591AbXCIWwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:52:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767592AbXCIWwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:52:05 -0500
Date: Fri, 9 Mar 2007 23:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309225027.GA28180@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org> <20070309213607.GA16796@elte.hu> <Pine.LNX.4.64.0703091423570.10832@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091423570.10832@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > but ... maybe because VMI is so lowlevel and covers /all/ of x86 
> > today, it will always be able to emulate whatever different concept 
> > we can come up with? Do we really know this absolutely sure?
> 
> "For sure"? Absolutely not. But since any new interfaces we come up 
> with for doing timers etc had better work perfectly fine on an old 
> hardware platform too, we can't exactly require any interfaces that do 
> things that a bog-standard old dual-PPro didn't do 10 years ago, can 
> we?

i'm not really thinking in terms of extending the native kernel - 
whatever we do on the native kernel we'll indeed have to be able to do 
on 'real' hardware too - including really old boxes.

i'm thinking more in terms of having some new and more intelligent 
virtualization-only abstractions.

For example i think people are way too obsessed with building virtual 
'machines' that look like PCs, while i've got some truly pie-in-the-sky 
ideas floating to simplify virtual machines, like the one i just 
outlined to Chris:

|| long-term i'd like to have a paravirt model where the guest does not 
|| store /any/ page tables - all paging is managed by the hypervisor. 
|| The guest has a vma tree, but otherwise it does not process 
|| pagefaults, has no concept of a pte (if in paravirt mode), has no 
|| concept of kernel page tables either: there are hypercalls to 
|| allocate/free guest-kernel memory, etc. This needs some (serious) MM 
|| surgery but it's doable and it's interesting as well. How would you 
|| map this to the VMI backend?

Clearly the ugliest and most complex part of hypervisors is MMU support. 
So the above model would avoid all the shadow page table complexities 
and other MMU nasties, and keep that stuff in the hypervisor. [ in 
exchange for a whole set of other complexities and problems ;-) ] This 
would be even more highlevel than UML (UML emulates pagetables in 
user-space), in that regard.

even in such a drastic model we could share like 90% of the x86 binary 
code with the rest of the kernel (all the filesystem support, networking 
stack, etc. would still be reusable by the guest kernel), so a paravirt 
approach, where native and guest is the same image (as opposed to the 
UML model, where they are separate) still makes sense and is preferred 
by distributions.

Mapping this into VMI calls looks ... near impossible to me. VMI really 
assumes that there is no hypervisor state for kernel objects - while the 
above model _shares_ a very substantial kernel object with the 
hypervisor - and in fact 100% delegates its handling to the hypervisor 
altogether. Hm?

	Ingo
