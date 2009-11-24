Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbZKXUNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbZKXUNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbZKXUNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:13:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:34696 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbZKXUM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f8U/TsEmf6TTrx73SM/CncEbSAX0sCGsmjvScd4hAYIkdyXgg//b9zJB0T0sIyeBde
         uikVXxK0iax+4IoAbfeCLVNrQD3V09X6lY3EGNLyIstJdOUUkd+cWrozXqDwyIBw4ZDz
         5+CHMobCL/qXbxFa87MAJkx4b/VDDSNEeM2cw=
MIME-Version: 1.0
In-Reply-To: <4B0C2445.2000008@klingt.org>
References: <4B0BBB83.2020604@klingt.org>
	 <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
	 <4B0C2445.2000008@klingt.org>
Date: Tue, 24 Nov 2009 15:13:02 -0500
Message-ID: <73c1f2160911241213r24f0b8fdt3a4f5d50017c96c4@mail.gmail.com>
Subject: Re: [PATCH 0/5] branch hint tweaks
From: Brian Gerst <brgerst@gmail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 1:21 PM, Tim Blechmann <tim@klingt.org> wrote:
>> Did you run profiling tests again after making these changes to see if
>> they had any effect?  likely() and unlikely() are only hints.  GCC
>> doesn't have to follow them, or it could be broken in recent GCC
>> versions.
>
> i know, the compiler doesn't have to follow the hint ... but with the
> likely/unlikely profiling, not the execution time is profiled, but
> whether the branch hint is pointing to the right direction on my machine
> ... if the assembly is actually affected does probably depend on the
> compiler version, instruction set, cpu tuning ...

The only branch "hint" in the final assembly output is whether a
branch points forward or backward.  unlikely() should tell GCC to put
the code at the end of the function, and use a forward branch to it.

Take for instance the code in arch/x86/kernel/process_64.c:

        savesegment(es, prev->es);
        if (unlikely(next->es | prev->es))
                loadsegment(es, next->es);

 5eb:   66 8c c1                mov    %es,%cx
 5ee:   66 89 48 30             mov    %cx,0x30(%rax)
 5f2:   66 83 bb a8 04 00 00    cmpw   $0x0,0x4a8(%rbx)
 5f9:   00
 5fa:   41 8b 8d a8 04 00 00    mov    0x4a8(%r13),%ecx
 601:   75 05                   jne    608 <__switch_to+0x86>
 603:   66 85 c9                test   %cx,%cx
 606:   74 04                   je     60c <__switch_to+0x8a>
 608:   31 f6                   xor    %esi,%esi
 60a:   8e c1                   mov    %ecx,%es

Both of those branches are forward, which will be statically predicted
as not taken.  Removing the unlikely() did not change the generated
code in this case with GCC 4.4.2.  So this patch does nothing for that
compiler version, but will lead to worse code on compilers that do
respect the hint.

Note that there is some weirdness in how the actual test is generated.
 It's not doing a bitwise-or operation like the C code describes.
This could be throwing off the optimizer.

--
Brian Gerst
