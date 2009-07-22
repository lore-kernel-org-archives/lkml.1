Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZGVNq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZGVNq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZGVNq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:46:56 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:36879 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZGVNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:46:55 -0400
Date: Wed, 22 Jul 2009 15:45:37 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907221340540.26357@bizon.gios.gov.pl>
Message-ID: <alpine.LNX.1.10.0907221543350.26357@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LNX.1.10.0907221340540.26357@bizon.gios.gov.pl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-103688672-1248270338=:26357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-103688672-1248270338=:26357
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:

>
>
> On Tue, 21 Jul 2009, Linus Torvalds wrote:
>
>> 
>> [ Added Ian Lance Taylor to the cc, he knows the background, and unlike me
>>  is competent with gcc. ]
>> 
>> On Tue, 21 Jul 2009, Troy Moure wrote:
>>> 
>>> I think I've found something interesting.  Look at the the code generated
>>> for edid_checksum() in driver/video/fbmon.c.  This is what I see for the
>>> -fno-strict-overflow kernel:
>> 
>> Ooh.
>> 
>> Bingo. You're 100% right, and you definitely found it (of course, there
>> may be _other_ cases like this, but that's certainly _one_ of the
>> problems, and probably the only one).
>> 
>> Just out of curiosity, how did you find it? Now that I know where to look,
>> it's very obvious in the assembler diffs, but I didn't notice it until you
>> pointed it out just because there is so _much_ of the diffs...
>> 
>> And yes, that's very much a compiler bug. And I also bet it's very easily
>> fixed.
>> 
>> The code in question is this loop:
>>
>> 	#define EDID_LENGTH 128
>>
>> 	unsigned char i, ...
>>
>> 	for (i = 0; i < EDID_LENGTH; i++) {
>>                csum += edid[i];
>>                all_null |= edid[i];
>>        }
>> 
>> and gcc -fno-strict-overflow has apparently decided that that is an
>> infinite loop, even though it clearly is not. So then the stupid and buggy
>> compiler will compile that loop (and the whole rest of the function) to
>> the "optimized" version that is just
>>
>> 	loop:
>> 		jmp loop;
>> 
>> I even bet I know why: it looks at "unsigned char", and sees that it is an
>> 8-bit variable, and then it looks at "i < EDID_LENGTH" and sees that it is
>> a _signed_ comparison (it's signed because the C type rules mean that
>> 'unsigned char' will be extended to 'int' in an expression), and then it
>> decides that in a signed comparison an 8-bit entry is always going to be
>> smaller than 128.
>> 
>> Anyway, I bet we can work around the compiler bug by just changing the
>> type of "i" from "unsigned char" to be a plain "int".
>> 
>> Krzysztof? Mind testing that?
>> 
>> Ian? This is Linux 2.6.27.27 compiled with gcc-4.2.4. I'm not seeing the
>> bug in the gcc I have on my machine (gcc-4.4.0), but the bug is very clear
>> (once you _find_ it, which was the problem) in the binaries that Krzysztof
>> posted. They're still at:
>>
>>    http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fno-strict-overflow.bz2 
>> (Hangs)
>>    http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fwrapv.bz2 
>> (OK)
>>    http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fnone.bz2 
>> (OK)
>> 
>> and you can clearly see the 'edid_checksum' miscompilation in the objdump
>> disassembly.
>
> BTW: here is a simple testcase for this bug:
>
> --- fno-strict-overflow-fixed-bug.c ---
> #include <stdio.h>
>
> int main() {
>
>        unsigned char i;
>
>        for (i = 0; i < 128; i++)
>                printf("loop %u\n", i);
>
>        return 0;
> }
> --- cut here ---

Or this better one (no infinite loop):

--- cut here ---
#include <stdio.h>

int main() {

         unsigned char i, j=0;

         for (i = 0; i <= 127; i++) {

                 if (!i && j++) {
                         printf("Buggy GCC\n");
                         return 1;
                 }
         }

         printf("GCC is OK\n");

         return 0;
}
--- cut here ---

> The code should be compiled with:
> cc -o fno-strict-overflow-fixed-bug -Os -fno-strict-overflow 
> fno-strict-overflow-fixed-bug.c
> or:
> cc -o fno-strict-overflow-fixed-bug -O2 -fno-strict-overflow 
> fno-strict-overflow-fixed-bug.c
>
> This bug does not exist with -O1 or if the loop is controlled by "i < 127" or 
> "i < 129".
>
> So, we should make sure there is no
> unsigned char i; (...) for (i = 0; i < 128; i++)
> somewhere inside the kernel.


Best regards,

 				Krzysztof Olêdzki
---1144830174-103688672-1248270338=:26357--
