Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZCBIUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZCBIUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZCBIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:20:09 -0500
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:24986 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754468AbZCBIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:20:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mULt9kPoDd9OnIJsCwoxuLS4lxsnOokvgxip3ed6XgNX9L9Lv+PONu8o65SN3yF2ACtN2bWLP+kBEATXjx4HC7nqPiZqxp41ZAgF7ttFXvQ2pSiAmLnR5EbU2o6EIQIzYPm41vKkd3jrrRl5oBfluplKsfWOYuLujQuLwss2dws=  ;
X-YMail-OSG: Ayja_y4VM1m5xz2PcneGyuvcXtRsgR3uGwsy5.ve1ik9qEmuKGdD2Kvssv80.vVYoIvXGkXqzLZM6jD5YAE9YmCY46hc_boTsluDQ.IC4NG3KZgGkPbjeOFBTWobla9dcV9uiiyHhh_0sPZkqzXZH2LwYTMGFJJ1UtE2dhXAZWr_leEmcIjgo1wYV320MA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: core dom0 support
Date: Mon, 2 Mar 2009 19:19:29 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <200903021737.24903.nickpiggin@yahoo.com.au> <49AB9336.7010103@goop.org>
In-Reply-To: <49AB9336.7010103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021919.30068.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 19:05:10 Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > That would kind of seem like Xen has a better design to me, OTOH if it
> > needs this dom0 for most device drivers and things, then how much
> > difference is it really? Is KVM really disadvantaged by being a part of
> > the kernel?
>
> Well, you can lump everything together in dom0 if you want, and that is
> a common way to run a Xen system.  But there's no reason you can't
> disaggregate drivers into their own domains, each with the
> responsibility for a particular device or set of devices (or indeed, any
> other service you want provided).  Xen can use hardware features like
> VT-d to really enforce the partitioning so that the domains can't
> program their hardware to touch anything except what they're allowed to
> touch, so nothing is trusted beyond its actual area of responsibility.
> It also means that killing off and restarting a driver domain is a
> fairly lightweight and straightforward operation because the state is
> isolated and self-contained; guests using a device have to be able to
> deal with a disconnect/reconnect anyway (for migration), so it doesn't
> affect them much.  Part of the reason there's a lot of academic interest
> in Xen is because it has the architectural flexibility to try out lots
> of different configurations.
>
> I wouldn't say that KVM is necessarily disadvantaged by its design; its
> just a particular set of tradeoffs made up-front.  It loses Xen's
> flexibility, but the result is very familiar to Linux people.  A guest
> domain just looks like a qemu process that happens to run in a strange
> processor mode a lot of the time.  The qemu process provides virtual
> device access to its domain, and accesses the normal device drivers like
> any other usermode process would.  The domains are as isolated from each
> other as much as processes normally are, but they're all floating around
> in the same kernel; whether that provides enough isolation for whatever
> technical, billing, security, compliance/regulatory or other
> requirements you have is up to the user to judge.

Well what is the advantage of KVM? Just that it is integrated into
the kernel? Can we look at the argument the other way around and
ask why Xen can't replace KVM? (is it possible to make use of HW
memory virtualization in Xen?) The hypervisor is GPL, right?


> >  Would it be possible I wonder to make
> > a MMU virtualization layer for CPUs without support, using Xen's page
> > table protection methods, and have KVM use that? Or does that amount
> > to putting a significant amount of Xen hypervisor into the kernel..?
>
> At one point Avi was considering doing it, but I don't think he ever
> made any real effort in that direction.  KVM is pretty wedded to having
> hardware support anyway, so there's not much point in removing it in
> this one area.

Not removing it, but making it available as an alternative form of
"hardware supported" MMU virtualization. As you say if direct protected
page tables often are faster than existing HW solutoins anyway, then it
could be a win for KVM even on newer CPUs.


> The Xen technique gets its performance from collapsing a level of
> indirection, but that has a cost in terms of flexibility; the hypervisor
> can't do as much mucking around behind the guest's back (for example,
> the guest sees real hardware memory addresses in the form of mfns, so
> Xen can't move pages around, at least not without some form of explicit
> synchronisation).

Any problem can be solved by adding another level of indirection... :)

