Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZIUAVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZIUAVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 20:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZIUAVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 20:21:53 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:48433 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZIUAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 20:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mPyPrLWf5lfvxHcentwr4VyCvmMALrspOdo6L6QAPskUX9SqbncvDgPfHJ3nW8hE6M
         JAJmG8khP6avvt5T9iF/ibs61MVE5JvGWPwgQohyeAE/4MPuQQVvt3Z6zwxWJWWs9Cx/
         bni6ZvneHrSbjyDyjzu4FqaaL3dpVFV1H8Hio=
Message-ID: <4AB6C73C.1030004@gmail.com>
Date: Sun, 20 Sep 2009 17:22:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <4AB59CBB.8090907@datenparkplatz.de>	 <20090920080728.73bfe2a1@infradead.org>	 <4AB5ECD0.7010903@datenparkplatz.de> <1253475521.9224.43.camel@marge.simson.net>
In-Reply-To: <1253475521.9224.43.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sun, 2009-09-20 at 10:50 +0200, Ulrich Lukas wrote:
>    
>> Arjan van de Ven wrote:
>>      
>>> can you try the following two things?
>>>
>>> echo 4096>  /sys/block/sda/queue/nr_requests
>>> for i in `pidof kjournald` ; do ionice -c1 -p $i ; done
>>>        
>> I tried this just now, but it doesn't change things much. I can do a
>> more testing later today.
>>      
>
> Try ionice -c3 for your dd.
>
>    
>>> I assume you're using CFQ.
>>>        
>> Yes, it's CFQ. (see .config of my previous posting)
>>
>> Filesystem is EXT4.
>>      
>
> Mine is ext3.
>
> I can easily reproduce pain.  The attached cheezy test script, when run
> back to back with no args (stock IO), regularly produces beauties:
>
>   Performance counter stats for 'sh -c konsole -e exit':
>
>       257.670601  task-clock-msecs         #      0.004 CPUs
>             1036  context-switches         #      0.004 M/sec
>               30  CPU-migrations           #      0.000 M/sec
>             6317  page-faults              #      0.025 M/sec
>        471734719  cycles                   #   1830.767 M/sec
>        393365060  instructions             #      0.834 IPC
>          7849464  cache-references         #     30.463 M/sec
>          1038976  cache-misses             #      4.032 M/sec
>
>     65.766937233  seconds time elapsed
>
> Yup, a full minute to get a binary loaded and fired up.  Seems it and
> others get evicted by the VM.  Getting whatever back into ram is painful
> to listen to (poor disk/me.. seek latency eating MUCH time).
>
> Calling script back to back with args 1 (realtime foreground) 3 (idle
> background) does best:
>
>   Performance counter stats for 'sh -c konsole -e exit':
>
>       169.915036  task-clock-msecs         #      0.077 CPUs
>              439  context-switches         #      0.003 M/sec
>                9  CPU-migrations           #      0.000 M/sec
>             6314  page-faults              #      0.037 M/sec
>        363128252  cycles                   #   2137.117 M/sec
>        367410945  instructions             #      1.012 IPC
>          5822302  cache-references         #     34.266 M/sec
>           437189  cache-misses             #      2.573 M/sec
>
>      2.213079979  seconds time elapsed
>
> Args 2 (best effort foreground) and 3 (idle background);
>
>   Performance counter stats for 'sh -c konsole -e exit':
>
>       176.689856  task-clock-msecs         #      0.015 CPUs
>              357  context-switches         #      0.002 M/sec
>               15  CPU-migrations           #      0.000 M/sec
>             6314  page-faults              #      0.036 M/sec
>        374861947  cycles                   #   2121.582 M/sec
>        368929476  instructions             #      0.984 IPC
>          5806286  cache-references         #     32.861 M/sec
>           496651  cache-misses             #      2.811 M/sec
>
>     12.036165968  seconds time elapsed
>
> 	-Mike
>    
Wow, at first I did not notice anything
from your *.sh script, but then a few moments
later, the system became vary sluggish. firefox
takes about 15 seconds to load. OS is mint linux
with the latest HEAD on an imac9,1.

Justin P. Mattock
