Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbXENN6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbXENN6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXENN56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:57:58 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:63267 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbXENN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:57:57 -0400
In-Reply-To: <20070514110636.GB10143@uranus.ravnborg.org>
References: <46483FAC.60503@freescale.com> <20070514110636.GB10143@uranus.ravnborg.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3DF58590-DFD9-4665-8C47-33F407AAD1E7@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>, Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Date: Mon, 14 May 2007 08:56:52 -0500
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14, 2007, at 6:06 AM, Sam Ravnborg wrote:

> On Mon, May 14, 2007 at 06:53:32PM +0800, Li Yang wrote:
>> This patch fixes the following "Section mismatch" warnings when
>> build powerpc platforms.
>>
>> -------------
>> WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to
>> .init.text:early_get_page from .text between  
>> 'pte_alloc_one_kernel' (at
>> offset 0xc68) and 'pte_alloc_one'
>> WARNING: mm/built-in.o - Section mismatch: reference to
>> .init.text:set_up_list3s from .text between  
>> 'kmem_cache_create' (at offset
>> 0x20300) and 'cache_reap'
>> -------------

This warnings should be handled by __init_refok instead.

- k

>> Massive warnings represented by:
>> -------------
>> WARNING: arch/powerpc/kernel/built-in.o - Section mismatch:  
>> reference to
>> .init.data:.got2 from prom_entry (offset 0x0)
>> WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:  
>> reference to
>> .init.text:mpc8313_rdb_probe from .machine.desc after  
>> 'mach_mpc8313_rdb'
>> (at offset 0x4)
>> -------------
>>
>> Signed-off-by: Li Yang <leoli@freescale.com>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>> ---
>> scripts/mod/modpost.c |   16 ++++++++++++----
>> 1 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
>> index c89cb71..aa3a881 100644
>> --- a/scripts/mod/modpost.c
>> +++ b/scripts/mod/modpost.c
>> @@ -649,9 +649,10 @@ static int strrcmp(const char *s, const char  
>> *sub)
>>  *  tosec    = .init.text
>>  *
>>  * Pattern 10:
>> - *  ia64 has machvec table for each platform. It is mixture of  
>> function
>> - *  pointer of .init.text and .text.
>> - *  fromsec  = .machvec
>> + *  ia64 has machvec table and powerpc has machine desc table for  
>> each
>> + *  platform. It is mixture of function pointer of .init.text  
>> and .text.
>> + *  fromsec  = .machvec | .machine.desc
>> + *
>>  **/
>> static int secref_whitelist(const char *modname, const char *tosec,
>> 			    const char *fromsec, const char *atsym,
>> @@ -681,6 +682,8 @@ static int secref_whitelist(const char  
>> *modname, const
>> char *tosec,
>> 	const char *pat4sym[] = {
>> 		"sparse_index_alloc",
>> 		"zone_wait_table_init",
>> +		"pte_alloc_one_kernel",
>> +		"kmem_cache_create",
>> 		NULL
>> 	};
>>
>> @@ -750,7 +753,8 @@ static int secref_whitelist(const char  
>> *modname, const
>> char *tosec,
>> 				return 1;
>>
>> 	/* Check for pattern 10 */
>> -	if (strcmp(fromsec, ".machvec") == 0)
>> +	if ((strcmp(fromsec, ".machvec") == 0) ||
>> +	    (strcmp(fromsec, ".machine.desc") == 0))
>> 		return 1;
>>
>> 	return 0;
>> @@ -883,6 +887,10 @@ static void warn_sec_mismatch(const char  
>> *modname,
>> const char *fromsec,
>> 	    secref_whitelist(modname, secname, fromsec,
>> 			     elf->strtab + before->st_name, refsymname))
>> 		return;
>> +	/* fromsec whitelist - without a valid 'before' */
>> +	/* powerpc has a GOT table in .got2 section */
>> +	if (strcmp(fromsec, ".got2") == 0)
>> +		return;
>>
>> 	if (before && after) {
>> 		warn("%s - Section mismatch: reference to %s:%s from %s "
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

