Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbZCaRh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbZCaRh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZCaRhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:37:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbZCaRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:37:44 -0400
Message-ID: <49D254E4.8050806@vlnb.net>
Date: Tue, 31 Mar 2009 21:37:40 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: iscsitarget-devel@lists.sourceforge.net,
       scst-devel <scst-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       stgt@vger.kernel.org
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT	data)
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net> <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
In-Reply-To: <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+WOMyIbkU806uYAf9Ol+NRTo09uxPzpIAZ+kR
 YzXoGZLpUuSO3/hdlwr2Vb67cv8SXT//9Th+c4tfJLcvQtjxsV
 GF0aEyFZmhmBuRip6gNBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche, on 03/30/2009 10:53 PM wrote:
> On Mon, Mar 30, 2009 at 8:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Bart Van Assche, on 03/30/2009 10:06 PM wrote:
>>> These are indeed interesting results. There are some aspects of the
>>> test setup I do not understand however:
>>> * All tests have been run with buffered I/O instead of direct I/O
>>> (iflag=direct / oflag=direct). My experience is that the results of
>>> tests with direct I/O are easier to reproduce (less variation between
>>> runs). So I have been wondering why the tests have been run with
>>> buffered I/O instead ?
>> Real applications use buffered I/O, hence it should be used in tests. It
>>  evaluates all the storage stack on both initiator and target as a whole.
>> The results are very reproducible, variation is about 10%.
> 
> Most applications do indeed use buffered I/O. Database software
> however often uses direct I/O. It might be interesting to publish
> performance results for both buffered I/O and direct I/O.

Yes, sure

> A quote from
> the paper "Asynchronous I/O Support in Linux 2.5" by Bhattacharya e.a.
> (Linux Symposium, Ottawa, 2003):
> 
> Direct I/O (raw and O_DIRECT) transfers data between a user buffer and
> a device without copying the data through the kernel’s buffer cache.
> This mechanism can boost performance if the data is unlikely to be
> used again in the short term (during a disk backup, for example), or
> for applications such as large database management systems that
> perform their own caching.

Please don't misread phrase "unlikely to be used again in the short 
term". If you have read-ahead, all your cached data is *likely* to be 
used "again" in the near future after they were read from storage, 
although only once in the first read by application. The same is true 
for write-back caching, where data written to the cache once for each 
command. Both read-ahead and write back are very important for good 
performance and O_DIRECT throws them away. All the modern HDDs have a 
memory buffer (cache) at least 2MB big on the cheapest ones. This cache 
is essential for performance, although how can it make any difference if 
the host computer has, say, 1000 times more memory?

Thus, to work effectively with O_DIRECT an application has to be very 
smart to workaround the lack of read-ahead and write back.

I personally consider O_DIRECT (as well as BLOCKIO) as nothing more than 
a workaround for possible flaws in the storage subsystem. If O_DIRECT 
works better, then in 99+% cases there is something in the storage 
subsystem, which should be fixed to perform better.

To be complete, there is one case where O_DIRECT and BLOCKIO have an 
advantage: both of them transfer data zero-copy. So they are good if 
your memory is too slow comparing to storage (InfiniBand case, for 
instance) and additional data copy hurts performance noticeably.

> Bart.
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

