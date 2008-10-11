Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYJKI3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYJKI3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYJKI2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:28:53 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:52823 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYJKI2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:28:51 -0400
Message-ID: <48F063C5.3000707@motion-twin.com>
Date: Sat, 11 Oct 2008 10:28:53 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: recv() hangs until SIGCHLD ?
References: <48EF58D9.6060401@motion-twin.com> <20081010211700.58e953a2@speedy>
In-Reply-To: <20081010211700.58e953a2@speedy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> We run a multithread application which is using pthreads and sockets. A 
>> thread uses accept() then dispatch the socket to one of the workers 
>> threads that process it. Sockets are then not used simultaneously by 
>> several threads.
>>
>> In some rare cases, one (or several) threads are hanging in recv(). Both 
>> lsof and ls /proc/<pid>/fd show that the socket used is in ESTABLISHED 
>> mode but when checking on the host on which it's connected (a mysql DB) 
>> we can't find the corresponding client socket (as it's been closed 
>> already on the other side).
>>
>> We are using the Boehm GC which uses the signals SIGXCPU and SIGPWR to 
>> pause+restart the threads when running a GC cycle. We are correctly 
>> handling EINTR in send() and recv() by restarting the call in case they 
>> get interrupted this way.
>>
>> However, when attaching GDB to our locked thread it seems that even when 
>> the GC runs, recv() does not exit (the breakpoint after it is not 
>> reached). If we send SIGCHLD to the hanging thread with GDB, recv() does 
>> exit and the thread is correctly unlocked. If we don't, it will hang 
>> forever.
>>
>> Additional details : recv() is using MSG_NOSIGNAL and we have enabled 
>> TCP_NODELAY on the socket by using setsockopt. Some other 
>> not-multithreaded apps are using the same Databases and this behavior 
>> does not occur for them.
>>
>> Any idea how we can stop this from happening or what additional things 
>> we can check to get more informations on what's occurring ?
>>
>> Thanks a lot,
>> Nicolas
> 
> Look at Receive queue length with ss or netstat for the hung thread. It will
> show if there is anything that thread could read.
> 
> If there is data and the thread didn't wake up then that is a libc or kernel problem;
> but if there is no data, then look for cases where earlier interrupted io actually
> consumed the data already or blame the sending process not the receiver.
> Also are the sockets blocking or non-blocking?

The sockets are non-blocking.

Checking with netstat and ss I can confirm that both Send and Recv 
queues are empty, which makes the recv() behavior consistent.

However since this problem does not occur without threads, we can be 
sure that the blame is still on the receiver.

In a practical case, we have a thread blocked in recv() for more than 12 
hours, which is way beyond the timeout of the sender connection. The 
socket has already been closed by the sender so recv() should at least 
be noticed and returns 0.

Is it safe to assume that when either send() or recv() get interrupted 
by a signal and returns EINTR, no actual data has been either sent or 
consumed ? And if it's not, is there any other way around this ?

Best,
Nicolas

