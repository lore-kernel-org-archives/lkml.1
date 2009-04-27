Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZD0Gfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZD0Gfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZD0GfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:35:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:54153 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbZD0GfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,253,1239001200"; 
   d="scan'208";a="685196824"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Apr 2009 07:35:16 +0100
Subject: RE: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Thread-Topic: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Thread-Index: AcnFcMsLz66t6PYjRlaJLKw9gwTeGgBkT29Q
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9BB0D3AA@irsmsx504.ger.corp.intel.com>
References: <20090424100055.A30408@sedona.ch.intel.com>
 <49F2B075.4090300@linux.intel.com>
In-Reply-To: <49F2B075.4090300@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Andi Kleen [mailto:ak@linux.intel.com]
>Sent: Saturday, April 25, 2009 8:41 AM
>To: Metzger, Markus T; Linux Kernel Mailing List
>Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
>
>Markus Metzger wrote:
>> Use vmalloc to allocate the branch trace buffer.
>>
>> Peter Zijlstra suggested to use vmalloc rather than kmalloc to
>> allocate the potentially multi-page branch trace buffer.
>>
>> Is there a way to have vmalloc allocate a physically non-contiguous
>> buffer for test purposes? Ideally, the memory area would have big
>> holes in it with sensitive data in between so I would know immediately
>> when this is overwritten.
>
>For test purposes you could hack vmalloc.c to allocate more pages
>and only put in every second/third/... into the mapping. You would
>just need to add another to loop to __vmalloc_area_node() that allocates
>more. That should give you non continuous mappings unless you're really unlucky.

Thanks.

I got enough feedback that the existing method is preferable to using vmalloc
that I dropped it again.

regards,
markus.


>
>-Andi
>
>
>>
>>
>> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
>> ---
>>  arch/x86/kernel/ptrace.c |    5 	3 +	2 -	0 !
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> Index: b/arch/x86/kernel/ptrace.c
>> ===================================================================
>> --- a/arch/x86/kernel/ptrace.c
>> +++ b/arch/x86/kernel/ptrace.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/seccomp.h>
>>  #include <linux/signal.h>
>>  #include <linux/workqueue.h>
>> +#include <linux/vmalloc.h>
>>
>>  #include <asm/uaccess.h>
>>  #include <asm/pgtable.h>
>> @@ -626,7 +627,7 @@ static int alloc_bts_buffer(struct bts_c
>>  	if (err < 0)
>>  		return err;
>>
>> -	buffer = kzalloc(size, GFP_KERNEL);
>> +	buffer = vmalloc(size);
>>  	if (!buffer)
>>  		goto out_refund;
>>
>> @@ -646,7 +647,7 @@ static inline void free_bts_buffer(struc
>>  	if (!context->buffer)
>>  		return;
>>
>> -	kfree(context->buffer);
>> +	vfree(context->buffer);
>>  	context->buffer = NULL;
>>
>>  	refund_locked_memory(context->mm, context->size);

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

