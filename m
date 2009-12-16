Return-Path: <linux-kernel-owner+w=401wt.eu-S935846AbZLPWlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935846AbZLPWlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935343AbZLPWl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:41:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934361AbZLPWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:41:25 -0500
Message-ID: <4B296209.2010902@zytor.com>
Date: Wed, 16 Dec 2009 14:41:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] x86 msrs: alloc/free for CONFIG_SMP=n
References: <20091216183212.118c5e14.sfr@canb.auug.org.au> <20091216092424.5f87214c.randy.dunlap@oracle.com> <4B2919BD.40001@zytor.com> <20091216174524.GH11618@aftab> <4B2928AC.3020807@zytor.com> <20091216135119.e283e525.randy.dunlap@oracle.com> <20091216215808.GB27228@liondog.tnic>
In-Reply-To: <20091216215808.GB27228@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 01:58 PM, Borislav Petkov wrote:
> 
>>
>> --- linux-next-20091216.orig/arch/x86/lib/Makefile
>> +++ linux-next-20091216/arch/x86/lib/Makefile
>> @@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
>>  
>>  clean-files := inat-tables.c
>>  
>> -obj-$(CONFIG_SMP) := msr.o
>> +obj-$(CONFIG_X86_MSR) := msr.o
> 
> however, CONFIG_X86_MSR is the x86 MSR access module and the <lib/msr.c>
> is the library of MSR accessing functions which is always in. So this
> should be unconditional as in my version or Peter might have a better
> idea...?
> 

Both are wrong.

CONFIG_X86_MSR has nothing at all to do with this and is a complete red
herring.  Involving CONFIG_X86_MSR is just totally bogus.

Including msr.o unconditionally is also wrong, but for a more subtle
reason: msr.c is written to contain functions that apply to SMP only;
with UP replacement stubs written as inlines in
arch/x86/include/asm/msr.h.

Putting most of the file inside a big #ifdef of course works, but is a
pretty bad case of beating it with the ugly stick.  My preference would
be to move the SMP-specific functions to a new file, call it msr-smp.c,
and then leave only the functions that should be included
unconditionally in msr.c (I believe it is cleaner to do it that way than
the opposite.)

	-hpa
