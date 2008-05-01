Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbYEARAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbYEARAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbYEARAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:00:00 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:35317 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbYEAQ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:59:59 -0400
Message-ID: <4819F70C.6030305@zoopnet.de>
Date: Thu, 01 May 2008 18:59:56 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804290352.33543.yhlu.kernel@gmail.com>	 <200804292025.58268.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com> <4819B2E0.406@zoopnet.de> <86802c440805010935w5a74f132l639d7b794804bb9e@mail.gmail.com>
In-Reply-To: <86802c440805010935w5a74f132l639d7b794804bb9e@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu schrieb:
> On Thu, May 1, 2008 at 5:09 AM, Mika Fischer <mika.fischer@zoopnet.de> wrote:
>> Yinghai Lu schrieb:
>>
>>> loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
>>  >
>>  > so user don't need to add mtrr_chunk_size and mtrr_gran_size,
>>  >
>>  > if optimal value is not found, print out all list to help select less optimal
>>  > value.
>>  >
>>  > add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
>>
>>  On my system x86-latest + this patch and using no boot options gives me
>>  this /proc/mtrr:
>>  reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>>  reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
>>  reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
>>  reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
>>  reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
>>  reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
>>  reg06: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>>
>>  Which is OK. It could probably collapse reg01-reg03 into one but that's
>>  a minor issue (for me at least, there are probably cases where
>>  collapsing them might save the user from having to specify the
>>  mtrr_spare_reg_nr boot option).
> 
> yes. please try mtrr_spare_reg_nr=3 or etc.

Sure this works. But that was my point exactly. It should be possible to
figure out the better configuration automatically so that I *don't* have
to specify mtrr_spare_reg_nr=3.

Or in other words: If there are multiple equivalent configurations that
don't lose any RAM(!), the one with the most free MTRR regs should be
preferred.

AFAICT you loop over the chunk size and stop when you have found a
configuration that leaves the number of free MTRR registers requested
(default 1).

This will almost always result in a configuration where you have
*exactly* the number of requested free regs available, even if a more
efficient configuration was possible.

What I'm suggesting is, that - in the case where no RAM is lost at this
point - the loop should continue to try and free up more registers, as
long as no RAM is lost.

I.e. even if in my case chunk_size=256M gives adequate results and
leaves me with 1 free reg, since I don't lose any RAM at this point the
loop should continue as long as I do not lose any RAM. That way it would
find the ideal chunk_size (1g) automatically.

But again, this is non-critical. But I think it might help a few users
who need more than 1 free reg, because they probably will have no idea
about the kernel option...

Regards,
 Mika
