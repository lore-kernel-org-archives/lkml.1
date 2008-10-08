Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYJHHNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYJHHNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYJHHNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:13:14 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:52362 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYJHHNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:13:14 -0400
Date: Wed, 8 Oct 2008 09:13:09 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
In-Reply-To: <1223416391.8195.22.camel@brick>
Message-ID: <Pine.LNX.4.64.0810080908480.19202@anakin>
References: <1223416391.8195.22.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Harvey Harrison wrote:
> [related question regarding the SCSI-private endian helper needs at the end]
> 
> Currently on the read side, we have (le16 as an example endianness)
> 
> le16_to_cpup(__le16 *)
> get_unaligned_le16(void *)
> 
> And on the write side:
> 
> *(__le16)ptr = cpu_to_le16(u16)
> put_unaligned_le16(u16, void *);
> 
> On the read side, Al said he would have preferred the unaligned version
> take the same types as the aligned, rather than void *.  AKPM didn't think

As I said before, me too (take the same types as the aligned). I like to
rely on sparse for:

    struct {
	...
	__le32 x;
	...
    } s __attribute__ ((packed));

get_unaligned_le16(&s.x);

> the use of get_ was that great as get/put generally implies some kind of reference
> taking in the kernel.

OK.

> As the le16_to_cpup has been around for so long and is more recognizable, let's
> make it the same for the unaligned case and typesafe:
> 
> le16_to_cpup(__le16 *)
> unaligned_le16_to_cpup(__le16 *)

I always hated that naming...

> On the write side, the above get/put and type issues are still there, in addition AKPM felt
> that the ordering of the put_unaligned parameters was opposite what was intuitive and that
> the pointer should come first.
> 
> In this case, as there is currently no aligned helper (other than in some drivers defining macros)
> define the api thusly:
> 
> Aligned:
> write_le16(__le16 *ptr, u16 val)
> 
> Unaligned:
> unaligned_write_le16(__le16 *ptr, u16 val)

Does it write to MMIO I/O space? No? Then please don't use write (like
in writeb()).

What about load_{unaligned_,}le16() and store_{unaligned_,}le16()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
