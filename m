Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYGATK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYGATK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYGATKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:10:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35617 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYGATKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:10:49 -0400
Message-ID: <486A8133.4090509@us.ibm.com>
Date: Tue, 01 Jul 2008 14:10:43 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Roel Kluin <12o3l@tiscali.nl>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>, Carl Love <cel@us.ibm.com>,
       Bob Nelson <rrnelson@linux.vnet.ibm.com>
Subject: Re: [PATCH] oprofile: vma_map: fix test on overlay_tbl_offset
References: <48074F18.7050802@tiscali.nl> <480F3BB0.9080507@us.ibm.com> <200807011601.21540.arnd@arndb.de>
In-Reply-To: <200807011601.21540.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 23 April 2008, Maynard Johnson wrote:
>   
>> Roel Kluin wrote:
>>     
>>> Offset is unsigned and when an address isn't found in the vma map
>>> vma_map_lookup() returns the vma physical address + 0x10000000.
>>>
>>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>>>   
>>>       
>> Patch looks correct.  vma_map_lookup used to return 0xffffffff on a 
>> failed lookup, but a change was recently made to return the vma physical 
>> address + 0x10000000 (as Roel notes above).  There are two callers of 
>> vam_map_lookup: one of them correctly deals with this new return value, 
>> but the other (below) did not.  Roel's patch fixes that hole.  Thanks!
>>
>> Arnd, can you put this into the Cell tree for pushing upstream?  Thanks.
>>     
>
> Sorry for not having looked at this earlier. I'm now queuing up patches
> for 2.6.27, but this one looks incorrect:
>
>   
>>> diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
>>> index 9a93217..1c28e2e 100644
>>> --- a/arch/powerpc/oprofile/cell/vma_map.c
>>> +++ b/arch/powerpc/oprofile/cell/vma_map.c
>>> @@ -229,7 +229,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
>>>  	 */
>>>  	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
>>>  					    aSpu, &grd_val);
>>> -	if (overlay_tbl_offset < 0) {
>>> +	if (overlay_tbl_offset >= 0x10000000) {
>>>  		printk(KERN_ERR "SPU_PROF: "
>>>  		       "%s, line %d: Error finding SPU overlay table\n",
>>>  		       __FUNCTION__, __LINE__);
>>>
>>>       
>
> You mention that the kernel can handle the return code correctly, but
> this code still prints an error message in that case, which does not
> make sense then.
>   
The above patch is actually correct.  There are two places that call the
vma_map_lookup function.  The above invocation is being done during
initial parsing of the SPU binary, and here, we expect to find the
offset for the overlay table symbol at a valid VMA.  Any value greater
than the physical size of SPE memory (0x10000000) is considered an error
here.  In the other invocation of vma_map_lookup (in spu_task_sync.c),
we're looking up the fileoffset for a sampled instruction address.  In
this case, a return value of greater than 0x10000000 is interpreted as a
sample taken from the __send_to_ppe call stub that is dynamically
generated and placed on the SPU stack
> Also, where does the 0x10000000 number come from? Is that the maximum
>   
See above.

Thanks.
-Maynard
> size that all overlays can consume in one binary?
>
> 	Arnd <><
>   


