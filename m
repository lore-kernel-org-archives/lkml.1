Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYHFVjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYHFVjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYHFVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:33:09 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:59576 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYHFVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=gdJmXTp0RQ1pA2aTHd+h51QEBLvZA09aYdHbBrfVEM0iK7oE+gKobsfLVCEk4ZHnR7
         pFwQwDIIyuy14bMUacRVefzID7KHCqqgvuz5n7lGQSymOo1B8cMv62jY8OHWJwp3vCji
         b+Z+8is0cPTs8uupgf2qbv77T42x/asmk6X9Q=
Message-ID: <3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
Date: Wed, 6 Aug 2008 16:33:04 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080805182119.75913fa3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <200808012319.05038.alistair@devzero.co.uk>
	 <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	 <18580.48861.657366.629904@stoffel.org>
	 <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	 <18581.6873.353028.695909@stoffel.org>
	 <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	 <20080803231628.1361b75f@lxorguk.ukuu.org.uk>
	 <3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
	 <20080805182119.75913fa3@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/5 Alan Cox <alan@lxorguk.ukuu.org.uk>:

>> I'm game. Care to guide me through?  So: on every write, this
>> new device mapper module computes a checksum and stores
>> it somewhere. On every read, it computes a checksum and
>> compares to the stored value. Easy enough I guess.
>>
>> Several hard parts:
>> -- where to store the checksums?
>
> That is the million dollar question - plus you can argue it is the fs
> that should do it. There is stuff crawling through the standards world to
> provide a small per block additional info area on disk sectors.

My objection to fs-layer checksums (e.g. in some user-space
file system) is that it  doesn't leverage the extra info that RAID
has.  If a block is bad, RAID can probably fetch another one
that is good. You can't do this at the file-system level.

I assume I can layer device-mappers anywhere, right?
Layering one *underneath* md-raid would allow it to
reject/discard bad blocks, and then let the raid layer
try to find a good block somewhere else.

I assume that a device mapper can alter the number
of blocks-in to the number of blocks-out; that it doesn't
have to be 1-1. Then for every 10 sectors of data, it
would use 11 sectors of storage, one holding the
checksum.  I'm very naive about how the block layer
works, so I don't know what snags there might be.

The downside of this is that the disk wouldn't be
naively readable unless the specific mapper module
was in place -- so one would need a superblock of
some sort indicating the type of checksumming used,
etc.  Is there any "standardized" way of managing
superblocks for use by the device mapper?  I guess
the encrypting dm has to store meta-information
somewhere, too, specifying what kind of encryption
was used.  I'll look at that.

> Yes. If you can figure out where to keep the checksums without ruining
> performance

Heh. Unlikely. The act of checksumming will impact
performance. It should end up similar to the impact
from encryption (maybe not quite as bad), or comparable
to raid-5 (which computes various kinds of parity).

> (and of course if there isn't one lurking in device mapper
> world not yet submitted).

I'm googling, but I don't see anything.  However, I now see,
for the first time,   pending workd for 2.6.27 for a field in bio
called  "blk_integrity". I cannot figure out if this work requires
special-whiz-bang disk drives to be purchased.

Also, it seems to be limited to 8 bytes of checksums per 512
byte block? This is reasonable for checksumming, I guess,
but one could get even fancier and run ECC-type sums, if
one could store, say, an addtional 50 bytes for every 512
bytes. I'm cc'ing Martin Petersen, the developer, for
comments.


--linas
