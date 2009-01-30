Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbZA3Bne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbZA3Bne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZA3BnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:43:25 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:2056 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZA3BnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:43:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P84i2lZGJGR2gRq3lhv4UNEYGShq7XSySxP38wN8nSIfLQHvrJmOfERys7LOUKIpe9
         j8c2dWisMm1D+G0sWuG2OWjA09UbL3XoUwFR2KXOsYY7WqB79D3gyDP3U4GFaUGXVa2f
         kOpj+oDHGwa0lw+9d/AFBP48TLZe7GRrxNwAQ=
MIME-Version: 1.0
In-Reply-To: <20090129172010.f25fe0ad.akpm@linux-foundation.org>
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>
	 <a6f8318b0901210427o33af879byd352adaf5fde1c29@mail.gmail.com>
	 <20090129163032.f97901c5.akpm@linux-foundation.org>
	 <21d7e9970901291706t17fc3d9aq753f90db75396639@mail.gmail.com>
	 <20090129172010.f25fe0ad.akpm@linux-foundation.org>
Date: Fri, 30 Jan 2009 11:43:23 +1000
Message-ID: <21d7e9970901291743q4f0a9393yc5c24afb50013ff3@mail.gmail.com>
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
From: Dave Airlie <airlied@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kerolasa@gmail.com, kerolasa@iki.fi, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 11:20 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 30 Jan 2009 11:06:47 +1000 Dave Airlie <airlied@gmail.com> wrote:
>
>> On Fri, Jan 30, 2009 at 10:30 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > (cc's added)
>> >
>> > On Wed, 21 Jan 2009 13:27:48 +0100
>> > Sami Kerola <kerolasa@iki.fi> wrote:
>> >
>> >> I compiled the Torvalds git kernel 2.6.29-rc2-00013 and I got an oops.
>> >> The oops happens when ever X starts. Initially I was booting with run
>> >> level 5 and it hung. I tried to use run level to 3 and an operating
>> >> system started just fine. When I type startx the hung happen again.
>> >> Please let me know if you need some more information besides oops from
>> >> messages file and lspci output.
>> >>
>> >>
>> >> Jan 21 08:53:58 lelux kernel: ------------[ cut here ]------------
>> >> Jan 21 08:53:58 lelux kernel: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
>> >
>> > I assume that 2.6.28 didn't do this?
>>
>> This is a userspace race between udev and libdrm, I'm not sure we can do
>> anything in the kernel other than BUG, maybe we should just WARN instead.
>>
>> Basically, libdrm creates devices nodes, the initial drm opening gets that, udev
>> comes along when the module is loaded and re-creates the device node,
>> when AIGLX opens the device
>> it can't figure out wtf just happened, as the inode->i_mapping we use
>> to store the GEM device mmap ranges is different.
>>
>> I think building libdrm with --enable-udev is the correct answer, and
>> maybe switching this to a WARN so it doesn't blow up.
>>
>> maybe we shouldn't be storing the inode mapping like this? anyone any
>> better idea?
>>
>
> hm, I'm a bit surprised to see the drm code using `struct
> address_space' and read_mapping_page() and unmap_mapping_range() and
> such.  I thought those only worked with regular files and pagecache :)
>
> Is it possible to briefly explain what's going on there?
>
> What instance of address_space_operations does ->dev_mapping actually
> point at?

Okay a bit tired and headache coming on but I'll try, maybe jbarnes
can help out,

We need to provide mappings to userspace that are backed by memory
that can move around behind the mappings.

So userspace wants a mapping for a GEM object via the AGP/GTT aperture
instead of directly to the backing pages.
Now as the GEM object is backed by shmem we can't use the shmem file
descriptor we have to tie the mapping to without
hacking up the shmem mmap functionality which seemed like a bad plan.

So GEM uses the device inode to setup the mappings on. We just use a
simple linear allocator to split up the device inodes address space
and assign chunks to handles for different objects. The userspace app
then uses the handle via mmap to get access to the VMAs. Now when GEM
wants to move that object out of the GTT or to another area of the GTT
we need some way to invalidate it, so we use unmap_mapping_range
which destroys all the mappings for the object in all the VMA for all
the processes mapping it currently

GEM's read_mapping_page is distinct from this and is to do with the
shmem interfaceing.

Not sure if this explains it or just make it worse.

Dave.
