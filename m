Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYHDQjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYHDQjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYHDQjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:39:15 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14944 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYHDQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:39:14 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Dave Jones <davej@redhat.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080804162657.GI11476@duo.random>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl> <ada63qgvppx.fsf@cisco.com>
	 <1217859571.3589.7.camel@twins> <aday73cua99.fsf@cisco.com>
	 <1217860332.3589.11.camel@twins> <20080804145318.GA17867@redhat.com>
	 <1217861763.3589.13.camel@twins>  <20080804162657.GI11476@duo.random>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 18:38:55 +0200
Message-Id: <1217867935.3589.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 18:26 +0200, Andrea Arcangeli wrote:
> On Mon, Aug 04, 2008 at 04:56:03PM +0200, Peter Zijlstra wrote:
> > My guess is that the kvm thing attaches before there are any vma, and
> > leaves after all the vma are gone. So it would never actually trigger.
> 
> Yes, lockdep seems to be fine with kvm in kernel mainline in my
> current and past testing. Andrew asked me to check this long ago.
> 
> vmx ~ # zgrep LOCKDEP /proc/config.gz 
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_LOCKDEP=y
> CONFIG_DEBUG_LOCKDEP=y

You also need CONFIG_PROVE_LOCKING, but I'll assume that's set too.

> CPA self-test:
>  4k 26112 large 1997 gb 0 x 2652[ffff880000000000-ffff8800bffff000]
>  miss 262144
>  4k 186880 large 1683 gb 0 x 43021[ffff880000000000-ffff8800bffff000]
>  miss 262144
>  4k 186880 large 1683 gb 0 x 43021[ffff880000000000-ffff8800bffff000]
>  miss 262144
> ok.
> loaded kvm module ()
> apic write: bad size=1 fee00030
> Ignoring de-assert INIT to vcpu 0
> Ignoring de-assert INIT to vcpu 0
> kvm: emulating exchange as write
> apic write: bad size=1 fee00030
> Ignoring de-assert INIT to vcpu 0
> Ignoring de-assert INIT to vcpu 0
> apic write: bad size=1 fee00030
> Ignoring de-assert INIT to vcpu 0
> Ignoring de-assert INIT to vcpu 0
> apic write: bad size=1 fee00030
> Ignoring de-assert INIT to vcpu 0
> apic write: bad size=1 fee00030
> Ignoring de-assert INIT to vcpu 0
> apic write: bad size=1 fee00030
> Ignoring de-assert INIT to vcpu 0
> Ignoring de-assert INIT to vcpu 0
> Ignoring de-assert INIT to vcpu 0
> 
> I can't see lockdep errors in dmesg starting one more multiple VM in a
> loop (all run on a quadcore).

Dave Jones just handed me:

  https://bugzilla.redhat.com/show_bug.cgi?id=457779


> GRU is likely the same.
> 
> The only real place where lockdep is unusable in my experience is
> preempt-RT, it grinds it to an halt during boot on 8-way before
> reaching the shell.

David Miller just did a patch that might fix that.

