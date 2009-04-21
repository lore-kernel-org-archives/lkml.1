Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZDURIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZDURIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZDURHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:07:53 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:40616 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZDURHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:07:53 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="157239377"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
	<adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>
	<20090420105304.GC6670@elte.hu>
	<a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>
	<20090420160332.GB9689@elte.hu>
	<a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
	<49EDE9E9.8090905@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 21 Apr 2009 10:07:50 -0700
In-Reply-To: <49EDE9E9.8090905@zytor.com> (H. Peter Anvin's message of "Tue,
	21 Apr 2009 08:44:41 -0700")
Message-ID: <adamyaavst5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2009 17:07:50.0516 (UTC) FILETIME=[B395B340:01C9C2A3]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Okay, I'm going to throw in yet another wrench in the machinery.

 > There are devices which really only want to use writeq() if it is an
 > inexpensive (no x86 MMX hacks) atomic operation.

Interesting example.  It does seem there are several reasonable hardware
design patters where a driver needs to know if writeq() and/or readq()
is atomic.

 > One way to deal with that is the <linux/io64*.h> method, another is with
 > feature test macros.

A further idea would be to add readq_atomic()/writeq_atomic() that
behave as the current 64-bit versions do: a single instruction,
generates a single bus cycle, etc.  Then drivers that really need to
use the full semantics that the 64-bit versions gave can use those,
while drivers that just want a convenient way to read a 64-bit register
can use readq()/writeq().

This only makes sense if we define a 32-bit fallback for
readq()/writeq() for all 32-bit architectures -- in fact it would be
good to do it in asm-generic so that there can be a single
implementation that guarantees that non-atomic versions always do, say,
low 32 bits then high 32 bits.  (So eg niu can use the generic version)
And then drivers like drivers/infiniband/hw/mthca can be switched to
"#ifndef writeq_atomic <...hardware specific fallback...>"

However I worry that this just leaves driver authors too much rope.
Choosing readq_atomic() vs. readq() is just one more thing to get wrong.

 - R.
