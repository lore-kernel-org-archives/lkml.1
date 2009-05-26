Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZEZMqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZEZMqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZEZMqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:46:42 -0400
Received: from mail-pz0-f109.google.com ([209.85.222.109]:57757 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZEZMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MAitAe3l2TDtB8QtSy5L5RVGSf2ha9j5mUEE4/08i7hTLzOWTKtZYtQpg26dPBROfN
         zIejOEoH91srizOTNfNsFTe29QWsOWZvMOXQhE8nECoY7rDeF0FSEfNVJ972J0CK843V
         PZP6JictfT1CgCBvWV4re6UhP9TIvSxFqDeGY=
MIME-Version: 1.0
In-Reply-To: <20090525041057.GD9396@elte.hu>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
	 <20090519123548.GA26439@elte.hu> <4A14447E.9060607@goop.org>
	 <20090525041057.GD9396@elte.hu>
Date: Tue, 26 May 2009 13:46:40 +0100
X-Google-Sender-Auth: cadde723f7a79da5
Message-ID: <de76405a0905260546k56bc866bx1658ec13f65e3eec@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 5:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Note that this design problem has been created by Xen,
> intentionally, and Xen is now suffering under those bad technical
> choices made years ago. It's not Linux's problem.

I'd like to respecfully disagree with this.  I think I can see your
point of view: you're being asked to make changes to accommodate a
project you're not involved in, and whose fundamental design you
disagree with.  And no one disagrees with the stance that changes to
accomodate Xen must not impact native performance.  But I think the
current design (with dom0 running linux-as-hypervisor-component) is
the best one, and it's one we would make over again if we had to start
from scratch.

Basically, there are three ways to approach the hypervisor problem wrt Linux:
1. Make Linux into a hypervisor (linux-as-hypervisor). This is the KVM approach.
2. Fork Linux, stealing all the device drivers, and making a
monolithic hypervisor.
3. Make a small, lean hypervisor, but leverage Linux to run the
devices and control stack (linux-as-hypervisor-component).

I've worked a bit at both kernel and hypervisor level (although
admittedly much more in-depth at the hypervisor level).  It seems to
me that being a hypervisor is a much different thing than being a
kernel.  I don't believe that one piece of software can do both well.
And I believe that, when it begins to mature more, KVM will run into
the very same issue.  KVM developers will really want to start to make
the kernel into a hypervisor, and there will be a disagreement between
those who want the kernel to be just a kernel, and those who want the
kernel also to be a hypervisor.  The result will be either a heavily
modified Linux (much more than linux-as-hypervisor-component) or a
really sucky hypervisor.

As a simple example, take scheduling.  I'm about to re-write the Xen
scheduler, and in the process I took a good look at the scheduler you
wrote.  I think it's got a lot of really good ideas, which I plan to
steal. :-)  However, I'm going to have to make some key changes in
order for it to function well as a hypervisor scheduler.  If KVM is
used on a production server with 20 or 30 multi-vcpu VMs, I predict
the current scheduler will do very poorly, because it wasn't designed
with VMs in mind, but with processes.  Making changes so that VMs run
better will fundamentally make things that make processes run less
well.

Forking Linux, drivers an all, is not a good idea; anyone would have
to be a fool to try it.  I think if you think seriously about it,
you'd never do something like that.  I don't believe any such a
project would have a snowball's chance in hell of attracting anywhere
near the required number of hardware developers to make it an
enterprise-class system.  If, somehow, it did manage to attract a
critical mass to make it viable, then the result would be two much
weaker projects, wasting millions of man-hours of  labor doing
unnecessary duplication.

No, I think the best option, and the option the Xen project would take
again if we were to start from scratch, would be what we have done:
To build a hypervisor to be a hypervisor, and let the kernel be a
kernel: but leverage the millions of man-hours still being done in
hardware support for Linux.

Either way, time will tell in the end.  If I'm wrong, and KVM can
become an enterprise-class hypervisor while playing well with
linux-as-kernel, then eventually it will dominate and Xen will die
out.  You can say "I told you so" and remove all the crap you've been
objecting to.  If I'm right, however, then having Xen around will be
critical, not just for open-source virtualization, but for the kernel
as well.  You'll be happy to be able to tell people, "Don't put this
hypervisor crap in here.  If you want a hypervisor, go to Xen." :-)

Until things are shown clearly one way or the other, the best thing to
do is hedge your bets, and allow both projects to develop.

[That's my main point; in-line responses below.]

> The whole Xen design is messed up really: you have taken off bits of
> the Linux kernel you found interesting, turned them into a
> micro-kernel in essence and renamed it to 'Xen'.

That's how Xen started, and that's really the beauty of open-source.
(After all, KVM has stolen some ideas from the Xen shadow code.)  But
since then, basically all of the code has been replaced with
Xen-written code.  I think if you did an SCO-style audit comparing
Linux and Xen 3.4, you'd find a lot less in common than you think.

> But drivers and proper architecture is apparently boring (and
> fragile and hard and expensive to write and support in a
> micro-kernel setup) so you came up with this DOM0 piece of cr*p that
> ties Linux to Xen even closer (along an _ABI_), where Linux does
> most of the real work while Xen still stays 'separate' on paper.

It's not boring, it's just a colossal waste of time and resources to
duplicate all that effort.  "Real work" is done by all of the
components: Xen does the "real work" of scheduling and resource
management; Linux does the "real work" of process-level stuff,
filesystems, and so on and (in the case of dom0) hardware support;
qemu does the "real work" of doing device emulation.  All of them are
unique, difficult, and interesting to somebody.  Reducing duplication
means everyone can work on what interests them the most, and minimizes
the total "busy work" for all involved.

How many KVM developers are working on device drivers?  And how would
Xen duplicating all the driver development help Linux?  Linux would
still have to do everything, there'd just be fewer developers to do it
(since some people would be working on Xen drivers instead).

> Xen isnt actually useful _at all_ without Linux/DOM0. Without Dom0
> Xen is slow and native hardware support within Xen is virtually
> non-existent, as you point out above.

And qemu-kvm isn't useful _at_all_ without Linux either; and Linux-KVM
isn't useful _at_all_ without qemu.  Your point?

Xen will run without dom0?  I wasn't aware of that... ;-)

> This is proof that you should have done all that work within Linux -
> instead of duplicating a lot of code.

See above.

 -George Dunlap
