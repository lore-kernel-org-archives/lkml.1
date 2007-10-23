Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbXJWWwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbXJWWwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbXJWWwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:52:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbXJWWwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:52:24 -0400
Message-ID: <471E7B1D.4050107@zytor.com>
Date: Tue, 23 Oct 2007 15:52:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org>
In-Reply-To: <471E70E0.2090802@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> As a general comment, I can't say I'm thrilled about sticking the copied
> setup data at the end of the initial pagetables.  This is already a
> fairly complex area, and changing it touches a surprisingly large number
> of places.  I wonder if there isn't a better way to deal with this
> (possibly by fixing up the generation of the initial pagetables in the
> process).
> 
> Or more simply, define a max size for this data, and copy it into an
> initdata area (which, being initdata, can be quite large without wasting
> lots of memory).
> 

The initdata solution is fairly sensible.  It's easy, and this data 
really isn't expected to grow very fast at all.  Unfortunately we don't 
*have* an initdata bss section at the moment, so a large buffer would 
bloat the kernel binary -- at least the uncompressed one.  One school of 
thought says that this should be fixed :) [*]

However, appending to bss (like the pagetables already are) *should* be 
a reasonable option; what really should be done there is instead of 
replacing init_pg_tables_end with setup_data_end we should except 
additional dynamic data items here, and have an initial_data_end 
variable for the extreme end of any initial data no matter the source. 
It still does touch a lot of places, but at least that way they will be 
fixed once and for all.  It's somewhat questionable if it isn't easier 
for this particular job to just fix the initial bss issue.

Furthermore, on looking through the code again, I see a bunch of 
"init_pg_tables_end + setup_data_len" which really is ugly.

>> +
>> +/* extensible setup data list node */
>> +struct setup_data {
>> +	u64 next;
>> +	u32 type;
>> +	u32 len;
>> +	u8 data[0];
>> +};
>>   
> 
> What are the alignment rules for this structure?  Is it always 64-bit
> aligned?  What about the relationship of len and data?
> 

It's x86, so alignment is soft - it presumably *should* be 64-bit 
aligned, but nothing break if the boot loader doesn't.

	-hpa

[*] A very clean way to do that is to put said section right at the 
beginning of the bss, and move __init_end after it:

   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
         __bss_start = .;                /* BSS */
	*(.init.bss)
	. = ALIGN(4096);
         __init_end = .;
         *(.bss.page_aligned)
         *(.bss)
         . = ALIGN(4);
         __bss_stop = .;
         _end = . ;
         /* This is where the kernel creates the early boot page tables */
         . = ALIGN(4096);
         pg0 = . ;
   }

On x86-64, this entails moving .data_nosave; it probably can be moved to 
the same relative position as on i386 (although I have not verified that 
that is true.)
