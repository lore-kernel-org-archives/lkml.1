Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYDIR6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYDIR6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYDIR61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:58:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:29488 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYDIR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QZQg4r53//BYrU15MqsYJccrBb5+z82YaoBOm3o+xH93d7H95v2OdtaqQtIa+MBXw6bsStO7qym6O5Nzn69Xbmp5GBEwuFTTXCnerj5qvJJzNB4rvguiJ3hm/mWv5EGiZnwflF/p20G++gIvdgVcHMfjBKuf9S/2iecCHJGCkjc=
Message-ID: <86802c440804091058g3357adf9x63249ff20a00eb0c@mail.gmail.com>
Date: Wed, 9 Apr 2008 10:58:21 -0700
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

yes, that don't need to changed.

...
>  > do we need to move pgtable before _end?
>
>  I just tried, but it fails: The pgtable is built and enabled in the
>  32-bit
>  setup code, but the kernel image is moved in the 64-bit part...
>  overwriting
>  the pagetable with zeroes ;).
>
>  I can't think of an obvious safe place to put the pagetables, though.
>  One
>  option is to move the image in the 32-bit code and tell the 64-bit part
>  somehow not to do it again... by calling into the 64-bit code at a
>  different
>  place, for example.

current pgtable table is safe, before arch/x86/kernel/head_64.S using
new pgtable.

YH
