Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYDIR7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYDIR7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYDIR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:59:42 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:25758 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYDIR7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MhnRwfznkKkpya1rOLuhkFzO8tiqe/C0uLkz2xcyY8yFAvKcW5KXWw489Fni80drQWtRT1RUKNWQ/Jmf4aZFLHCui9X8TMjAlUDbYNGYAlzVazMTlbOAbcmdOzw0/wx4PWgxKQwRbNJeu1c5geX1Q/dBI6+JB5e8K0idnyWff8M=
Message-ID: <86802c440804091059l54592e07n4590b3ecebf5cb28@mail.gmail.com>
Date: Wed, 9 Apr 2008 10:59:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1207753698.11287.1246953549@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080405013014.478571000@polaris-admin.engr.sgi.com>
	 <20080405013014.693571000@polaris-admin.engr.sgi.com>
	 <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com>
	 <20080407214434.GA5296@mailshack.com> <20080408082354.GA13940@elte.hu>
	 <86802c440804081054q46e6d872u4cfe61bd2836c26@mail.gmail.com>
	 <1207753698.11287.1246953549@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 8:08 AM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
>
>  On Tue, 8 Apr 2008 10:54:15 -0700, "Yinghai Lu" <yhlu.kernel@gmail.com>
>  said:
>
> > On Tue, Apr 8, 2008 at 1:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > >  * Alexander van Heukelum <heukelum@mailshack.com> wrote:
>  > >
>  > >  > I did see that the malloc space that the inflate code is using is
>  > >  > taken from _after_ the end of the bss. I don't see how this is
>  > >  > protected from being used/overwritten. Changing the stack size changes
>  > >  > the memory layout a bit... maybe you were so unlucky to create a
>  > >  > vmlinux image that was just barely smaller than some threshold and
>  > >  > increasing the stack size made the decompression/relocation area be
>  > >  > located somewhere else?
>  > >  >
>  > >  > Test patch follows.
>  > >
>  > >  that's a really interesting theory.
>  > >
>  > >  FWIIW, i've been booting allyesconfig bzImages for a long time (with
>  > >  only minimal amount of drivers disabled - mostly old ISA ones that
>  > >  assume the presence of the real hardware), and they boot and work fine
>  > >  on both 32-bit and 64-bit typical whitebox PCs. That means huge bzImages
>  > >  that decompresses into a ~41 MB kernel image. I'd expect that to be a
>  > >  rather severe test of the decompressor.
>  >
>  > i don't that Alexander's patch is needed.
>
>  Hello Yinghai Lu,
>
>  Indeed, I now think it is not needed either. The decompression is
>  done in-place nowadays: the (compressed) image is moved to a high
>  memory address first, then the decompression is done starting at
>  the low end of the buffer. It is guaranteed that the output never
>  overwrites the input, and the decompression code, the stack, and
>  the heap are all at higher addresses than the input buffer. The
>  same goes for the pagetables needed for x86_64.
>
>
>  > also because Alex move heap before _end,
>  > we may need add some extra for buffer offset
>  >
>  >         /* Replace the compressed data size with the uncompressed size */
>  >         subl    input_len(%ebp), %ebx
>  >         movl    output_len(%ebp), %eax
>  >         addl    %eax, %ebx
>  >         /* Add 8 bytes for every 32K input block */
>  >         shrl    $12, %eax
>  >         addl    %eax, %ebx
>  >         /* Add 32K + 18 bytes of extra slack and align on a 4K boundary
>  >         */
>  >         addl    $(32768 + 18 + 4095), %ebx
>  >         andl    $~4095, %ebx =============================> need add
>  > heap size too.
>  > ....
>
>  No, that size is accounted for automatically: the code computes the
>  buffer size needed (including slack) minus the buffer size that is
>  already available (in the embedded gzip-file). The image is moved
>  by this amount (rounded up to a page). So that part is fine.

just wonder if Ingo have very big vmlinux, that +32K + 18 formula still works.

YH
