Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYDHRya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYDHRya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYDHRyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:54:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:13160 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYDHRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kOVhreOzh5oSBbmEDdVWOlHK+/6c1cQpPLVzDTQhF4x/mvENywZkukBTIAviFvFHdKVXsGJswFSnxhHPpNB8/gszGyz5nXM/3jIIKQwIwaKeWBQJ7ZZdVlPnmRXW2AjPPZaM4iiqXFz5XeI/S8j4vzz0RKv+TSlVLmi52B/Z1dE=
Message-ID: <86802c440804081054q46e6d872u4cfe61bd2836c26@mail.gmail.com>
Date: Tue, 8 Apr 2008 10:54:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
In-Reply-To: <20080408082354.GA13940@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080405013014.478571000@polaris-admin.engr.sgi.com>
	 <20080405013014.693571000@polaris-admin.engr.sgi.com>
	 <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com>
	 <20080407214434.GA5296@mailshack.com> <20080408082354.GA13940@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 1:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Alexander van Heukelum <heukelum@mailshack.com> wrote:
>
>  > I did see that the malloc space that the inflate code is using is
>  > taken from _after_ the end of the bss. I don't see how this is
>  > protected from being used/overwritten. Changing the stack size changes
>  > the memory layout a bit... maybe you were so unlucky to create a
>  > vmlinux image that was just barely smaller than some threshold and
>  > increasing the stack size made the decompression/relocation area be
>  > located somewhere else?
>  >
>  > Test patch follows.
>
>  that's a really interesting theory.
>
>  FWIIW, i've been booting allyesconfig bzImages for a long time (with
>  only minimal amount of drivers disabled - mostly old ISA ones that
>  assume the presence of the real hardware), and they boot and work fine
>  on both 32-bit and 64-bit typical whitebox PCs. That means huge bzImages
>  that decompresses into a ~41 MB kernel image. I'd expect that to be a
>  rather severe test of the decompressor.

i don't that Alexander's patch is needed.

also because Alex move heap before _end,
we may need add some extra for buffer offset

        /* Replace the compressed data size with the uncompressed size */
        subl    input_len(%ebp), %ebx
        movl    output_len(%ebp), %eax
        addl    %eax, %ebx
        /* Add 8 bytes for every 32K input block */
        shrl    $12, %eax
        addl    %eax, %ebx
        /* Add 32K + 18 bytes of extra slack and align on a 4K boundary */
        addl    $(32768 + 18 + 4095), %ebx
        andl    $~4095, %ebx =============================> need add
heap size too.
....



        /* Replace the compressed data size with the uncompressed size */
        movl    input_len(%rip), %eax
        subq    %rax, %rbx
        movl    output_len(%rip), %eax
        addq    %rax, %rbx
        /* Add 8 bytes for every 32K input block */
        shrq    $12, %rax
        addq    %rax, %rbx
        /* Add 32K + 18 bytes of extra slack and align on a 4K boundary */
        addq    $(32768 + 18 + 4095), %rbx
=============================> need add heap size too.
        andq    $~4095, %rbx

do we need to move pgtable before _end?

YH
