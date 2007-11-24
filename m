Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXKXQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXKXQTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 11:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXKXQTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 11:19:35 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:59916 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXKXQTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 11:19:34 -0500
Date: Sat, 24 Nov 2007 17:19:31 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Luciano Rocha <strange@nsk.no-ip.org>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071124171931.699aa1ff@poseidon.drzeus.cx>
In-Reply-To: <20071124155052.GA15440@bit.office.eurotux.com>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
	<20071124143441.41657307@poseidon.drzeus.cx>
	<20071124155052.GA15440@bit.office.eurotux.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 15:50:52 +0000
Luciano Rocha <strange@nsk.no-ip.org> wrote:

> 
> Dumb memcpy (while (len--) { *d++ = *s++ }) will have alignment problems
> in any case. Intelligent ones, like the one provided in glibc, first copy
> bytes till output is aligned (C file) *or* size is a multiple (i686 asm file)
> of word size, and then it copies word-by-word.
> 
> Linux's x86_64 memcpy does the opposite, copies 64bit words, and then
> copies the last bytes.
> 
> So, in effect, as long as no packed structures are used, memcpy should
> be safer on *int, etc., than *char, as the compiler ensures
> word-alignment.
> 

It most certainly does not. gcc will assume that an int* has int alignment. memcpy() is a builtin, which gcc can translate to pretty much anything. And C specifies that a pointer to foo, will point to a real object of type foo, so gcc can't be blamed for the unsafe typecasts. I have tested this the hard way, so this is not just speculation.

E.g., we have the following struct:

struct foo
{
	u8 a[4];
	u32 b;
};

This struct will have a size of 8 bytes and an alignment of 4 bytes (caused by the member b). Now take the following code:

void copy_foo(struct foo *dst, struct foo *src)
{
	*dst = *src;
}

On a platform that supports 64-bit loads and stores (e.g. AVR32, where I got hit by this), this will generate:

	LD r1, (src)
	ST r1, (dst)

Now if I replace that with:

void copy_foo(struct foo *dst, struct foo *src)
{
	memcpy(dst, src, sizeof(struct foo));
}

then it will generate the same code. So I cannot use copy_foo() to transfer a struct foo either out of, or into a packet buffer.

In other words, memcpy() does _not_ save you from alignment issues. If you cast from char* or void* to something else, you better be damn sure the alignment is correct because gcc will assume it is.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
