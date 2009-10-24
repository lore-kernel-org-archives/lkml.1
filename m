Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZJXJAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZJXJAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 05:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZJXJAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 05:00:09 -0400
Received: from relay2.mail.masterhost.ru ([83.222.23.62]:27393 "EHLO
	relay2.mail.masterhost.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZJXJAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 05:00:07 -0400
Message-ID: <4AE2C218.2040306@mayc.ru>
Date: Sat, 24 Oct 2009 13:00:08 +0400
From: "Anton D. Kachalov" <mouse@mayc.ru>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Ryan C. Gordon" <icculus@icculus.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
References: <4AE17C1A.4060009@mayc.ru> <alpine.OSX.1.10.0910231933550.2186@caridad.icculuslan>
In-Reply-To: <alpine.OSX.1.10.0910231933550.2186@caridad.icculuslan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: mouse@mayc.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 10384 [Oct 24 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {DNSBL Rate: low}
X-SpamTest-Method: none
X-SpamTest-Rate: 60
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ryan.

Ryan C. Gordon wrote:
> Wow, competing ideas!   :)
>
> Here are my notes on your idea. Ego compels me to prefer my approach, but 
> I strove to be objective here, as there is a tradeoff of benefits in each 
> of our approaches.
>   
Thanks :) It was born just out of Apple's concept utilizing unused space 
in ELF headers.
>> It should works with "setarch" too to force selection of binary.
>>     
>
> How does setarch work? Does it reorder the file before launching or copy 
> out one of the ELF records? 
>
>   
$ man setarch
NAME
       setarch  -  change reported architecture in new program 
environment and
       set personality flags

$ dpkg -S /usr/bin/setarch
util-linux: /usr/bin/setarch

"setarch" just set "personality" of running program.

[...]
> The most compelling feature of this approach is that a "truearch" binary 
> (is that the correct name?) could work with any existing Linux system, on 
> the condition that the architecture you want is the first one in the file. 
>   
Nope, you may put binary files in any order. It's just a linked list of  
binaries.
> If you put, say, x86 first in the file and you want to run it on an x86_64 
> system, you're either out of luck or going to be running the 32-bit 
> version.
As a previous state, you will able run x86_64. But you need to change 
order of binfmt and compat_binfmt in built-in.o by changing Makefile. 
Just swap two lines. I don't know why on x86_64 system first we try 
compat mode than native while simple run of native app will take more 
cpu cycles on x86_64 Vs. x86.
> In this same scenario, if you put x86_64 first, it just won't run 
> at all on an unpatched x86 box. So, it's a cool trick, but it's not all 
> that beneficial. We have to assume that either approach requires kernel 
> patches to be truly useful. For unpatched boxes, FatELF provides a simple 
> command line app, fatelf-extract, which can be used to get the original 
> ELF binary you want out of the FatELF file, both for stripping unwanted 
> bits and as a measure of last resort if the kernel and dynamic loader 
> can't handle FatELF. I assume setarch works somewhat the same.
>   
Which arch will be "fatelf-extract"? Let's say, If I'm running Linux on 
PowerPC? x86? =) Only if it is a shell script, it will be beneficial for 
any arch. I can inject "offset" portion in script file too...
> I'm concerned about using the padding bits in e_ident, too. A lot of 
> manpower went into the ELF specification and I felt it was presumptuous 
> for me to personally change the format. A container around them, like 
> FatELF, was a safer, more future-proof choice. I'd rather those that 
> control the ELF spec decide what those padding bits should be used for in 
> the future.
>
> The truearch method requires the kernel to seek throughout the whole file 
>   
Nope, it just read "offset" field and seek if needed. So, if file is 
just one-arch, it will read 128 bytes only.
> to decide if it can use it at all. FatELF uses the 128 bytes at the front 
> of the file, which binfmt_elf reads anyhow, and then seeks to the right 
> record from there, so disk bandwidth overhead is extremely small (one 
> extra read of 128 bytes if we can use the file, zero extra reads if not).  
>   
In my approach, it's just a few seeks more. Just a few additional reads 
are not so much compared to overall reads from that file.

[...]
> Both approaches have zero disk overhead if a normal ELF file is loaded, 
> which is good.
>
>
> In terms of this patch itself, I'd be concerned about using gotos for the 
> retry_* blocks when a loop would be easy enough to incorporate. I saw you 
> have a test for personality() that I didn't do; I might have to check into 
> that, but the binfmt_elf_compat code is definitely catching x86 binaries 
> on x86_64 here, so I'm not sure it's necessary.
>   
It's necessary if you would like to use setarch to choose binaries on 
biarch systems.
> Anyhow, I hope this was useful commentary, and not seen as a battle of 
> egos. I'm glad to see other approaches, though, as it suggests there 
> really is a genuine desire for this sort of functionality!
>   
:) Agreed

Rgds,
Anton
