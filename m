Return-Path: <linux-kernel-owner+w=401wt.eu-S965338AbXIGPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbXIGPMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbXIGPMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:12:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45158 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbXIGPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:12:36 -0400
Message-ID: <46E16BAB.4000404@bull.net>
Date: Fri, 07 Sep 2007 17:18:03 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into IDRs
References: <20070831112445.976429000@bull.net>	<20070831112613.552219000@bull.net> <p73tzqevxue.fsf@bingen.suse.de> <46DFC964.9090008@bull.net>
In-Reply-To: <46DFC964.9090008@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/09/2007 17:18:10,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/09/2007 17:18:12,
	Serialize complete at 07/09/2007 17:18:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> Andi Kleen wrote:
> 
>> Nadia.Derbey@bull.net writes:
>>
>>
>>> This patch introduces ipcs storage into IDRs. The main changes are:
>>>  . This ipc_ids structure is changed: the entries array is changed 
>>> into a
>>>    root idr structure.
>>>  . The grow_ary() routine is removed: it is not needed anymore when 
>>> adding
>>>    an ipc structure, since we are now using the IDR facility.
>>>  . The ipc_rmid() routine interface is changed:
>>>       . there is no need for this routine to return the pointer 
>>> passed in as
>>>         argument: it is now declared as a void
>>>       . since the id is now part of the kern_ipc_perm structure, no 
>>> need to
>>>         have it as an argument to the routine
>>>
>>
>>
>> Thanks for doing this work. It was long overdue.
>>
>> Do you have any data how this changes memory consumption with many 
>> objects?
>> -Andi
>>
> 
> Andi,
> 
> Here are the results I got when creating 32768 (IPCMNI) msg queues with 
> the patched kernel:
> 
> http://akt.sourceforge.net/results/2.6.23-rc2-idr/msg11/output.new
> 
> It's the output from msg11.c. This script does what follows:
>     . gets sysinfo(2) results
>     . captures /proc/meminfo
>     . captures /proc/slabinfo
>     . creates XX msg queues (XX given as parameter)
>     . captures /proc/meminfo
>     . captures /proc/slabinfo
>     . gets sysinfo results
>     . outputs all the results
>     . removes the created ipcs
> 
> sysinfo results: a BEFORE and an AFTER column are output where necessary.
> BEFORE means "before creating the objects"
> AFTER means "after the objects have been created"
> 
> meminfo results: the BEFORE and AFTER files are pasted
> 
> slabinfo results: only the differences between the BEFORE and the AFTER 
> are output.
> 
> 
> Here are also the sizes for the ref and the patched kernel:
> 
> size linux-2.6.23-rc2.ref/vmlinux linux-2.6.23-rc2/vmlinux
>    text    data     bss     dec     hex filename
> 4432697  496450  602112 5531259  54667b linux-2.6.23-rc2.ref/vmlinux
> 4430747  496450  602112 5529309  545edd linux-2.6.23-rc2/vmlinux
> 
> 
> 
> The http://akt.sourceforge.net/results/2.6.23-rc2-idr/msg11 directory is 
> structured as follows:
> 
> msg11.c: the script I used to generate the results
> output.ref: the output from msg11 with the ref kernel
> output.new: the output from msg11 with the patched kernel
> size: the output from the size command
> ref: directory with the results files for the ref kernel
> new: directory with the results files for the patched kernel
> In these 2 directories:
> *_mem_*before: /proc/meminfo before creating the msg queues
> *_mem_*after: /proc/meminfo after creating the msg queues
> *_slab_*before: /proc/slabinfo before creating the msg queues
> *_slab_*after: /proc/slabinfo after creating the msg queues
> 

Andi,

Here is an annalysis of the results I sent you yesterday (I guess you 
don't have enoguh time to look at everything):

ref code:

1) since /proc/sys/kernel/msgmni has been set to 32768, vmalloc(0x20014) 
is called to allocate the entries[] array (see grow_ary() --> 
ipc_rcu_alloc()).

==>

Before msg queues allocation:  VmallocUsed = 2860 kB
After msg queues allocation:   VmallocUsed = 2996 KB

Once allocated this array is never freed.

Unfortunately, in the result I sent you yesterday, you can't see the 
evolution since it was not the 1st time I was running the test, so the 
vmalloc() has not been called.


2) Since 32768 msg queues have been created and a msg_queue structure <
PAGE_SIZE, kmalloc(0x6C) is called 32768 times

==> size-128 in slabinfo: (I slighty simplified the output to make it 
fit in the mail):

                               objs          slabs
          # name   <active>  <num> <size> : <active> <num>
before : size-128     1070   1320    128 :       44    44
after  : size-128    33840  33840    128 :     1128  1128


patched code:
1) since 32768 msg queues are created, idr_pre_get() is called 32768 times
==> idr_layer_cache in slabinfo:

                                         objs          slabs
          # name           <active>  <num> <size> : <active> <num>
before : idr_layer_cache       112    116    136 :        4     4
after  : idr_layer_cache      1189   1189    136 :       41    41

2) This point remains unchanged compared to the ref code.



Regards,
Nadia
