Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbYJaQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbYJaQAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYJaQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:00:43 -0400
Received: from vena.lwn.net ([206.168.112.25]:32944 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYJaQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:00:42 -0400
Date: Fri, 31 Oct 2008 10:00:40 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
Message-ID: <20081031100040.1f0cf34f@bike.lwn.net>
In-Reply-To: <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	<490A5532.2000704@shaw.ca>
	<20081030205851.3208f52f@bike.lwn.net>
	<86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
	<alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
	<alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 08:44:52 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Jonathan, what do things look like with the simple "use
> > 'expand_to_fit'" patch instead, ie something like this:  
> 
> And by "something like this", I obviously _really_ meant "something 
> almost, but not entirely, unlike this".

I was just figuring that part out :)

Things change a bit with this patch, but the e1000e still fails to
initialize:

[    9.301890] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    9.301894] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    9.301952] e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    9.301959] e1000e 0000:00:19.0: BAR 0: can't reserve mem region [0xfe9e0000-0xfe9fffff]
[    9.301966] e1000e 0000:00:19.0: PCI INT A disabled
[    9.301972] e1000e: probe of 0000:00:19.0 failed with error -16

Pretty much the same as before.  The I/O memory layout *has* changed a
bit, though:

00000000-0009fbff : System RAM
000f0000-000fffff : reserved
00100000-be4ff7ff : System RAM
  00200000-004a6e45 : Kernel code
  004a6e46-00649b77 : Kernel data
  006c4000-007585ff : Kernel bss
be4ff800-be553bff : ACPI Non-volatile Storage
be553c00-be555bff : ACPI Tables
be555c00-beffffff : reserved
c0000000-cfffffff : 0000:00:02.0
d0000000-d3ffffff : PCI Bus 0000:02
  d0000000-d3ffffff : 0000:02:00.0
    d0000000-d07fffff : ivtv encoder
    d2000000-d200ffff : ivtv registers
d4000000-d4000fff : Intel Flush Page
e0000000-fed003ff : reserved
  fe800000-fe8fffff : PCI Bus 0000:01
  fe9d9b00-fe9d9bff : 0000:00:1f.3
  fe9d9c00-fe9d9fff : 0000:00:1a.7
  fe9da000-fe9dafff : 0000:00:03.3
  fe9db000-fe9dbfff : 0000:00:19.0
  fe9dc000-fe9dffff : 0000:00:1b.0
  fe9e0000-fe9fffff : 0000:00:19.0
  fea00000-fea7ffff : 0000:00:02.0
  fea80000-feafffff : 0000:00:02.1
  feb00000-febfffff : 0000:00:02.0
  fec00000-fec00fff : IOAPIC 0
  fed00000-fed003ff : HPET 0
fed20000-fed9ffff : reserved
fedad000-fedad00f : 0000:00:03.0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
ff980800-ff980bff : 0000:00:1d.7
  ff980800-ff980bff : ehci_hcd
ffb00000-ffffffff : reserved

The e1000e iomem is seen as such (fe9db000-fe9dbfff : 0000:00:19.0),
but it's still under the "reserved" umbrella, and that seems to give it
grief.

jon
