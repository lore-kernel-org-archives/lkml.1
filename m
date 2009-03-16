Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbZCPNnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbZCPNnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZCPNnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:43:40 -0400
Received: from mail122.emailantidote.com ([80.169.59.122]:55148 "EHLO
	SC-MTA-03.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbZCPNnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:43:40 -0400
Message-ID: <49BE4DCB.1000705@draigBrady.com>
Date: Mon, 16 Mar 2009 13:02:03 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Alexey Fisher <bug-track@fisher-privat.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
References: <49BD1EB7.6080109@fisher-privat.net>
In-Reply-To: <49BD1EB7.6080109@fisher-privat.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Mar 2009 13:43:31.0344 (UTC) FILETIME=[31AD8100:01C9A63D]
x-MXSweep-KeywordsCount: 0
x-MXSweep-MetaScanResult: Clean
x-MXSweep-MetaScanThreat: 
x-MXSweep-VirusScanned: OK
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
x-MXSweep-Threat: Clean
X-MXUniqueID: 5425717f-2d8c-4879-a7f6-81e9609aff9b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher wrote:
> Hallo all.
> I found for my self how great is cache in linux. If read one file from
> disk, so i don't need to do it second time, chace will do the job. It
> speed up thing greatly. But i found it not working with realy big files.
> Like i have 4GB RAM, so if i read a file like 4.6GB, cache won't work.
> Is it possible to have some sort of smart cache wich will read for
> exaplme 1GB from disk and other part from cache?
> 
> here is some simple test:
> =====================cache not working==========================
> dd if=dvd.iso of=/dev/null
> 9017680+0 Datensätze ein
> 9017680+0 Datensätze aus
> 4617052160 Bytes (4,6 GB) kopiert, 90,7817 s, *50,9 MB/s*
> 
> dd if=dvd.iso of=/dev/null
> 9017680+0 Datensätze ein
> 9017680+0 Datensätze aus
> 4617052160 Bytes (4,6 GB) kopiert, 90,7817 s, *50,9 MB/s*
> ===============================================================

Right. The cache is being cycled.
I.E. the block you want is never in the cache
as it has previously clobbered be data your reading in.
That's just a consequence of preferring to cache blocks
you have recently read from file, over older blocks.
This is usually the right thing to do, but exactly
the wrong thing to do in your case.

So you would need to provide more info to the
kernel for it to behave as you want.
I.E. never evict a block belonging to the same file
as the block you're trying to insert.

I wonder should posix_fadvise(...POSIX_FADV_SEQUENTIAL)
do what you want. I don't think it does at present.
Note dd doesn't use posix_fadvise() yet, and it probably
should (at least for POSIX_FADV_DONTNEED).
Pity there is no interface like Robert Love's old O_STREAM
patch to just specify the intent for an fd rather than
worrying about ranges.

cheers,
Pádraig.

