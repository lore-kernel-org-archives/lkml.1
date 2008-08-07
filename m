Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYHGHLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYHGHLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYHGHLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:11:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1693 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYHGHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GJf/lAR1e/qntLSjVemTvUOySJWClMV02nM+xPqiKNaIRSo9lrsvL9ppxo1D67/2XN
         79+AV8meP2HycGDBtjlaUh+hlgE8XV5SmsRdJV6OjzHDzXuYirnviINtUOt0IEw+9yuF
         vfUvL4l2mlfzGwI/33BdfJ3jw5U69MW0YZgks=
Message-ID: <ac9c93b10808070011x7a84adb5v98d2ed2405835fcc@mail.gmail.com>
Date: Thu, 7 Aug 2008 09:11:43 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: initramfs optimization suggestions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <489A40FF.1000508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
	 <489A40FF.1000508@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

appreciate your feedback. Some answers/clarification below:

2008/8/7 H. Peter Anvin <hpa@zytor.com>:
> Frans Meulenbroeks wrote:
>>
>> First proposal:
>> ==========
>>
>> initramfs is build from a compressed cpio archive.
>> Proposal is to introduce a build option to make the compression and
>> decompression optional.
>> Rationale 1: could be faster as it trades off I/O time (to read the
>> image) against decompression time
>> Rationale 2: for architectures that use compressed images (bzImage)
>> actually we compress twice, which is not really efficient.
>>
>> I can implement this, but before spending time on it I would like to know
>> if
>> a) people consider this a good idea
>> b) no one else already has doen this.
>>
>
> It already is optional.  If you don't want to compress it, don't.

The initramfs loader (initramfs.c) indeed can deal with uncompressed
cpio files. I saw that in the code and I just did a quick test to
verify that it does. Actually I was unaware that it could until very
recently. The doc & code are not *that* clear (see below)

>
> Perhaps what you are referring to is the initramfs that is optionally built
> out of the kernel tree?

Yes.
I am building my initramfs with the kernel and there the possibility
to have an uncompressed ramfs does not exist.
Kconfig INITRAMFS_SOURCE can point to a pre-cooked .cpio file, but
that one will always be compressed by the gen_initramfs_list.sh
script.
It might be desirable to have a option to specify whether compression
is needed or not. Guess this would also imply renaming the output file
of the script to something like initramfs_data.dat or so instead of
initramfs_data.cpio.gz (as it would be confusing to have a file with
.gz extension that is not compressed). The alternative of course could
be to generate the complete initramfs_data.S file (where the .incbin
"usr/initramfs_data.cpio.gz" is, which hardcodes the name of the
file).

(BTW: please don't say that having the initramfs in the kernel image
is less desirable/builds slower/is less flexible and therefore less
desirable. I work on embedded systems and for me having a kernel with
embedded initramfs is highly convenient. I can just take my image,
load it over jtag in my hardware and boot it, without having to worry
about having a proper initramfs image somewhere on my target)
>
> You are (correctly) pointing out that if the image is already compressed, it
> doesn't gain from additional compression, but that would increase the
> operational memory footprint during expansion.

Agree about the footprint but as this is only during booting the
memory is on most systems available anyway (and I assume the memory
occupied by init.ramfs is reclaimed later on).

Disadvantage of the double compression is the waste of time for the
2nd decompression (which is probably neglectable if you have only a
tiny ramfs and/or a fast processor).
However if the initramfs is bigger and the processor slower this
starts to count in the boot time.
For embedded systems (say a router) it often makes sense to keep all
software in initramfs (as opposite to squashfs/cramfs) as the access
of the data is faster (of course at the expense of some memory as the
squashfs image is likely compressed.

Actually I did a short test on this, and loading a 6.6 MB compressed
ramfs image (24 MB after decompression) using a 200 Mhz MIPS processor
takes about 4.5 seconds. It is exactly this 4.5 seconds I want to get
rid of.
(and as some might say, if I were to use squashfs I would not get this
delay. This is true, but the delay then will happen when the
application(s) are loaded from the squashfs).

>
>>
>> Second proposal:
>> ============
>>
>> after decompressing the cpio archive all files are made using
>> sys_open/sys_write/sys_close and friends.
>> This implies that a lot of system calls and data copying is done.
>> It would be nice if that could be avoided.
>> I'm not fully into all details of how ramfs is implemented, but would
>> it be possible to e.g. dump all blocks of a tmp ram fs into a data
>> structure (e.g.an array of blocks) while making the kernel, and while
>> booting the kernel initialise the fs cache with these data? (I guess
>> this would be around fs/dcache.c; I understand the data here is
>> kmalloc-ed, but it might be possible to initialise the cache with
>> pointers to that data structure; due to the nature of ramfs they won't
>> be deallocated anyway I assume).
>> Does this sound feasible? Hidden snags? Appreciate your
>> opinion/feedback/suggestions.
>>
>
> The current code has a lot of advantages in terms of code complexity,
> however.  Your proposal would come with a dramatic increase in complexity.
>
>        -hpa
>
Indeed it definitely does not simplify things.
Not sure if the complexity would increase that much though
.
Actually I was only considering the initramfs that is included in the kernel.
Instead of doing things the way they are done now, we could have
initialised data structures in fs and mm.
Of course if the initramfs is loaded from an external file (with
initrd= ) it becomes a different story.

One other possibility I thought of is to keep things roughly as they
are now, but have a way to say (either in sys_write or through a new
system call) that the data is not to be copied but keep the data at
the same location (and use the memory provided by the caller)
This would of course require a few things:
- the memory contained by init.ramfs cannot be recovered (as mm will
have pointers to it)
- mm must allow that the memory for some pages is provided by the
caller (not sure if it can handle this).

At first it might seem that there is again a footprint penalty as the
init.ramfs section cannot be recovered. However the amount of memory
that mm needs in this scenario is less (as the memory for the ramfs
need not be provided by mm).

Not fully sure yet about the impact and best way forward (if any).
Note that the rationale for this is to improve boot time, especially
for embedded systems with slow processors.
As usual all feedback/suggestions/comments/whatever is appreciated.

Best regards, Frans.
