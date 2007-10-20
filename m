Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbXJTSg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbXJTSg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXJTSgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:36:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbXJTSgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:36:49 -0400
Message-ID: <471A49AA.6090407@zytor.com>
Date: Sat, 20 Oct 2007 11:32:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20071020164721.GA6614@Krystal>
In-Reply-To: <20071020164721.GA6614@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> I have tried generating asm-to-"register" c variables for char, short
> and int on i386 and I do not see this happening. The char opcode is
> always 1 byte, short 2 bytes and int 1 byte. Result:
> 

The comment was referring to x86-64, but I incorrectly remembered that 
applying to "movq $imm,%reg" as opposed to loading from an absolute 
address.  gas actually has a special opcode (movabs) for the 64-bit 
version of the latter variant, which is only available with %rax and its 
subregisters.

Nevermind, in other words.  It's still true, though, that the immediate 
will always be the last thing in the instruction -- that's a fixture of 
the instruction format.

> gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)
> 
>    8:   b3 02                   mov    $0x2,%bl
>    a:   b1 03                   mov    $0x3,%cl
>    c:   b2 04                   mov    $0x4,%dl
>    e:   b0 05                   mov    $0x5,%al
> 
>   4f:   66 be 06 00             mov    $0x6,%si
>   53:   66 bb 07 00             mov    $0x7,%bx
>   57:   66 b9 08 00             mov    $0x8,%cx
>   5b:   66 ba 09 00             mov    $0x9,%dx
>   5f:   66 b8 0a 00             mov    $0xa,%ax
> 
>   9f:   bb 0b 00 00 00          mov    $0xb,%ebx
>   a4:   be 0c 00 00 00          mov    $0xc,%esi
>   a9:   b9 0d 00 00 00          mov    $0xd,%ecx
>   ae:   ba 0e 00 00 00          mov    $0xe,%edx
>   b3:   b8 0f 00 00 00          mov    $0xf,%eax
> 
> 
> I notice that having a "=r" inline assembly that outputs to the first
> "register char" variable seems to be problematic. It fails with the
> following error:
> 
> /tmp/ccy35Hq1.s: Assembler messages:
> /tmp/ccy35Hq1.s:15: Error: bad register name `%sil'

'r' is wrong for 8-bit variables on i386.  It needs to be 'q'.

