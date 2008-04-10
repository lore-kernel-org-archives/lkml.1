Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYDJUee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYDJUee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYDJUe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:34:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:61894 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYDJUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sXZCU+/Hxv5D6UDspVf47dHnASvRoO7mqYAVTBi55KF3omk/+UTGISZhdHSeYDeWxgB2iAh7/Rf2J0HFgpC3klMZnJUgXrK/uZ3lvP7IMDxrGhkDaJklCjsMNEs5TDnUdzG9td8mBy5iRFODwW+KFCz3ubvx/mJqsXIBiFx/cYo=
Message-ID: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>
Date: Thu, 10 Apr 2008 13:34:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor -- payload_length
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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

payload_offset and payload_length in arch/x86/boot/head.S
seems to be used by bootloader  to seat the bzImage.  or just use size
of bzImage

and bootloader is supposed to load bzImage from 2M, and initrd near 4G...

so if you have memhole from [2M+36M, 2M+45M), and bzImage is only 10M,
...then you will have problem.

but I assume that bootloader already used bzImage size or payload size with


extra_bytes = (uncompressed_size >> 12) + 32768 + 18 + decompressor_size.

to get unzip size for good position for bzImage.


long term, should add one field after payload_length like
payload_unzip_length to make bootloader or kexec what buffer size
needed.
YH
