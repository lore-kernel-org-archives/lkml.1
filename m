Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbXBVT5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbXBVT5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXBVT5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:57:15 -0500
Received: from mail.um.es ([155.54.212.109]:55819 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbXBVT5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:57:13 -0500
Date: Thu, 22 Feb 2007 20:57:12 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070222162547.GB7149@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es>
References: <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes>
 <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
 <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es>
 <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es>
 <20070221192523.GG3219@lazybastard.org> <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es>
 <20070222162547.GB7149@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-574060533-1172174232=:19296"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-574060533-1172174232=:19296
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Jörn,

On Thu, 22 Feb 2007, [utf-8] Jörn Engel wrote:

>> A partial segment is a transaction unit, and contains "all" the blocks
>> modified by a file system operation, including indirect blocks and i-nodes
>> (actually, it contains the blocks modified by several file system
>> operations, but let us assume that every partial segment only contains the
>> blocks modified by a single file system operation).
>>
>> So, the above figure is as follows in DualFS:
>>
>>  Before:
>>  Segment 1: [some data] [ D0 D1 D2 I ] [more data]
>>  Segment 2: [             some data              ]
>>  Segment 3: [               empty                ]
>>
>> If the datablock D0 is modified, what you get is:
>>
>>  Segment 1: [some data] [  garbage   ] [more data]
>>  Segment 2: [             some data              ]
>>  Segment 3: [ D0 D1 D2 I ] [       empty         ]
>
> You have fairly strict assumptions about the "Before:" picture.  But

The "Before" figure is intentionally simple because it is enough to 
understand how the meta-data device of DualFS works, and why the cleaner 
is deadlock-free ;-)

> what happens if those assumptions fail.  To give you an example, imagine
> the following small script:
>
> $ for i in `seq 1000000`; do touch $i; done
>
> This will create a million dentries in one directory.  It will also
> create a million inodes, but let us ignore those for a moment.  It is
> fairly unlikely that you can fit a million dentries into [D0], so you
> will need more than one block.  Let's call them [DA], [DB], [DC], etc.
> So you have to write out the first block [DA].
>
> Before:
> Segment 1: [some data] [ DA D1 D2 I ] [more data]
> Segment 2: [             some data              ]
> Segment 3: [               empty                ]
>
> If the datablock D0 is modified, what you get is:
>
> Segment 1: [some data] [  garbage   ] [more data]
> Segment 2: [             some data              ]
> Segment 3: [ DA D1 D2 I ] [       empty         ]
>
> That is exactly your picture.  Fine.  Next you write [DB].
>
> Before: see above
> After:
> Segment 1: [some data] [  garbage   ] [more data]
> Segment 2: [             some data              ]
> Segment 3: [ DA][garbage] [ DB D1 D2 I ] [ empty]
>
> You write [DC].  Note that Segment 3 does not have enough space for
> another partial segment:
>
> Segment 1: [some data] [  garbage   ] [more data]
> Segment 2: [             some data              ]
> Segment 3: [ DA][garbage] [ DB][garbage] [wasted]
> Segment 4: [ DC D1 D2 I ] [       empty         ]
>
> You write [DD] and [DE]:
> Segment 1: [some data] [  garbage   ] [more data]
> Segment 2: [             some data              ]
> Segment 3: [ DA][garbage] [ DB][garbage] [wasted]
> Segment 4: [ DC][garbage] [ DD][garbage] [wasted]
> Segment 5: [ DE D1 D2 I ] [       empty         ]
>
> And some time later you even have to switch to a new indirect block, so
> you get before:
>
> Segment n  : [ DX D1 D2 I ] [       empty         ]
>
> After:
>
> Segment n  : [ DX D1][garb] [ DY DI D2 I ] [ empty]
>
> What you end up with after all this is quite unlike you "Before"
> picture.  Instead of this:
>
>>  Segment 1: [some data] [ D0 D1 D2 I ] [more data]
>

I agree with all the above, althoug it displays the wort case because a 
partial segment usually contains several datablocks, and a few indirect 
blocks. But it is fine for our purposes.

> You may have something closer to this:
>
>>> Segment 1: [some data] [   D1  ] [more data]
>>> Segment 2: [some data] [   D0  ] [more data]
>>> Segment 3: [some data] [   D2  ] [more data]
>

I do not agree with this picture, because it does not show that all the 
indirect blocks which point to a direct block are along with it in the 
same segment. That figure should look like:

Segment 1: [some data] [ DA D1' D2' ] [more data]
Segment 2: [some data] [ D0 D1' D2' ] [more data]
Segment 3: [some data] [ DB D1  D2  ] [more data]

where D0, DA, and DB are datablocks, D1 and D2 indirect blocks which 
point to the datablocks, and D1' and D2' obsolete copies of those 
indirect blocks. By using this figure, is is clear that if you need to 
move D0 to clean the segment 2, you will need only one free segment at 
most, and not more. You will get:

Segment 1: [some data] [ DA D1' D2' ] [more data]
Segment 2: [                free                ]
Segment 3: [some data] [ DB D1' D2' ] [more data]
......
Segment n: [ D0 D1 D2 ] [         empty         ]

That is, D0 needs in the new segment the same space that it needs in the 
previous one.

The differences are subtle but important.

Regards,

 	Juan.

> You should try the testcase and look at a dump of your filesystem
> afterwards.  I usually just read the raw device in a hex editor.
>
> Jörn
>
>

-- 
D. Juan Piernas Cánovas
Departamento de Ingeniería y Tecnología de Computadores
Facultad de Informática. Universidad de Murcia
Campus de Espinardo - 30080 Murcia (SPAIN)
Tel.: +34968367657    Fax: +34968364151
email: piernas@ditec.um.es
PGP public key:
http://pgp.rediris.es:11371/pks/lookup?search=piernas%40ditec.um.es&op=index

*** Por favor, envíeme sus documentos en formato texto, HTML, PDF o PostScript :-) ***
--916140492-574060533-1172174232=:19296--
