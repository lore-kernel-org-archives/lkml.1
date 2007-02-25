Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXBYCmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXBYCmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 21:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXBYCmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 21:42:10 -0500
Received: from mail.um.es ([155.54.212.109]:49148 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637AbXBYCmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 21:42:06 -0500
Date: Sun, 25 Feb 2007 03:41:40 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070223132645.GB11653@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702250255530.18915@ditec.inf.um.es>
References: <20070218055936.GF301@lazybastard.org>
 <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org>
 <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org>
 <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es> <20070221192523.GG3219@lazybastard.org>
 <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es> <20070222162547.GB7149@lazybastard.org>
 <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es> <20070223132645.GB11653@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-775373122-1172371300=:18915"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-775373122-1172371300=:18915
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Jörn,

On Fri, 23 Feb 2007, [utf-8] Jörn Engel wrote:

> On Thu, 22 February 2007 20:57:12 +0100, Juan Piernas Canovas wrote:
>>
>> I do not agree with this picture, because it does not show that all the
>> indirect blocks which point to a direct block are along with it in the
>> same segment. That figure should look like:
>>
>> Segment 1: [some data] [ DA D1' D2' ] [more data]
>> Segment 2: [some data] [ D0 D1' D2' ] [more data]
>> Segment 3: [some data] [ DB D1  D2  ] [more data]
>>
>> where D0, DA, and DB are datablocks, D1 and D2 indirect blocks which
>> point to the datablocks, and D1' and D2' obsolete copies of those
>> indirect blocks. By using this figure, is is clear that if you need to
>> move D0 to clean the segment 2, you will need only one free segment at
>> most, and not more. You will get:
>>
>> Segment 1: [some data] [ DA D1' D2' ] [more data]
>> Segment 2: [                free                ]
>> Segment 3: [some data] [ DB D1' D2' ] [more data]
>> ......
>> Segment n: [ D0 D1 D2 ] [         empty         ]
>>
>> That is, D0 needs in the new segment the same space that it needs in the
>> previous one.
>>
>> The differences are subtle but important.
>
> Ah, now I see.  Yes, that is deadlock-free.  If you are not accounting
> the bytes of used space but the number of used segments, and you count
> each partially used segment the same as a 100% used segment, there is no
> deadlock.
>
> Some people may consider this to be cheating, however.  It will cause
> more than 50% wasted space.  All obsolete copies are garbage, after all.
> With a maximum tree height of N, you can have up to (N-1) / N of your
> filesystem occupied by garbage.

I do not agree. Fortunately, the greatest part of the files are written at 
once, so what you usually have is:

Segment 1: [                  data                  ]
Segment 2: [some data] [ D0 DA DB D1 D2 ] [more data]
Segment 3: [                  data                  ]
......

On the other hand, the DualFS cleaner tries to clean several segments 
everytime it runs. Therefore, if you have the following case:

Segment 1: [some data] [ DA D1' D2' ] [more data]
Segment 2: [some data] [ D0 D1' D2' ] [more data]
Segment 3: [some data] [ DB D1' D2' ] [more data]
......

after cleaning, you can have this one:

Segment 3: [                  free                  ]
Segment 3: [                  free                  ]
Segment 3: [                  free                  ]
......
Segment i: [D0 DA DB D1 D2 ] [       more data      ]

Moreover, if the cleaner starts running when the free space drops below a 
specific threshold, it is very difficult to waste more than 50% of disk 
space, specially with meta-data (actually, I am unable to imagine that 
situation :).

> Another downside is that with large amounts of garbage between otherwise
> useful data, your disk cache hit rate goes down.  Read performance is
> suffering.  But that may be a fair tradeoff and will only show up in
> large metadata reads in the uncached (per Linux) case.  Seems fair.

Well, our experimental results say another thing. As I have said, the 
greatest part of the files are written at once, so their meta-data blocks 
are together on disk. This allows DualFS to implement an explicit 
prefetching of meta-data blocks which is quite effective, specially when 
there are several processes reading from disk at the same time.

On the other hand, DualFS also implements an on-line meta-data relocation 
mechanism which can help to improve meta-data prefetching, and garbage 
collection.

Obviously, there can be some slow-growing files that can produce some 
garbage, but they do not hurt the overall performance of the file system.

>
> Quite interesting, actually.  The costs of your design are disk space,
> depending on the amount and depth of your metadata, and metadata read
> performance.  Disk space is cheap and metadata reads tend to be slow for
> most filesystems, in comparison to data reads.  You gain faster metadata
> writes and loss of journal overhead.  I like the idea.
>

Yeah :) If you have taken a look to my presentation at LFS07, the disk 
traffic of meta-data blocks is dominated by writes.

> Jörn
>

 	Juan.
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
--916140492-775373122-1172371300=:18915--
