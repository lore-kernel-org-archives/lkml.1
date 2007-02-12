Return-Path: <linux-kernel-owner+w=401wt.eu-S964889AbXBLQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889AbXBLQ1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXBLQ1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:27:19 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:57893 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889AbXBLQ1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:27:19 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Mon, 12 Feb 2007 17:27:17 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <p73abzji9xi.fsf@bingen.suse.de>
In-Reply-To: <p73abzji9xi.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702121727.17108.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Februar 2007 18:04 schrieb Andi Kleen:
> "Martin A. Fink" <fink@mpe.mpg.de> writes:
> > 
> > What I did:
> > I wrote blocks of 1 MB size to file. Each 1 GB I made a fsync and took the 
> > time. For those tests with filesystems I wrote files of 1 GB size, 
otherwise 
> > I just wrote to the raw device.
> 
> Newer Linux versions depending on the disk and the file system will tell
> the disk to flush the buffers to disk on fsync. FreeBSD might or might not
> do that, but if it doesn't it would explain the difference.

If you call fsync in BSD then you get what you expect. anything that is still 
not on disk will be written. Afterwards fsync returns... So this should be 
the same like with linux?!
> 
> > 
> > Results: -1-
> > 
> > Test					OpenSuSE(AHCI)			FreeBSD(AHCI)
> > 
---------------------------------------------------------------------------------------------------------------------------------------
> > SSD(vfat 25GB)			41+/-2 MB/s at 4-10%		15+/-0 MB/s at 2% CPU
> 
> vfat is certainly not a performance optimized file system.
That is just a minor test.
> 
> > SSD(raw  25GB) 		26+/-1 MB/s at 4-10% CPU	48+/-0 MB/s at 1% CPU

The above line is what makes me wondering !!!

> > SSD(ext3 25GB)		39+/-5 MB/s at 10-15% CPU	34+/-0 MB/s at 14% CPU
> > SSD(ext2 25GB)		42+/-1 MB/s at 10-15% CPU	32+/-0 MB/s at 10% CPU
> 
> 
> You could use oprofile (http://oprofile.sourceforge.net) to find out
> where the CPU is being used.
> 
> 
> > 
---------------------------------------------------------------------------------------------------------------------------------------
> > 
> > Test					OpenSuSE (AHCI off)		FreeBSD (AHCI off)
> > 
---------------------------------------------------------------------------------------------------------------------------------------
> > SSD(vfat 25GB)			22+/-4 MB/s at 6-19% CPU	--
> > SSD(raw  25GB)		33+/-4 MB/s at 7-14% CPU	41+/-0 MB/s at 1% CPU
> 
> I remember vaguely (but I might be wrong here) the standard block
> character devices on FreeBSD are buffered, while raw is truly
> unbuffered on Linux. Naive programs (no optimized IO threads or aio) 
> on truly unbuffered devices tend to perform poorly because they
> don't do any write behind.

But the big question still is -- buffered or not -- where do the big 
variations within linux come frome? I am not writing small blocks. I write 
huge amounts of data. So the buffer will always be full. And: Linux is even 
slower then BSD if it can use a buffer. The maximum performance of Linux is 
42 MB/s (buffered) while the maximum performance of BSD is 48 MB/s (buffered 
or not -- i don't know).
If I use a normal SATA-II disk, there are no differences between BSD and Linux 
when writing to the raw device... So it cant be a buffer-problem alone.
> 
> It might also useful if you post the libata related parts of your
> boot log.

> > 
> > Question 2:
> > Can anybody explain to me, why writing to a solid state disk (a kind of 
> > memory  
> > that always has the same constant bandwidth) has such big standard errors 
> > in  
> > writing rate using Linux (between 1 to 6 MB/s error) while FreeBSD gives 
> > an  
> > almost constant writing rate (as one would expect it for a SSD) ?
> 
> Could be buffered vs unbuffered. Unbuffered single threaded writes
> tend to be quite variable.
This does not answer the big variation when writing with ext3 of +/- 5 MB/s.

I still don't understand the buffer argument. If one writes 25 GB in blocks of 
1 MB your buffer should be always full...
> 
> > Question 3:
> > Why is writing to a raw device in Linux slower than using e.g. ext2 ? And 
why 
> > is Linux writing rate much lower (-12.5 % for the best case) compared to 
> > writing rate of FreeBSD?
> 
> It's really hard to make raw io perform well without complicated
> efforts because nobody will hide the IO latencies. That is why
> buffered IO is normally recommend

Is there a buffered io device that I can use, but that does not use a 
filesystem?

> 
> -Andi
> 

-- 
Dipl. Physiker
Martin Anton Fink
Max Planck Institute for extraterrestrial Physics
Giessenbachstrasse
85741 Garching
Germany
Tel. +49-(0)89-30000-3645
Fax. +49-(0)89-30000-3569
