Return-Path: <linux-kernel-owner+w=401wt.eu-S1751404AbXBVEaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbXBVEaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 23:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXBVEaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 23:30:16 -0500
Received: from mail.um.es ([155.54.212.109]:45707 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbXBVEaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 23:30:14 -0500
Date: Thu, 22 Feb 2007 05:30:03 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070221192523.GG3219@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es>
References: <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com>
 <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes>
 <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
 <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es>
 <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es>
 <20070221192523.GG3219@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-1274423687-1172116056=:9002"
Content-ID: <Pine.LNX.4.61.0702220508490.9002@ditec.inf.um.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-1274423687-1172116056=:9002
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.61.0702220508491.9002@ditec.inf.um.es>

Hi Jörn,

I have been thinking about the problem that you describe, and, 
definitively, DualFS does not have that problem. I could be wrong, but, 
I actually believe that the GC implemented by DualFS is deadlock-free. 
The key is the design of the log-structured file system used by DualFS for 
the meta-data device, which is different to the design that you propose.

On Wed, 21 Feb 2007, [utf-8] Jörn Engel wrote:

> On Wed, 21 February 2007 19:31:40 +0100, Juan Piernas Canovas wrote:
>>
>> I do not understand. Do you mean that if I have 10 segments, 5 busy and 5
>> free, after cleaning I could need 6 segments? How? Where the extra blocks
>> come from?
>
> This is a fairly complicated subject and I have trouble explaining it to
> people - even though I hope that maybe one or two dozen understand it by
> now.  So let me try to give you an example:
>
> In LogFS, inodes are stored in an inode file.  There are no B-Trees yet,
> so the regular unix indirect blocks are used.  My example will be
> writing to a directory, so that should only involve metadata by your
> definition and be a valid example for DualFS as well.  If it is not,
> please tell me where the difference lies.
>
> The directory is large, so appending to it involves writing a datablock
> (D0), and indirect block (D1) and a doubly indirect block (D2).
>
> Before:
> Segment 1: [some data] [   D1  ] [more data]
> Segment 2: [some data] [   D0  ] [more data]
> Segment 3: [some data] [   D2  ] [more data]
> Segment 4: [             empty             ]
> ...

DualFS writes meta-blocks in variable-sized chunks that we call partial 
segments. The meta-data device, however, is divided into segments, which 
have the same size. A partial segment can be as large a a segment, but a 
segment usually has more that one partial segment. Besides, a partial 
segment can not cross a segment boundary.

A partial segment is a transaction unit, and contains "all" the blocks 
modified by a file system operation, including indirect blocks and i-nodes 
(actually, it contains the blocks modified by several file system 
operations, but let us assume that every partial segment only contains the 
blocks modified by a single file system operation).

So, the above figure is as follows in DualFS:

  Before:
  Segment 1: [some data] [ D0 D1 D2 I ] [more data]
  Segment 2: [             some data              ]
  Segment 3: [               empty                ]

If the datablock D0 is modified, what you get is:

  Segment 1: [some data] [  garbage   ] [more data]
  Segment 2: [             some data              ]
  Segment 3: [ D0 D1 D2 I ] [       empty         ]

This is very similar to what the cleaner does. Therefore, moving a direct 
datablock (D0) to a new segment does not require more space than in the 
original segment. That is, cleaning a segment in DualFS requires just one 
free segment, and not more.

The result is that you can use all the free segments in DualFS, and its 
cleaner is simple and deadlock-free. Probably the design is not the most 
space-efficient in the world, but it removes some other serious problems.

And, remember, we are talking about meta-data (which is a small part of 
the file system), and disk space (which is quite inexpensive).

Regards,

 	Juan.

>
> After:
> Segment 1: [some data] [garbage] [more data]
> Segment 2: [some data] [garbage] [more data]
> Segment 3: [some data] [garbage] [more data]
> Segment 4: [D0][D1][D2][      empty        ]
> ...
>
> Ok.  After this, the position of D2 on the medium has changed.  So we
> need to update the inode and write that as well.  If the inode number
> for this directory is high, we will need to write the inode (I0), an
> indirect block (I1) and a doubly indirect block (I2).  The picture
> becomes a bit more complicates.
>
> Before:
> Segment 1: [some data] [   D1  ] [more data]
> Segment 2: [some data] [   D0  ] [more data]
> Segment 3: [some data] [   D2  ] [more data]
> Segment 4: [             empty             ]
> Segment 5: [some data] [   I1  ] [more data]
> Segment 6: [some data] [   I0  ] [more data]
> Segment 7: [some data] [   I2  ] [more data]
> ...
>
> After:
> Segment 1: [some data] [garbage] [more data]
> Segment 2: [some data] [garbage] [more data]
> Segment 3: [some data] [garbage] [more data]
> Segment 4: [D0][D1][D2][I0][I1][I2][ empty ]
> Segment 5: [some data] [garbage] [more data]
> Segment 6: [some data] [garbage] [more data]
> Segment 7: [some data] [garbage] [more data]
> ...
>
> So what has just happened?  The user did a single "touch foo" in a large
> directory and has caused six objects to move.  Unless some of those
> objects were in the same segment before, we now have six segments
> containing a tiny amount of garbage.
>
> And there is almost no way how you can squeeze that garbage back out.
> The cleaner will fundamentally do the same thing as a regular write - it
> will move objects.  So if you want to clean a segment containing the
> block of a different directory, you may again have to move five
> additional objects, the indirect blocks, inode and ifile indirect
> blocks.
>
> At this point, your cleaner is becoming a threat.  There is a real
> danger that it will create more garbage in unrelated segments than it
> frees up.  I claim that you cannot keep 50% clean segments, unless you
> move away from the simplistic cleaner I described above.
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
--916140492-1274423687-1172116056=:9002--
