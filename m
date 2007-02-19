Return-Path: <linux-kernel-owner+w=401wt.eu-S965567AbXBSX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965567AbXBSX6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965568AbXBSX57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:57:59 -0500
Received: from mail.um.es ([155.54.212.109]:41077 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965567AbXBSX56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:57:58 -0500
Date: Tue, 20 Feb 2007 00:57:50 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070218055936.GF301@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
References: <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org>
 <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org>
 <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org>
 <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org>
 <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-1941398117-1171864804=:8828"
Content-ID: <Pine.LNX.4.61.0702190707180.13929@ditec.inf.um.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-1941398117-1171864804=:8828
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.61.0702190707181.13929@ditec.inf.um.es>

Hi Jörn,

I understand the problem that you describe with respect to the GC, but 
let me explain why I think that it has a small impact on DualFS.

Actually, the GC may become a problem when the number of free segments is 
50% or less. If your LFS always guarantees, at least, 50% of free 
"segments" (note that I am talking about segments, not free space), the 
deadlock problem disappears, right? This is a quite naive solution, but it 
works.

In a traditional LFS, with data and meta-data blocks, 50% of free segments 
represents a huge amount of wasted disk space. But, in DualFS, 50% of free 
segments in the meta-data device is not too much. In a typical Ext2, 
or Ext3 file system, there are 20 data blocks for every meta-data block 
(that is, meta-data blocks are 5% of the disk blocks used by files). 
Since files are implemented in DualFS in the same way, we can suppose the 
same ratio for DualFS (1).

Now, let us assume that the data device takes 90% of the disk space, and 
the meta-data device the other 10%. When the data device gets full, the 
meta-data blocks will be using the half of the meta-data device, and the 
other half (5% of the entire disk) will be free. Frankly, 5% is not too 
much.

Remember, I am supposing a naive implementation of the cleaner. With a 
cleverer one, the meta-data device can be smaller, and the amount of
disk space finally wasted can be smaller too. The following paper proposes 
some improvements:

- Jeanna Neefe Matthews, Drew Roselli, Adam Costello, Randy Wang, and
   Thomas Anderson.  "Improving the Performance of Log-structured File
   Systems with Adaptive Methods".  Proc. Sixteenth ACM Symposium on
   Operating Systems Principles (SOSP), October 1997, pages 238 - 251.

BTW, I think that what they propose is very similar to the two-strategies 
GC that you propose in a separate e-mail.

The point of all the above is that you must improve the common case, and 
manage the worst case correctly. And that is the idea behind DualFS :)

Regards,

 	Juan.

(1) DualFS can also use extents to implement regular files, so the ratio 
of data blocks with respect to meta-data blocks can be greater.


On Sun, 18 Feb 2007, [utf-8] Jörn Engel wrote:

> On Sat, 17 February 2007 15:47:01 -0500, Sorin Faibish wrote:
>>
>> DualFS can probably get around this corner case as it is up to the user
>> to select the size of the MD device size. If you want to prevent this
>> corner case you can always use a device bigger than 10% of the data device
>> which is exagerate for any FS assuming that the directory files are so
>> large (this is when you have billions of files with long names).
>> In general the problem you mention is mainly due to the data blocks
>> filling the file system. In DualFS case you have the choice of selecting
>> different sizes for the MD and Data volume. When Data volume gets full
>> the GC will have a problem but the MD device will not have a problem.
>> It is my understanding that most of the GC problem you mention is
>> due to the filling of the FS with data and the result is a MD operation
>> being disrupted by the filling of the FS with data blocks. As about the
>> performance impact on solving this problem, as you mentioned all
>> journal FSs will have this problem, I am sure that DualFS performance
>> impact will be less than others at least due to using only one MD
>> write instead of 2.
>
> You seem to make the usual mistakes when people start to think about
> this problem.  But I could misinterpret you, so let me paraphrase your
> mail in questions and answer what I believe you said.
>
> Q: Are journaling filesystems identical to log-structured filesystems?
>
> Not quite.  Journaling filesystems usually have a very small journal (or
> log, same thing) and only store the information necessary for atomic
> transactions in the journal.  Not sure what a "journal FS" is, but the
> name seems closer to a journaling filesystem.
>
> Q: DualFS seperates Data and Metadata.  Does that make a difference?
>
> Not really.  What I called "data" in my previous mail is a
> log-structured filesystems view of data.  DualFS stored file content
> seperately, so from an lfs view, that doesn't even exist.  But directory
> content exists and behaves just like file content wrt. the deadlock
> problem.  Any data or metadata that cannot be GC'd by simply copying but
> requires writing further information like indirect blocks, B-Tree nodes,
> etc. will cause the problem.
>
> Q: If the user simply reserves some extra space, does the problem go
> away?
>
> Definitely not.  It will be harder to hit, but a rare deadlock is still
> a deadlock.  Again, this is only concerned with the log-structured part
> of DualFS, so we can ignore the Data volume.
>
> When data is spread perfectly across all segments, the best segment one
> can pick for GC is just as bad as the worst.  So let us take some
> examples.  If 50% of the lfs is free, you can pick a 50% segment for GC.
> Writing every single block in it may require writing one additional
> indirect block, so GC is required to write out a 100% segment.  It
> doesn't make any progress at 50% (in a worst case scenario) and could
> deadlock if less than 50% were free.
>
> If, however, GC has to write out a singly and a doubly indirect block,
> 67% of the lfs need to be free.  In general, if the maximum height of
> your tree is N, you need (N-1)/N * 100% free space.  Most people refer
> to that as "too much".
>
> If you have less free space, the filesystem will work just fine "most of
> the time".  That is nice and cool, but it won't help your rare user that
> happens to hit the rare deadlock.  Any lfs needs a strategy to prevent
> this deadlock for good, not just make it mildly unlikely.
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
--916140492-1941398117-1171864804=:8828--
