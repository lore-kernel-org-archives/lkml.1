Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYHVL1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYHVL1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHVL1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:27:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYHVL1n (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:27:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 03/10] AXFS: axfs.h
Date: Fri, 22 Aug 2008 13:27:36 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00E6.2070505@gmail.com> <200808211424.31966.arnd@arndb.de> <6934efce0808211540p237f2c52pd71c2b955b3f54a8@mail.gmail.com>
In-Reply-To: <6934efce0808211540p237f2c52pd71c2b955b3f54a8@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221327.37371.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19uBzA64aBqOXStBxtsFKxHu9x9VBT35EXRe+l
 dCslrtr27BbDgA0+Fkde0XhOG026vXSgudkBEy1JWTKd7/Wx4n
 OQf1B+Yh91RDGefd79R0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008, Jared Hulbert wrote:
> > This bytetable stuff looks overly complicated, both the data structure and
> > the access method. It seems like you are implementing your own custom Huffman
> > compression with this.
> >
> > Is the reasonn for the bytetable just to pack numbers efficiently, or do you
> > have a different intention?
> 
> It looks more complicated than it is.  I need a data structure that is
> 64bit capable, easily read-in-place (remember this is designed to be
> an XIP fs), and highly space efficient.  Because it's XIP I didn't
> want something that required a lot of calculation nor something that
> made you incur a lot of cache misses.  So yes I just want to pack
> numbers in an easily read-in-place fashion.

ok, that makes sense.
 
> If I have an array of u64 numbers tracking small numbers (a[0] = 1;
> a[1] = 2;) just throwing that onmedia is a big waste.
> (0x0000000000000001; 0x0000000000000002)  Having different array types
> for different images such as arrays of u8,u16,u32,u64 becomes less
> efficient for 3,5,6 and 7 byte numbers, 3 bytes was a particularly
> interesting size for me.
> 
> All I'm doing is removing the totally unnecessary zeros and aligning by bytes.
> Take an array of u64 like this :
> 0x0000000000000005
> 0x0000000000001001
> 0x00000000000a0000
> 
> I strip off the unneeded leading zeros:
> 0x000005
> 0x001001
> 0x0a0000
> 
> Then pack them to byte alignment:
> 0x0000050010010a0000
> 
> Sure it could be encoded more but that would make it harder to extract
> the data.  This way I can read the data in one, maybe two, cache
> misses.  A couple of shifts to deal with the alignment and endianness
> and we are done.

So do I understand right that 3 bytes is your minimum size, and going
smaller than that would not be helpful? Otherwise I would assume that
storing a '5' should only take one byte instead of three.

I don't unsterstand yet why you store the length of each word separate
from the word. Most variable-length codes store that implicitly in
the data itself, e.g. in the upper three bits, so that for storing
0x5, 0x1001, 0xa0000, this could e.g. end up as 0x054010014a0000,
which is shorter than what you have, but not harder to decode.

> > Did you see a significant size benefit over simply storing all metadata as
> > uncompressed data structures like in cramfs?
> 
> Yes. For some modest values of significant.  In terms of the amount of
> space required to track the metadata it is more dramatic.  For a small
> rootfs I can fit many of the data structures in an u8 array, while
> maintaining u64 compatibility.  Compared to dumping u64 arrays onmedia
> that's an 8X savings.  But it's an 8X savings of a smallish percentage
> of the image size.  The difference is more pronounced on a smaller
> (2MB) filesystem I tested but it was only ~5% if memory serves me
> correct.

If you can save 5% on a real-world file system, you have convinced me.

> > Have you considered storing simple dentry/inode data in node_type==Compressed
> > nodes?
> 
> Yes, I thought a lot about that.  But I choose against it because I
> wanted read-in-place data structures for minimum RAM usage in the XIP
> case and I figure the way I do it would stat() faster.

ok.

	Arnd <><
