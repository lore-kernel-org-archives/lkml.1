Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYF3UnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYF3UnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYF3UnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:43:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYF3UnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:43:11 -0400
Message-ID: <48694521.2000802@zytor.com>
Date: Mon, 30 Jun 2008 13:42:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andy Whitcroft <apw@shadowen.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <48690385.7030500@linux.vnet.ibm.com> <48690D3C.1060803@linux.vnet.ibm.com> <20080630185943.GA24692@uranus.ravnborg.org> <20080630192610.GA6584@elte.hu> <20080630194727.GA26682@uranus.ravnborg.org> <20080630200623.GE6584@elte.hu> <20080630202506.GA28050@uranus.ravnborg.org> <486943F1.80606@zytor.com>
In-Reply-To: <486943F1.80606@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------060500090702020900040506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060500090702020900040506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> Sam Ravnborg wrote:
>>> ah, ok. So the patch below should solve this for now?
>>>
>>> is there any particular reason why we are limited to 100 sections? 
>>> (is there some ELF limitation here perhaps?)
>>
>> I would still like to know if you see significant different numbers 
>> than Kamalesh.
>> If you see a number close to 100 then OK.
>> But if you see a number say in the range of below 80 then we should 
>> dive deeper into this.
>>
>> I do not even know what the program does - never looked at it befoe
>> so why the original limit was 100 I dunno.
>>
> 
> It looks to me that the people who did the relocatable kernel code just 
> put in a magic number.  There is certainly no inherent reason for this 
> limit.
> 
> What's really ugly is that this is in a host-space program!  It would 
> have been one thing if it had been in a piece of code run in a 
> restricted environment, e.g. in the decompressor, but this one runs in 
> user space on the build environment.
> 
> The quick solution is to change this number to something obscenely big 
> (say 10000, but even that could be an issue if we end up doing stuff 
> like section per function); the proper solution is to turn these arrays 
> into a structure and allocate the array dynamically.

Here is a quick patch to just change the number; I'll take a quick pass 
to see how much work it'd be to allocate it dynamically.

	-hpa

--------------060500090702020900040506
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index edaadea..9daca63 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -10,7 +10,7 @@
 #define USE_BSD
 #include <endian.h>
 
-#define MAX_SHDRS 100
+#define MAX_SHDRS 10000
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
 static Elf32_Shdr shdr[MAX_SHDRS];

--------------060500090702020900040506--
