Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbYHERio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbYHERio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYHERig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:38:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35447 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754585AbYHERif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:38:35 -0400
Date: Tue, 5 Aug 2008 18:21:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linasvepstas@gmail.com
Cc: "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
Message-ID: <20080805182119.75913fa3@lxorguk.ukuu.org.uk>
In-Reply-To: <3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	<200808012319.05038.alistair@devzero.co.uk>
	<3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	<18580.48861.657366.629904@stoffel.org>
	<3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	<18581.6873.353028.695909@stoffel.org>
	<3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	<20080803231628.1361b75f@lxorguk.ukuu.org.uk>
	<3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've got the AMD 570 chipset, which is older than the
> amd76x that edac supports.  The latest MB's seem to have
> the AMD 790 chipset, which is also not currently supported.

AMD76x is very early 32bit so probably not..

The later AMD don't appear in the chipset specific code as the
hypedtransport era processors have on processor memory controllers and
use MCE reporting for that providing you have suitable memory etc.
Instead mcelog will decode them for you. The generic edac support for PCI
error scanning still applies.

> Can anyone get me the portion of the AMD 570 (nVidia
> nForce 570) chip specs that describe the RAM ECC
> error event counters? (I assume that this chip has some
> sort of error reporting or counting registers) I can sign
> NDA if needed.

C|N>K I've never even been able to extract IDE controller docs from
nVidia..

> I'm game. Care to guide me through?  So: on every write, this
> new device mapper module computes a checksum and stores
> it somewhere. On every read, it computes a checksum and
> compares to the stored value. Easy enough I guess.
> 
> Several hard parts:
> -- where to store the checksums?

That is the million dollar question - plus you can argue it is the fs
that should do it. There is stuff crawling through the standards world to
provide a small per block additional info area on disk sectors.

> -- what to do (besides print to dmesg) if there's a mismatch?

Configurable - panic/offline/warn ?

>    This suggests a new API:
> 
>    ++ "is this block device an md device?"
>    ++ "if yes to above, then give me alternate block"
>    ++ "invalidate copy n of block x"
>          (this last, because presumably one wants to tell md that
>          one of its copies is bad.)

It's the same as dm RAID hitting a physical read error. In the former
case you got the data back but it is wrong (so useless) in the latter you
got nothing back.

> I'm paranoid enough to be willing to implement something like
> this .. is the above design on the right track?

Yes. If you can figure out where to keep the checksums without ruining
performance (and of course if there isn't one lurking in device mapper
world not yet submitted).
