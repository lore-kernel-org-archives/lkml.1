Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbXEXRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbXEXRa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbXEXRaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:30:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40897 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXEXRaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:30:12 -0400
Message-ID: <4655CB92.90303@us.ibm.com>
Date: Thu, 24 May 2007 10:29:54 -0700
From: Vara Prasad <prasadav@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       systemtap <systemtap@sourceware.org>
Subject: Re: filesystem benchmarking fun
References: <20070516144205.GV26766@think.oraclecorp.com> <464B2AC2.10206@redhat.com> <20070516171156.GY26766@think.oraclecorp.com> <20070516112515.b6f247b2.akpm@linux-foundation.org> <20070516191339.GA26766@think.oraclecorp.com> <20070516123342.714a11d8.akpm@linux-foundation.org> <20070516195359.GE26766@think.oraclecorp.com> <20070516130413.1fd391bf.akpm@linux-foundation.org> <20070516201414.GF26766@think.oraclecorp.com> <20070516133726.0c68a65f.akpm@linux-foundation.org> <20070516210206.GH26766@think.oraclecorp.com>
In-Reply-To: <20070516210206.GH26766@think.oraclecorp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:

>On Wed, May 16, 2007 at 01:37:26PM -0700, Andrew Morton wrote:
>  
>
>>On Wed, 16 May 2007 16:14:14 -0400
>>Chris Mason <chris.mason@oracle.com> wrote:
>>
>>    
>>
>>>On Wed, May 16, 2007 at 01:04:13PM -0700, Andrew Morton wrote:
>>>      
>>>
>>>>>The good news is that if you let it run long enough, the times
>>>>>stabilize.  The bad news is:
>>>>>
>>>>>create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
>>>>>create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
>>>>>create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
>>>>>create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
>>>>>          
>>>>>
>>>>well hang on.  Doesn't this just mean that the first few runs were writing
>>>>into pagecache and the later ones were blocking due to dirty-memory limits?
>>>>
>>>>Or do you have a sync in there?
>>>>
>>>>        
>>>>
>>>There's no sync,  but if you watch vmstat you can clearly see the log
>>>flushes, even when the overall create times are 11MB/s.  vmstat goes
>>>30MB/s -> 4MB/s or less, then back up to 30MB/s.
>>>      
>>>
>>How do you know that it is a log flush rather than, say, pdflush
>>hitting the blockdev inode and doing a big seeky write?
>>    
>>
>
>I don't...it gets especially tricky because ext3_writepage starts
>a transaction, and so pdflush does hit the log flushing code too.
>
>So, in comes systemtap.  I instrumented submit_bh to look for seeks
>(defined as writes more than 16 blocks apart) when the process was
>inside __log_wait_for_space.  The probe is attached, it is _really_
>quick and dirty because I'm about to run out the door.
>
>Watching vmstat, every time the __log_wait_for_space hits lots of seeks,
>vmstat goes into the 2-4MB/s range.  Not a scientific match up, but
>here's some sample output:
>
>7824 ext3 done waiting for space total wrote 3155 blocks seeks 2241
>7827 ext3 done waiting for space total wrote 855 blocks seeks 598
>7827 ext3 done waiting for space total wrote 2547 blocks seeks 1759
>7653 ext3 done waiting for space total wrote 2273 blocks seeks 1609
>
>I also recorded the total size of each seek, 66% of them where 6000
>blocks or more.
>
>-chris
>
>  
>
>------------------------------------------------------------------------
>
>
>global in_process
>global writers
>global last
>global seeks
>
>probe kernel.function("__log_wait_for_space@fs/jbd/checkpoint.c") {
>    printf("%d ext3 waiting for space\n", pid())
>    p = pid()
>    writers[p] = 0
>    in_process[p] = 1
>    last[p] = 0
>    seeks[p] = 0
>}
>
>probe kernel.function("__log_wait_for_space@fs/jbd/checkpoint.c").return {
>    p = pid()
>    in_process[p] = 0
>    printf("%d ext3 done waiting for space total wrote %d blocks seeks %d\n", p,
>	  writers[p], seeks[p])
>}
>
>probe kernel.function("submit_bh") {
>    p = pid()
>    in_proc = in_process[p]
>    if (in_proc != 0) {
>	writers[p] += 1
>	block = $bh->b_blocknr
>	last_block = last[p]
>	diff = 0
>	if (last_block != 0) {
>	    if (last_block < block && block - last_block > 16) {
>		diff = block - last_block
>	    }
>	    if (last_block > block && last_block - block > 16) {
>		diff = last_block - block
>	    }
>	}
>	    
>	last[p] = block
>	if (diff != 0) {
>	    printf("seek log write pid %d last %d this %d diff %d\n",
>		       p, last_block, block, diff);
>	    seeks[p] += 1
>	}
>    }
>}
>  
>
Hi Chris,

I am glad to see SystemTap is helping you to get useful information for 
you to understand the behavior of the benchmark.
I am not a filesystem expert hence i have couple of questions.
1) From your usage of SystemTap for your benchmark work do you see a 
need to develop a generic tool that could be useful to understand 
general filesystem performance issues, if so please let us know the 
details of what you would like to see in that tool and we will be more 
than happy to help develop one.
2) Based on your usage of SystemTap do you have any suggestions on a 
probe library for filesystem that captures most of the essential 
information and state transitions in the filesystem for someone to 
understand performance/functionality of the filesystem. In other words i 
am looking for some help/advise from experts in the subsystem to 
identify probe points so we can develop a probe library that anyone can 
use to get more insight into that subsystem without being a guru in it. 
If you have any ideas in that please let us know.
3) Of course if you have any feedback on general SystemTap and its use 
and any suggestions for improvements, we would love to hear as well.

Thanks again for using SystemTap,
Vara Prasad

