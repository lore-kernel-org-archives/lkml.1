Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0BIGXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:23:44 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:45698 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0BIGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:23:43 -0500
Message-ID: <4B70FF66.7020602@linux.vnet.ibm.com>
Date: Tue, 09 Feb 2010 07:23:34 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, npiggin@suse.de
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie>
In-Reply-To: <20100208152131.GC23680@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman wrote:
> On Mon, Feb 08, 2010 at 03:01:16PM +0100, Christian Ehrhardt wrote:
>>
>> Mel Gorman wrote:
>>> On Fri, Feb 05, 2010 at 04:51:10PM +0100, Christian Ehrhardt wrote:
>>>   
>>>> I'll keep the old thread below as reference.
>>>>
>>>> After taking a round of ensuring reproducibility and a pile of new   
>>>> measurements I now can come back with several new insights.
>>>>
>>>> FYI - I'm now running iozone triplets (4, then 8, then 16 parallel   
>>>> threads) with sequential read load and all that 4 times to find   
>>>> potential noise. But since I changed to that load instead of random 
>>>> read  wit hone thread and ensuring the most memory is cleared (sync + 
>>>> echo 3 >  /proc/sys/vm/drop_caches + a few sleeps) . The noise is now 
>>>> down <2%.  For detailed questions about the setup feel free to ask me 
>>>> directly as I  won't flood this thread too much with such details.
>>>>
>>>>     
>>> Is there any chance you have a driver script for the test that you could send
>>> me? I'll then try reproducing based on that script and see what happens. I'm
>>> not optimistic I'll be able to reproduce the problem because I think
>>> it's specific to your setup but you never know.
>>>   
>> I don't have one as it runs in a bigger automated test environment, but  
>> it is easy enough to write down something comparable.
> 
> I'd appreciate it, thanks.
> 

Testing of your two patches starts in a few minutes, thanks in advance.

Here the info how to execute the core of the test - I cross fingers that anyone else can reproduce it that way :-)

I use it in a huge automation framework which takes care of setting up the system, disks, gathering statistics and so on, but it essentially comes down to something simple like that:

#!/bin/bash
# reboot your system with 256m
# attach 16 disks (usually up to 64, but 16 should be enough to show the issue)
# mount your disks at /mnt/subw0, /mnt/subw1, ...
for i in 4 8 16 4 8 16 4 8 16 4 8 16
do
        sync; sleep 10s; echo 3 > /proc/sys/vm/drop_caches; sleep 2s;
        iozone -s 2000m -r 64k -t $i  -e -w -R -C  -i 0 -F /mnt/subw0 /mnt/subw1 /mnt/subw2 /mnt/subw3 /mnt/subw4 /mnt/subw5 /mnt/subw6 /mnt/subw7 /mnt/subw8 /mnt/subw9 /mnt/subw10 /mnt/subw11 /mnt/subw12 /mnt/subw13 /mnt/subw14 /mnt/subw15
        sync; sleep 10s; echo 3 > /proc/sys/vm/drop_caches; sleep 2s;
        iozone -s 2000m -r 64k -t $i  -e -w -R -C  -i 1 -F /mnt/subw0 /mnt/subw1 /mnt/subw2 /mnt/subw3 /mnt/subw4 /mnt/subw5 /mnt/subw6 /mnt/subw7 /mnt/subw8 /mnt/subw9 /mnt/subw10 /mnt/subw11 /mnt/subw12 /mnt/subw13 /mnt/subw14 /mnt/subw15
done
# while we could reduce the number of writes to one 16 thread write I use it that way as it is more similar to our original load (makes no difference anyway)

[...]
-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 
