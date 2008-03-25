Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbYCYXlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbYCYXlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbYCYXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:41:46 -0400
Received: from mail.tmr.com ([64.65.253.246]:49472 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbYCYXlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:41:45 -0400
Message-ID: <47E98DE4.9000906@tmr.com>
Date: Tue, 25 Mar 2008 19:42:28 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home> <47E975F8.3000702@redhat.com> <47E98108.9000906@tmr.com> <47E98712.6090203@redhat.com>
In-Reply-To: <47E98712.6090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Bill Davidsen wrote:
>> Chris Snook wrote:
>>> Emmanuel Florac wrote:
>>>> I post there because I couldn't find any information about this
>>>> elsewhere : on the same hardware ( Athlon X2 3500+, 512MB RAM, 
>>>> 2x400 GB
>>>> Hitachi SATA2 hard drives ) the 2.4 Linux software RAID-1 (tested 
>>>> 2.4.32
>>>> and 2.4.36.2, slightly patched to recognize the hardware :p) is way
>>>> faster than 2.6 ( tested 2.6.17.13, 2.6.18.8, 2.6.22.16, 2.6.24.3)
>>>> especially for writes. I actually made the test on several different
>>>> machines (same hard drives though) and it remained consistent across
>>>> the board, with /mountpoint a software RAID-1.
>>>> Actually checking disk activity with iostat or vmstat shows clearly a
>>>> cache effect much more pronounced on 2.4 (i.e. writing goes on much
>>>> longer in the background) but it doesn't really account for the
>>>> difference. I've also tested it thru NFS from another machine (Giga
>>>> ethernet network):
>>>>
>>>> dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024
>>>>
>>>> kernel        2.4       2.6        2.4 thru NFS   2.6 thru NFS
>>>>
>>>> write        90 MB/s    65 MB/s      70 MB/s       45 MB/s
>>>> read         90 MB/s    80 MB/s      75 MB/s       65 MB/s
>>>>
>>>> Duh. That's terrible. Does it mean I should stick to  (heavily
>>>> patched...) 2.4 for my file servers or... ? :)
>>>>
>>>
>>> It means you shouldn't use dd as a benchmark.
>>>
>> What do you use as a benchmark for writing large sequential files or 
>> reading them, and why is it better than dd at modeling programs which 
>> read or write in a similar fashion?
>>
>> Media programs often do data access in just this fashion, 
>> multi-channel video capture, streaming video servers, and similar.
>>
>
> dd uses unaligned stack-allocated buffers, and defaults to block sized 
> I/O.  To call this inefficient is a gross understatement.  Modern 
> applications which care about streaming I/O performance use large, 
> aligned buffers which allow the kernel to efficiently optimize things, 
> or they use direct I/O to do it themselves, or they make use of system 
> calls like fadvise, madvise, splice, etc. that inform the kernel how 
> they intend to use the data or pass the work off to the kernel 
> completely.  dd is designed to be incredibly lightweight, so it works 
> very well on a box with a 16 MHz CPU.  It was *not* designed to take 
> advantage of the resources modern systems have available to enable 
> scalability.
>
dd has been capable of doing direct io for years, so I assume it can 
emulate that behavior if it is appropriate to do so, and the buffer size 
can be set as needed. I'm less sure that large buffers are allocated on 
the stack, but often the behavior of the application models is the small 
buffered writes dd would do by default.
> I suggest an application-oriented benchmark that resembles the 
> application you'll actually be using.

And this is what I was saying earlier, there is a trend to blame the 
benchmark when in fact the same benchmark runs well on 2.4. Rather than 
replacing the application or benchmark, perhaps the *regression* could 
be fixed in the kernel. With all the mods and queued i/o and everything, 
the performance is still going down.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


