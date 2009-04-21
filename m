Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZDUPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZDUPpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZDUPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:45:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZDUPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:45:24 -0400
Message-ID: <49EDE9E9.8090905@zytor.com>
Date: Tue, 21 Apr 2009 08:44:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>	 <adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>	 <adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>	 <20090420105304.GC6670@elte.hu>	 <a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>	 <20090420160332.GB9689@elte.hu> <a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
In-Reply-To: <a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> I suggest 2) (or 3)).
> Because there's no problem since ported readq/writeq on x86_32.
> And as H. Peter Anvin mentioned non-atomic is generally fine.

Okay, I'm going to throw in yet another wrench in the machinery.

There are devices which really only want to use writeq() if it is an
inexpensive (no x86 MMX hacks) atomic operation.

What follows is *NOT* a hypothetical example, I worked on a real device
which behaved this way:

Consider a device with a set of control registers in device memory.  You
can issue a whole command sequence at one point, but the command isn't
activated until a write is received with a certain bit set (located in
the high half of the last qword.)

For performance, the device provides its registers mapped to two
different physical addresses, with the intent that the OS will map one
of them write-combining.

Thus, what you want is to perform all writes but the very last one as a
write-combining write; the very last write should be a conventional I/O
write that flushes the write combiners ahead of itself and triggers the
write.

Now, in theory you could use writel() for this, but if you have a
working writeq() [e.g. 64-bit mode] you want to use it.

So it's important that the driver can know when readq/writeq are
emulated at all.

One way to deal with that is the <linux/io64*.h> method, another is with
feature test macros.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

