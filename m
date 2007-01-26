Return-Path: <linux-kernel-owner+w=401wt.eu-S1030705AbXAZO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030705AbXAZO5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030719AbXAZO5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:57:47 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:53056 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030705AbXAZO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:57:46 -0500
Message-ID: <45BA1638.8010303@joow.be>
Date: Fri, 26 Jan 2007 15:54:48 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Robert Crocombe <rcrocomb@gmail.com>
CC: linux1394-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: In-tree version of new FireWire drivers available
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>	<45B75FDB.1000004@joow.be>	<59ad55d30701241245l7671af23w3e19a83621c6fb51@mail.gmail.com>	<45B88088.4020505@joow.be> <e6babb600701260507m51674894r5884f9a7fafa4f84@mail.gmail.com>
In-Reply-To: <e6babb600701260507m51674894r5884f9a7fafa4f84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: oola 20001; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Crocombe wrote:
> On 1/25/07, Pieter Palmers <pieterp@joow.be> wrote:
>> I'd like to make one note here:
>> We should have a way to use smaller DMA buffers than one page size. If I
>> remember correctly, the page size on my system is 4096 bytes, being 1024
>> quadlets. If we assume a 4 channel audio stream, this corresponds to 256
>> audio samples. This means that the controller generates an interrupt
>> every 256 samples, making that we can achieve a latency of 512 samples
>> at best. This is unacceptable in a pro-audio environment.
>>
>> The current stack exhibits this problem, and I solve it by recalculating
>> the max packet size, based upon the stream composition (i.e. expected
>> packet size) and the requested audio buffer size, such that the
>> interrupts are generated at a high enough frequency.
>>
>> I'm not a kernel hacker, but when looking through the code I had the
>> impression that smaller DMA buffers were possible (aren't smaller
>> buffers used in packet-per-buffer mode?).
> 
> I am using isochronous receive in RAW1394_DMA_PACKET_PER_BUFFER mode
> because I am closing a simulation loop around the data that is
> received/transmitted.  Just for giggles I cranked up a test
> isochronous stream from a bus analyzer at 1kB per packet at 8kHz at
> the S400 rate (i.e., one packet on each cycle start: 8MBps ), set the
> machine up to listen, and was able to maintain 8kHz interrupts at ~12%
> CPU utilization on a 2.8GHz Opteron.
> 
>    1744719 interrupts int 218.112 seconds is 7999.193 ints/sec
> 
> I wasn't doing anything with the data for this test, but I have had
> the aforementioned sim running steady at a somewhat lower rate.  This
> test ran under 2.6.20-rc5-rt10, but the more "productiony" system is
> on 2.6.16-rt29.
> 
> So hopefully you can get markedly lower latencies.  Myself, I'm
> tickled pink by the performance that can be achieved.
> 
I don't really understand what you are trying to say here. The overhead
of running in RAW1394_DMA_PACKET_PER_BUFFER mode is only acceptable for
very small buffer sizes. Usually one packet consists of 8 to 32 frames
(depending on the framerate of the stream), a frame being one sample of
all audio channels.

Currently I prefer about 4 interrupts per period, as we need some slack
to cope with the variable amount of no-data packets. So the
RAW1394_DMA_PACKET_PER_BUFFER mode is needed only for buffer sizes of 32
frames (assuming 8 frames per packet). Higher buffer sizes should use
another mode, because otherwise we're burning CPU cycles for no good
reason (12% cpu load is a little too high for me). The most frequently
used buffer sizes are around 128 frames, so that would mean 16
interrupts per period (4 times too much).

The way I currently solve this is by using the BUFFERFILL mode, but I 
inform the kernel that I expect packets that are larger than what I will 
effectively receive. If you specify a max_packet_size of 4096/4 bytes, 
every 4 packets the DMA buffer will be full and an interrupt will be 
generated. Internally it's called buff_stride if I'm not mistaking.

But again, what exactly is your point in this message?

Pieter



