Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYCZQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYCZQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYCZQlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:41:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153AbYCZQll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:41:41 -0400
Message-ID: <47EA7C3A.6020903@redhat.com>
Date: Wed, 26 Mar 2008 12:39:22 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home> <47E975F8.3000702@redhat.com> <47E98108.9000906@tmr.com> <47E98712.6090203@redhat.com> <47E98DE4.9000906@tmr.com>
In-Reply-To: <47E98DE4.9000906@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Chris Snook wrote:
>> Bill Davidsen wrote:
>>> Chris Snook wrote:
>>>> Emmanuel Florac wrote:
>>>>> I post there because I couldn't find any information about this
>>>>> elsewhere : on the same hardware ( Athlon X2 3500+, 512MB RAM, 
>>>>> 2x400 GB
>>>>> Hitachi SATA2 hard drives ) the 2.4 Linux software RAID-1 (tested 
>>>>> 2.4.32
>>>>> and 2.4.36.2, slightly patched to recognize the hardware :p) is way
>>>>> faster than 2.6 ( tested 2.6.17.13, 2.6.18.8, 2.6.22.16, 2.6.24.3)
>>>>> especially for writes. I actually made the test on several different
>>>>> machines (same hard drives though) and it remained consistent across
>>>>> the board, with /mountpoint a software RAID-1.
>>>>> Actually checking disk activity with iostat or vmstat shows clearly a
>>>>> cache effect much more pronounced on 2.4 (i.e. writing goes on much
>>>>> longer in the background) but it doesn't really account for the
>>>>> difference. I've also tested it thru NFS from another machine (Giga
>>>>> ethernet network):
>>>>>
>>>>> dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024
>>>>>
>>>>> kernel        2.4       2.6        2.4 thru NFS   2.6 thru NFS
>>>>>
>>>>> write        90 MB/s    65 MB/s      70 MB/s       45 MB/s
>>>>> read         90 MB/s    80 MB/s      75 MB/s       65 MB/s
>>>>>
>>>>> Duh. That's terrible. Does it mean I should stick to  (heavily
>>>>> patched...) 2.4 for my file servers or... ? :)
>>>>>
>>>>
>>>> It means you shouldn't use dd as a benchmark.
>>>>
>>> What do you use as a benchmark for writing large sequential files or 
>>> reading them, and why is it better than dd at modeling programs which 
>>> read or write in a similar fashion?
>>>
>>> Media programs often do data access in just this fashion, 
>>> multi-channel video capture, streaming video servers, and similar.
>>>
>>
>> dd uses unaligned stack-allocated buffers, and defaults to block sized 
>> I/O.  To call this inefficient is a gross understatement.  Modern 
>> applications which care about streaming I/O performance use large, 
>> aligned buffers which allow the kernel to efficiently optimize things, 
>> or they use direct I/O to do it themselves, or they make use of system 
>> calls like fadvise, madvise, splice, etc. that inform the kernel how 
>> they intend to use the data or pass the work off to the kernel 
>> completely.  dd is designed to be incredibly lightweight, so it works 
>> very well on a box with a 16 MHz CPU.  It was *not* designed to take 
>> advantage of the resources modern systems have available to enable 
>> scalability.
>>
> dd has been capable of doing direct io for years, so I assume it can 
> emulate that behavior if it is appropriate to do so, and the buffer size 
> can be set as needed. I'm less sure that large buffers are allocated on 
> the stack, but often the behavior of the application models is the small 
> buffered writes dd would do by default.
>> I suggest an application-oriented benchmark that resembles the 
>> application you'll actually be using.
> 
> And this is what I was saying earlier, there is a trend to blame the 
> benchmark when in fact the same benchmark runs well on 2.4. Rather than 
> replacing the application or benchmark, perhaps the *regression* could 
> be fixed in the kernel. With all the mods and queued i/o and everything, 
> the performance is still going down.
> 

2.6 has been designed to scale, and scale it does.  The cost is added 
overhead for naively designed applications, which dd is quite 
intentionally.  Simply enabling direct I/O in dd accomplishes nothing if 
the I/O patterns you're instructing it to perform are not optimized.  If 
I/O performance is important to you, you really need to optimize your 
application or tune your kernel for I/O performance.

If you have a performance-critical application that is designed in a 
manner such that a naive dd invocation is an accurate benchmark for it, 
you should file a bug with the developer of that application.

I've long since lost count of the number of times that I've seen 
optimizing for dd absolutely killed real application performance.

-- Chris
