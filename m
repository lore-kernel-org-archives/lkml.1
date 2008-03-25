Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYCYXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYCYXNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbYCYXN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:13:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbYCYXN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:13:26 -0400
Message-ID: <47E98712.6090203@redhat.com>
Date: Tue, 25 Mar 2008 19:13:22 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home> <47E975F8.3000702@redhat.com> <47E98108.9000906@tmr.com>
In-Reply-To: <47E98108.9000906@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Chris Snook wrote:
>> Emmanuel Florac wrote:
>>> I post there because I couldn't find any information about this
>>> elsewhere : on the same hardware ( Athlon X2 3500+, 512MB RAM, 2x400 GB
>>> Hitachi SATA2 hard drives ) the 2.4 Linux software RAID-1 (tested 2.4.32
>>> and 2.4.36.2, slightly patched to recognize the hardware :p) is way
>>> faster than 2.6 ( tested 2.6.17.13, 2.6.18.8, 2.6.22.16, 2.6.24.3)
>>> especially for writes. I actually made the test on several different
>>> machines (same hard drives though) and it remained consistent across
>>> the board, with /mountpoint a software RAID-1.
>>> Actually checking disk activity with iostat or vmstat shows clearly a
>>> cache effect much more pronounced on 2.4 (i.e. writing goes on much
>>> longer in the background) but it doesn't really account for the
>>> difference. I've also tested it thru NFS from another machine (Giga
>>> ethernet network):
>>>
>>> dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024
>>>
>>> kernel        2.4       2.6        2.4 thru NFS   2.6 thru NFS
>>>
>>> write        90 MB/s    65 MB/s      70 MB/s       45 MB/s
>>> read         90 MB/s    80 MB/s      75 MB/s       65 MB/s
>>>
>>> Duh. That's terrible. Does it mean I should stick to  (heavily
>>> patched...) 2.4 for my file servers or... ? :)
>>>
>>
>> It means you shouldn't use dd as a benchmark.
>>
> What do you use as a benchmark for writing large sequential files or 
> reading them, and why is it better than dd at modeling programs which 
> read or write in a similar fashion?
> 
> Media programs often do data access in just this fashion, multi-channel 
> video capture, streaming video servers, and similar.
> 

dd uses unaligned stack-allocated buffers, and defaults to block sized I/O.  To 
call this inefficient is a gross understatement.  Modern applications which care 
about streaming I/O performance use large, aligned buffers which allow the 
kernel to efficiently optimize things, or they use direct I/O to do it 
themselves, or they make use of system calls like fadvise, madvise, splice, etc. 
that inform the kernel how they intend to use the data or pass the work off to 
the kernel completely.  dd is designed to be incredibly lightweight, so it works 
very well on a box with a 16 MHz CPU.  It was *not* designed to take advantage 
of the resources modern systems have available to enable scalability.

I suggest an application-oriented benchmark that resembles the application 
you'll actually be using.

-- Chris
