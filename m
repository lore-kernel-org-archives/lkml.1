Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYGBVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYGBVeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbYGBVd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:33:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:39089 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbYGBVd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ghYppyWZEiDQlxsjVf8xPFyFSIGoJE44O/0xup/41QUiureSXIMphdbb2dtxgY0bju
         IT/uWbdNjS+JfvFfjQxoabHJa98/MR8+PmPg2EZPke1qwUQxqx/2qBSDH1xBzIh9Xxh8
         I5Plg0JxQNfsqT7R0/nEo24Cq0QiVdo6nTpQc=
Message-ID: <486BF426.9040907@gmail.com>
Date: Wed, 02 Jul 2008 16:33:26 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Sustrik <sustrik@fastmq.com>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com> <48692DC0.6060904@gmail.com> <486BB14D.5060609@fastmq.com>
In-Reply-To: <486BB14D.5060609@fastmq.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Sustrik wrote:
> Hi Roger,
> 
>>> Fair enough. That exaplains the behaviour. Would AIO help here? If we 
>>> are able to enqueue next write before the first one is finished, it 
>>> can start writing it immediately without waiting for a revolution.
>>
>> If you could get them queued at the disk level, things that would need 
>> to be watched were if the disk can queue things up (and all 
>> controllers/drivers support it), and how many things the disk can 
>> queue up, and how large each of those things can be, if they aren't 
>> queued at the disk, there is the chance that the machine cannot get 
>> the data to the disk faster enough for that next sector.
>>
>> I have always avoided fully sync operations as things *ALWAYS* got 
>> really really slow because of all of the requirements need to make 
>> sure that it always got the data to disk correctly on a unexpected 
>> crash, and typically the type of applications I dealt with, if the 
>> machine crashed the currently outputting data was known to be 
>> incomplete and generally useless, so things were reran.
>>
>> Depending on your application you could always get a small fast solid 
>> state device (no seek or RPM issues), and use it to keep a journal 
>> that could be replayed on an unexpected crash...and then just use 
>> various syncs to force things to disk at various points.
> 
> We've tried AIO and the results are quite disappointing. If you open the 
> file with O_SYNC, the latencies are the same as with sync I/O - each 
> write takes 8.3ms (7500rpm disk).
> 
> If you use O_ASYNC the latencies are nice (160us mean), however, the 
> first one is ~900us meaning that the data were not physically written to 
> the disk before AIO confirmation is sent. (Moving head to right position 
> would take much more than 900us.)
> 
> Still, my feeling is that our use case is pretty straightforward, i.e. 
> write data to the disk with any optimisations you are able to do and 
> notify me when the data are physically written to the medium.
> 
> Isn't there a way to achieve this kind of behaviour?
> 
> Martin
> 

A lot depends on what your application requirements are.

Back in a long time ago, before disks had cache RLL and MFM drives used a trick 
called interleave, instead of writing to sector n, n+1,n+2 with a interleave of 
2 would write to n,n+2,n+4 as once they got the message that n was written the 
machine had enough time to setup and send the next write to sector n+2 before 
the head got there, the question with your hardware would be how many sectors 
need to be skipped to be able to write immediately (and this would change with 
hardware changes-and the file would need to be pre-allocated, and may have to 
have some testing done against the given file to quantify the underlying disk 
reality-and reality may change if the disk reallocates sectors), and this 
assumes that can you live with the lower sequential read performance-interleave 
of 2 had 1/2 the read performance, interleave of 3 had 1/3, though with proper 
sector picking and the read cache on the disk, this interleave my not kill the 
read performance if one goes n,n+2,...,n+2*x,n+1,n+3,... correctly knowing that 
n+2*x and n+1 are close in seek time and I don't have any idea what sort of 
interleave one would need to be using with modern hardware.

It would take a fairly intricate program to sort out what reality was, but it 
would seem to be possible to figure out exactly what reality is, and work with 
it.   And the first seek might take a while, but even that could be played 
around with by having marker sectors be written to all of the time so one has 
some idea of what is going to be under the head real soon, of course even if you 
could get all of this correct there are still unknowns of the disk not always 
doing what one expects since they do have a mind of their own, and the unknown 
of can you get the correct sector supplied through everything to the disk fast 
enough every time.

                             Roger


