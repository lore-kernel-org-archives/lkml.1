Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYHGR2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYHGR2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYHGR16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:27:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYHGR15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:27:57 -0400
Message-ID: <489B30B3.8050709@zytor.com>
Date: Thu, 07 Aug 2008 10:28:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: initramfs optimization suggestions
References: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>	 <489A40FF.1000508@zytor.com> <ac9c93b10808070011x7a84adb5v98d2ed2405835fcc@mail.gmail.com>
In-Reply-To: <ac9c93b10808070011x7a84adb5v98d2ed2405835fcc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Meulenbroeks wrote:
> 
> The initramfs loader (initramfs.c) indeed can deal with uncompressed
> cpio files. I saw that in the code and I just did a quick test to
> verify that it does. Actually I was unaware that it could until very
> recently. The doc & code are not *that* clear (see below)
> 
>> Perhaps what you are referring to is the initramfs that is optionally built
>> out of the kernel tree?
> 
> Yes.
> I am building my initramfs with the kernel and there the possibility
> to have an uncompressed ramfs does not exist.
> Kconfig INITRAMFS_SOURCE can point to a pre-cooked .cpio file, but
> that one will always be compressed by the gen_initramfs_list.sh
> script.
> It might be desirable to have a option to specify whether compression
> is needed or not. Guess this would also imply renaming the output file
> of the script to something like initramfs_data.dat or so instead of
> initramfs_data.cpio.gz (as it would be confusing to have a file with
> .gz extension that is not compressed). The alternative of course could
> be to generate the complete initramfs_data.S file (where the .incbin
> "usr/initramfs_data.cpio.gz" is, which hardcodes the name of the
> file).
> 

Having a CONFIG option to make this image uncompressed would be a good idea.

> (BTW: please don't say that having the initramfs in the kernel image
> is less desirable/builds slower/is less flexible and therefore less
> desirable. I work on embedded systems and for me having a kernel with
> embedded initramfs is highly convenient. I can just take my image,
> load it over jtag in my hardware and boot it, without having to worry
> about having a proper initramfs image somewhere on my target)
>> You are (correctly) pointing out that if the image is already compressed, it
>> doesn't gain from additional compression, but that would increase the
>> operational memory footprint during expansion.
> 
> Agree about the footprint but as this is only during booting the
> memory is on most systems available anyway (and I assume the memory
> occupied by init.ramfs is reclaimed later on).

It is, however, due to lowmem restrictions on a lot of systems this can 
still hurt.

> Actually I was only considering the initramfs that is included in the kernel.
> Instead of doing things the way they are done now, we could have
> initialised data structures in fs and mm.
> Of course if the initramfs is loaded from an external file (with
> initrd= ) it becomes a different story.
> 
> One other possibility I thought of is to keep things roughly as they
> are now, but have a way to say (either in sys_write or through a new
> system call) that the data is not to be copied but keep the data at
> the same location (and use the memory provided by the caller)
> This would of course require a few things:
> - the memory contained by init.ramfs cannot be recovered (as mm will
> have pointers to it)
> - mm must allow that the memory for some pages is provided by the
> caller (not sure if it can handle this).
> 
> At first it might seem that there is again a footprint penalty as the
> init.ramfs section cannot be recovered. However the amount of memory
> that mm needs in this scenario is less (as the memory for the ramfs
> need not be provided by mm).
> 
> Not fully sure yet about the impact and best way forward (if any).
> Note that the rationale for this is to improve boot time, especially
> for embedded systems with slow processors.
> As usual all feedback/suggestions/comments/whatever is appreciated.

I think the complexity penalty would be prohibitive; plus, on 
HIGHMEM-afflicted system, this would move the initramfs from highmem to 
lowmem, which would be highly undesirable.

Overall, part of the attractiveness of the current code is that it is 
extremely simple.  There are reasons it could use to be cleaned up (I 
found its producer/consumer model to be a little to implicit to make it 
easy to support loading from highmem proper) but I don't believe in the 
model of going in and mucking with ramfs internals.

	-hpa
