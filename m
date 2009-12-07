Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZLGShE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZLGShE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbZLGShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:37:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbZLGShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:37:03 -0500
Message-ID: <4B1D4B0C.9030108@zytor.com>
Date: Mon, 07 Dec 2009 10:35:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH 1/1] X86: use explicit register name for get/put_user
References: <1260091808-8053-1-git-send-email-jslaby@suse.cz> <4B1C01F4.8020304@zytor.com> <4B1CF701.3070805@gmail.com>
In-Reply-To: <4B1CF701.3070805@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 04:37 AM, Jiri Slaby wrote:
> Is this documented somewhere? Or do we rely on an undocumented feature?
> I mean it doesn't refer only to the constraint but also to a concrete
> register allocation. As far as I understand it (from the gcc 4.4
> documentation), if one does
>  "insn %0" : "=r" (out) : "0" (in)
> the "0" constraint corresponds to the concrete register allocated for
> out, not to any register (which is the constraint "r").

Yes, but it only corresponds to the information that is conveyed in the
register selection.

> In the document they write only about the "same location" occupied by in
> and out, nothing is said about size (and hence I think we cannot
> mismatch size of operands). And I couldn't find any other
> restrictions/documentation about inline assembly, hence the patch,
> because nothing assured me this cannot change in the future.

There is almost no documentation at all; some of the little
documentation there is is in comments in the source code.  To a first
order of approximation, asm() is defined by behavior, not by a written
spec.  Trying to play language lawyer with the little bit that is
written down is pointless -- the gcc people have been more than happy to
break asm() between releases regardless of what is and is not written down.

> Now I tried different compilers (clang, llvm-gcc) and they choke on that:
> $ cat c.c
> void x(void)
> {
>         unsigned long in;
>         int out;
>         asm("insn %0" : "=r" (out) : "0" (in));
> }
> $ clang c.c -S -o -
> c.c:5:36: error: unsupported inline asm: input with type 'unsigned long'
>       matching output with type 'int'
>         asm("insn %0" : "=r" (out) : "0" (in));
>                               ~~~         ^~
> 1 diagnostic generated.
> $ llvm-gcc c.c -S -o -
> c.c: In function 'x':
> c.c:5: error: unsupported inline asm: input constraint with a matching
> output constraint of incompatible type!
> 
> thanks for the review,

gcc is the standard for gcc-style asm()... if they don't comply, that a
bug...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

