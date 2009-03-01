Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZCAJoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZCAJoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZCAJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:43:52 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:36099 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753343AbZCAJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:43:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q3DqhmVOXrIEdfxAvO7hYsZoVekq4qQOqIcU//EYxtxW0NEsbd9imVdEYiFIQpFRqwpWXykMDrlsrw9DxQY7q7Wq43arqLe7m3TAuAbsTAobq09zl7ILAuNx7FvLnChTEmbmdCD4gBlpyL361yjtJHxrhPyFtBqBW5iPAbShz9w=  ;
X-YMail-OSG: GDP5.lAVM1mUT2hfjw2YzZ3r5toXpBV3Uo3I_I7FkKLU55cThhqU1GHaJz7JsgBFALflblyFHkuON_hW4q_WP5PZ7mgEqMsHgGXO1C7f0zs2RedlHKcHX4pJE41nfj2Nu59.dBhQm2OcG26Je0B3Beirghn5PAXnAzGqq47fzB6l5PsLCZAi.2vxmXd2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andy Green <andy@openmoko.com>
Subject: Re: [PATCH 0/2] spi: Add support for non-blocking synchronous transfers
Date: Sun, 1 Mar 2009 01:43:47 -0800
User-Agent: KMail/1.9.10
Cc: Balaji Rao <balajirrao@openmoko.org>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <20090228081036.31964.80618.stgit@fedora.yogi> <200902281233.50612.david-b@pacbell.net> <49AA3DD6.4040807@openmoko.com>
In-Reply-To: <49AA3DD6.4040807@openmoko.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903010143.47425.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Andy Green wrote:
> | This sounds like a bad design.  How can you know that no other
> | transfers are going on ... or are queued in front of the transfer
> | you're requesting?
> |
> | You'd need to wait for all the other transfers to work their
> | way through the transfer queue.  There are *much* better things
> | to do in interrupt handlers.
> 
> In our case, the sync and async SPI things are mutually exclusive, you 

Come up with some new terminology for what you're proposing,
instead of trying to repurpose the existing terms.  The
spi_sync() and spi_async() calls already exist, and they
are *NOT* mutually exclusive.

I suggest you talk about "non-sleeping" calls, since that
seems to be close to what you're thinking about.  (Though
it does beg the question of why you're not using the async
calls, if sleeping makes trouble...)


> either talk to your thing with interrupt-lockout protected sync
> transfers entirely or use the existing API.  It can be enforced if
> that's the concern.

The API proposal is a generic one, and the reference
implementation has deep issues as I noted.  At the
level of data corruption.  How would that be "enforced"
generally?


> I think it's a little fast to call down the airstrike of "bad design"
> on being able to use bitbang SPI inside an ISR.

The way to access SPI inside an ISR is spi_async().
No exceptions for bitbang are necessary.

Neither you nor Balaji have mentioned any issue that
prevents using that.  Or, for that matter, that you
even tried using the interface as designed.  You're
defending something that -- so far -- is not defensible;
it introduces data corruption.  I'm not sure what else
to call it but "bad design".  Regardless, the key point
is to call your attention to the fact that you're doing
something quite wrong.  (The nonsensical $SUBJECT was
the first clue...)


> Clearly, adding this 
> ability does not replace the existing system and exists parallel but
> compatibly with it;

No, it's not compatible.  Start by answering the question
I asked above (quoted at the top of this email), and you'll
surely begin to understand.


> but the existing system cannot provide the same 
> capability as it stands.

Erm, the existing system is clearly self-compatible.
I don't think that word means what you think it means.  ;)


> With two lis302dl motion sensors in GTA02, 
> they can spam up to 800 interrupts a second that need servicing each
> with a 7-byte bitbang read.

Hmm, I'm looking at a schematic with a lis302dl hooked up
using I2C ... at 400 KHz max.  So those chips have useful
use cases that don't need much of a data rate at all.

Now, 800 IRQ/sec * 7 bytes * 8 bits/byte == 44800 bits/sec,
which is easy to achieve.  At least, in drivers that are
written sensibly.  (Even if that's 45 Kbit/sec *each*...)


> The existing SPI setup in Linux does not 
> provide a way to deal with that in a CPU-friendly and low latency way
> (there's no FIFO in these devices either).

If you can't get 45 Kbit/second you're doing something
extremely odd.  I've bitbanged SPI at over 2 MHz on
ARM chips less than half the speed of your OpenMoko
hardware.


So to recap:  the $SUBJECT proposal has serious issues;
and simple math suggests that the performance issues you
are seeing are not fundamentally due to the code at or
below the layer being patched.

- Dave

