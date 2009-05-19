Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZESVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZESVxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZESVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:53:45 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:55891 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751361AbZESVxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:53:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] mm/slub.c: change printk()s to pr_*() notation
Date: Tue, 19 May 2009 17:53:43 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909017FED77@mi8nycmail19.Mi8.com>
In-Reply-To: <1242766446.28224.31.camel@Joe-Laptop.home>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/slub.c: change printk()s to pr_*() notation
Thread-Index: AcnYw/TWOibBvDNPRYGz4X90KVnHPgABqPcg
References: <200905191103.03749.hartleys@visionengravers.com> <1242766446.28224.31.camel@Joe-Laptop.home>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Joe Perches" <joe@perches.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 May 2009 21:53:44.0856 (UTC) FILETIME=[47EF4180:01C9D8CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 19, 2009 1:54 PM, Joe Perches wrote:
> On Tue, 2009-05-19 at 11:03 -0700, H Hartley Sweeten wrote:
>> Change all the printk()s in mm/slub.c to the pr_*() notation.
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 65ffda5..2805b7f 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -338,25 +338,25 @@ static void print_section(char *text, u8 *addr, unsigned int length)
>>  
>>  	for (i = 0; i < length; i++) {
>>  		if (newline) {
>> -			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
>> +			pr_err("%8s 0x%p: ", text, addr + i);
>>  			newline = 0;
>>  		}
>> -		printk(KERN_CONT " %02x", addr[i]);
>> +		pr_cont(" %02x", addr[i]);
>>  		offset = i % 16;
>>  		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
>>  		if (offset == 15) {
>> -			printk(KERN_CONT " %s\n", ascii);
>> +			pr_cont(" %s\n", ascii);
>>  			newline = 1;
>>  		}
>>  	}
>>  	if (!newline) {
>>  		i %= 16;
>>  		while (i < 16) {
>> -			printk(KERN_CONT "   ");
>> +			pr_cont("   ");
>>  			ascii[i] = ' ';
>>  			i++;
>>  		}
>> -		printk(KERN_CONT " %s\n", ascii);
>> +		pr_cont(" %s\n", ascii);
>>  	}
>>  }
>
> Perhaps this should be changed to print_hex_dump.

It does appear that could be changed to print_hex_dump, but it wasn't
the intent of this patch. It looks like the equivalent print_hex_dump
call would be:

static void print_section(char *text, u8 *addr, unsigned int length)
{
	print_hex_dump(KERN_ERR, text, DUMP_PREFIX_ADDRESS, 16, 1, addr, len, 1);
}

> For the other changes, it might be useful to avoid
> having string constants span multiple lines and
> to align multi-line statements on the column after an
> open parenthesis.  Statements that fit on a single
> 80 character line should be on a single line.
>
> Some examples:
>
>> @@ -416,7 +416,7 @@ static void print_tracking(struct kmem_cache *s, void *object)
>>  
>>  static void print_page_info(struct page *page)
>>  {
>> -	printk(KERN_ERR "INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
>> +	pr_err("INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
>>  		page, page->objects, page->inuse, page->freelist, page->flags);
>
> (tabs with spaces) might be:
>
>	pr_err("INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
>	       page, page->objects, page->inuse, page->freelist, page->flags);

I thought the extra spaces were frowned upon?

>> @@ -998,7 +997,7 @@ static int __init setup_slub_debug(char *str)
>> -			printk(KERN_ERR "slub_debug option '%c' "
>> +			pr_err("slub_debug option '%c' "
>>  				"unknown. skipped\n", *str);
>
> Recombine strings (might be):
>			pr_err("slub_debug option '%c' unknown. skipped\n",
>			       *str);

I agree with that. I fixed a couple other similar lines but missed that
one (and probably others).

>> @@ -2431,8 +2430,8 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
>>  	for_each_object(p, s, addr, page->objects) {
>>  
>>  		if (!test_bit(slab_index(p, s, addr), map)) {
>> -			printk(KERN_ERR "INFO: Object 0x%p @offset=%tu\n",
>> -							p, p - addr);
>> +			pr_err("INFO: Object 0x%p @offset=%tu\n",
>> +				p, p - addr);
>
> Up to 80 char single line (might be):
>			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);

Missed that one also.

I was browsing lkml trying to see what the consensus is on the > 80 character
string constants.  Seems like it's undecided depending on who comments...

I happened to be reading thru the mm source trying to work out an issue with
SPARSEMEM on an ep93xx ARM system.  This looked like a simple/clean patch so
I fired it off to see what the comments would be.  Thanks for yours :-)

I will update the patch and resubmit.

> cheers, Joe

Thanks,
Hartley

