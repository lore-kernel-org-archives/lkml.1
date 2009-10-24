Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZJXAUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZJXAUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 20:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZJXAUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 20:20:09 -0400
Received: from icculus.org ([67.106.77.212]:36273 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZJXAUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 20:20:08 -0400
Date: Fri, 23 Oct 2009 20:20:03 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: "Anton D. Kachalov" <mouse@mayc.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
In-Reply-To: <4AE17C1A.4060009@mayc.ru>
Message-ID: <alpine.OSX.1.10.0910231933550.2186@caridad.icculuslan>
References: <4AE17C1A.4060009@mayc.ru>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have made very similar patch but it's quite small and do not require
> deep hacks.

Wow, competing ideas!   :)

Here are my notes on your idea. Ego compels me to prefer my approach, but 
I strove to be objective here, as there is a tradeoff of benefits in each 
of our approaches.

> It should works with "setarch" too to force selection of binary.

How does setarch work? Does it reorder the file before launching or copy 
out one of the ELF records? 

If reordering:
What does this do to binaries you can't write to? Regular users couldn't 
rewrite /bin/ls before launching, for example.

If copying:
What does this do to programs that rely on the value of argv[0]? If 
setarch mangles up argv[0] in its exec*() call to match the original 
binary's patch, what does this do to programs that rely on /proc/self/exe?


The most compelling feature of this approach is that a "truearch" binary 
(is that the correct name?) could work with any existing Linux system, on 
the condition that the architecture you want is the first one in the file. 
If you put, say, x86 first in the file and you want to run it on an x86_64 
system, you're either out of luck or going to be running the 32-bit 
version. In this same scenario, if you put x86_64 first, it just won't run 
at all on an unpatched x86 box. So, it's a cool trick, but it's not all 
that beneficial. We have to assume that either approach requires kernel 
patches to be truly useful. For unpatched boxes, FatELF provides a simple 
command line app, fatelf-extract, which can be used to get the original 
ELF binary you want out of the FatELF file, both for stripping unwanted 
bits and as a measure of last resort if the kernel and dynamic loader 
can't handle FatELF. I assume setarch works somewhat the same.

I'm concerned about using the padding bits in e_ident, too. A lot of 
manpower went into the ELF specification and I felt it was presumptuous 
for me to personally change the format. A container around them, like 
FatELF, was a safer, more future-proof choice. I'd rather those that 
control the ELF spec decide what those padding bits should be used for in 
the future.

The truearch method requires the kernel to seek throughout the whole file 
to decide if it can use it at all. FatELF uses the 128 bytes at the front 
of the file, which binfmt_elf reads anyhow, and then seeks to the right 
record from there, so disk bandwidth overhead is extremely small (one 
extra read of 128 bytes if we can use the file, zero extra reads if not).  
On the other hand, this approach allows for an unlimited amount of ELF 
binaries to reside in a single file below the four gigabyte mark (which is 
really, for all intents and purposes, a LOT of binaries). On the other 
hand, the FatELF limit of 255 records is probably way more than you could 
ever hope to reasonably cram into a file, and if it's not, we can raise it 
to 64k (we have reserved bits in the header still). FatELF can store ELF 
binaries above 4 gigabytes, unlike truearch, but I'm not sure that's 
really ever going to be valuable.

Both approaches have zero disk overhead if a normal ELF file is loaded, 
which is good.


In terms of this patch itself, I'd be concerned about using gotos for the 
retry_* blocks when a loop would be easy enough to incorporate. I saw you 
have a test for personality() that I didn't do; I might have to check into 
that, but the binfmt_elf_compat code is definitely catching x86 binaries 
on x86_64 here, so I'm not sure it's necessary.

Anyhow, I hope this was useful commentary, and not seen as a battle of 
egos. I'm glad to see other approaches, though, as it suggests there 
really is a genuine desire for this sort of functionality!

--ryan.

