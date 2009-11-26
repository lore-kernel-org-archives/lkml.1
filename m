Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZKZRO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZKZRO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZKZRO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:14:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44264 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbZKZRO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:14:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dntN6LaUXaZXIFis1Tkn/alLMUW4QpdM3OS6sa88w3poXVKBFtorMWqUuNCStSt80U
         YyJUfsPmftMnr1lbCIA7b+OfO3bvdDmZemKcvYhnAJ2pveDqRNnh/FNVTfrhjpRAhCJX
         bbExAPVGOdSmRAskpe6i/Aw4qDYbiP3/wslb4=
Message-ID: <4B0EB78F.8040600@tuffmail.co.uk>
Date: Thu, 26 Nov 2009 17:14:55 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>	<1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk> <20091125164033.655810b7.akpm@linux-foundation.org>
In-Reply-To: <20091125164033.655810b7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue,  3 Nov 2009 10:06:17 +0000
> Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> modpost of vmlinux.o now extracts the ksymtab sections and outputs
>> sorted versions of them as .tmp_exports-asm.S.  These sorted sections
>> are linked into vmlinux and the original unsorted sections are
>> discarded.
>>
>> This will allow modules to be loaded faster, resolving symbols using
>> binary search, without any increase in the memory needed for the
>> symbol tables.
>>
>> This does not affect the building of modules, so hopefully it won't
>> affect compile times too much.
>>
>> Minimally tested on ARM under QEMU emulator.
>> Build tested on blackfin; output of "size -A" unchanged.
>>     
>
> I'm getting a segfault from write_exports().  
>
> (gdb) bt
> #0  0x0000003e5f075510 in strlen () from /lib64/libc.so.6
> #1  0x0000003e5f045cb8 in vfprintf () from /lib64/libc.so.6
> #2  0x0000003e5f06683a in vsnprintf () from /lib64/libc.so.6
> #3  0x0000000000401897 in buf_printf (buf=0x7fff5514f5e0, 
>     fmt=0x7fff5514f4e0 "0x%02x ") at scripts/mod/modpost.c:1692
> #4  0x00000000004042c8 in main (argc=1024, argv=0x7fff5514f5e0)
>     at scripts/mod/modpost.c:2063
> (gdb) f 4
> #4  0x00000000004042c8 in main (argc=1024, argv=0x7fff5514f5e0)
>     at scripts/mod/modpost.c:2063
> 2063                    buf_printf(&buf, "__EXPORT_%s_SYMBOL(%s,"
> (gdb) p sym
> $1 = (struct symbol *) 0x65c9f0
> (gdb) p *sym
> $2 = {next = 0x64c3a0, module = 0x610010, crc = 4077789248, crc_valid = 1, 
>   weak = 0, vmlinux = 0, kernel = 0, preloaded = 0, function = 1, 
>   export = export_unknown, name = 0x65ca10 "simple_prepare_write"}
> (gdb) p sym->export
> $3 = export_unknown
> (gdb) p/d sym->export
> $4 = 5
>
> but section_names[] (which could be static in write_exports() btw) has
> only five entries.
>   

Thanks.  I can't work out why this would happen.  Could you show the 
options modpost is being run with (make V=1 will do)?  Also confirm 
whether this is "MODPOST vmlinux.o" or "MODPOST 1001 modules".


 > main (argc=1024

It looks like this is the step "MODPOST 1001 modules".  But that 
shouldn't run write_exports().  We only run modpost with "-x" for the 
step "MODPOST vmlinux.o".  Also, the vmlinux-only modpost is run first, 
so I wonder why it didn't hit the same problem.

I don't know why sym->vmlinux==0 either; simple_prepare_write() should 
always be built into vmlinux.  Perhaps modpost is being run on libfs.o 
for some strange reason.

Alan
