Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYIFW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYIFW7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYIFW7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:59:41 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:60037 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYIFW7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:59:40 -0400
Message-ID: <48C30B4D.7030700@knaff.lu>
Date: Sun, 07 Sep 2008 00:59:25 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu> <c384c5ea0809061529g2c7280d8j216f7791ceeb439a@mail.gmail.com>
In-Reply-To: <c384c5ea0809061529g2c7280d8j216f7791ceeb439a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> Hello,
> 
> a small remark on the non-code parts:
> 
> On Sat, Sep 6, 2008 at 11:19 PM, Alain Knaff <alain@knaff.lu> wrote:
>> compressing the kernel with bzip2 or lzma rather than gzip. Both
>> compressors give smaller sizes than gzip.  Moreover, lzma's
>> decompresses faster than gzip.
>>
> versus
> 
>> +config KERNEL_GZIP
>> +       bool "Gzip"
>> +       help
>> +         The old and tried gzip compression. Its compression ratio is
>> +        the poorest among the 3 choices; however its speed (both
>> +        compression and decompression) is the fastest.
>> +
> 
> This seems contradictionary information.

Oops, sorry for that. Actually the Kconfig text is correct. On
decompression, Lzma is faster than bzip2 but slower than gzip:

Compressor	Compression	Decompression	Size
gzip -9		1,01s		0,11s		833069
lzma -9		3,43s		0,24s		705125
bzip2 -9	2,88s		0,38s		777706

On compression, lzma is actually slowest of the 3, but that should be of
little concern, as this happens only once, whereas decompression happens
many times (on each boot).

So, overall lzma looks like the best (acceptable decompression speed,
best decompression ratio). I only included Bzip2 because it's much
better known than lzma.

> However, I welcome more compression options in kernel and filesystem
> land, so I'm very interested in this patch.

Thanks for your interest and warm welcome :)

> Recently, on the filesystem side there seems to be some effort to
> modularize the decompressors, instead of the use of #ifdef's.
> 
> The other architectures (especially used in embedded) need to hook in
> on this, getting rid of the many out-of-tree patches for kernel/fs
> decompression.
> 
> Regards,

Unfortunately, I didn't have any such machine available for testing, so
I just for Intel 32/64.

However, the changes in the Assembly part (head_32.S and head_64.S) are
trivial, so should be easy to port. The only change to these files is
the offset where the uncompressed size of the file may be found (4 bytes
from the end for gzip, and 5 from the start for lzma).

misc.c, where the bulk of the "architecture-specific" change is, is
actually not that architecture-specific, and could maybe be moved to a
common part? Diff'ing the boot/compressed/misc.c's of various
architectures shows (at first glance) mostly version differences: some
architectures get some changes/enhancements earlier than others. It's as
if the various architectures were stuck at some different points in the
past as compared to Intel...

most of the other files are architecture-independant anyways (the stuff
in lib/ and init/)

Alain
