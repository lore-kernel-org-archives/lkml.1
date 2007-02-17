Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXBQUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXBQUsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932878AbXBQUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:48:45 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:37451 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbXBQUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:48:44 -0500
Date: Sat, 17 Feb 2007 15:47:01 -0500
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
From: "Sorin Faibish" <sfaibish@emc.com>
Cc: "Juan Piernas Canovas" <piernas@ditec.um.es>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "kernel list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org>
Content-Transfer-Encoding: 8bit
Message-ID: <op.tnwuonh3rwwil4@muki-1mj5c5mxes>
In-Reply-To: <20070217183646.GE301@lazybastard.org>
User-Agent: Opera Mail/9.00 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.17.121433
X-PerlMx-Spam: Gauge=, SPAM=0%, Reasons='EMC_BODY_1+ -3, EMC_FROM_0+ -2, __C230066_P5 0, __CP_MEDIA_2_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007 13:36:46 -0500, Jörn Engel <joern@lazybastard.org>  
wrote:

> On Sat, 17 February 2007 13:10:23 -0500, Bill Davidsen wrote:
>> >
>> I missed that. Which corner case did you find triggers this in DualFS?
>
> This is not specific to DualFS, it applies to any log-structured
> filesystem.
>
> Garbage collection always needs at least one spare segment to collect
> valid data into.  Regular writes may require additional free segments,
> so GC has to kick in and free those when space is getting tight.  (1)
>
> GC frees segments by writing all valid data in it into the spare
> segment.  If there is remaining space in the spare segment, GC can move
> more data from further segment.  Nice and simple.
>
> The requirement is that GC *always* frees more segments than it uses up
> doing so.  If that requirement is not fulfilled, GC will simply use up
> its last spare segment without freeing a new one.  We have a deadlock.
>
> Now imagine your filesystem is 90% full and all data is spread perfectly
> across all segments.  The best segment you could pick for GC is 90%
> full.  One would imagine that GC would only need to copy those 90% into
> a spare segment and have freed 100%, making overall progress.
>
> But more log-structured filesystems maintain a tree of some sorts on the
> medium.  If you move data elsewhere, you also need to update the
> indirect block pointing to it.  So that has to get written as well.  If
> you have doubly or triply indirect blocks, those need to get written.
> So you can end up writing 180% or more to free 100%.  Deadlock.
>
> And if you read the documentation of the original Sprite LFS or any
> other of the newer log-structured filesystems, you usually won't see a
> solution to this problem, or even an acknowledgement that the problem
> exists in the first place.  But there is no shortage of log-structured
> filesystem projects that were abandoned years ago and have "cleaner" or
> "garbage collector" as their top item on the todo-list.  Coincidence?
>
>
> (1) GC may also kick in earlier, but that is just an optimization and
> doesn't change the worst case, so that bit is irrelevant here.
>
>
> Btw, the deadlock problem is solvable and I definitely don't want to
> discourage further work in this area.  DualFS does look interesting.
> But my solution for this problem will likely eat up all the performance
> DualFS has gained and more, as it isn't aimed at hard disks.  So someone
> has to come up with a different idea.
DualFS can probably get around this corner case as it is up to the user
to select the size of the MD device size. If you want to prevent this
corner case you can always use a device bigger than 10% of the data device
which is exagerate for any FS assuming that the directory files are so
large (this is when you have billions of files with long names).
In general the problem you mention is mainly due to the data blocks
filling the file system. In DualFS case you have the choice of selecting
different sizes for the MD and Data volume. When Data volume gets full
the GC will have a problem but the MD device will not have a problem.
It is my understanding that most of the GC problem you mention is
due to the filling of the FS with data and the result is a MD operation
being disrupted by the filling of the FS with data blocks. As about the
performance impact on solving this problem, as you mentioned all
journal FSs will have this problem, I am sure that DualFS performance
impact will be less than others at least due to using only one MD
write instead of 2.

>
> Jörn
>



-- 
Best Regards
  Sorin Faibish
Senior Technologist
Senior Consulting Software Engineer Network Storage Group

        EMC²            where information lives

Phone: 508-435-1000 x 48545
Cellphone: 617-510-0422
Email : sfaibish@emc.com

