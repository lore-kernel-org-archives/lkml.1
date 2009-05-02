Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZEBPD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZEBPD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbZEBPDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:03:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:27069 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZEBPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <20090501141235.733d4b1b@lxorguk.ukuu.org.uk>
References: <1241097822.2516.3.camel@poy>
	 <9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com>
	 <ac3eb2510905010413y6b35e817nf948cedbe076cd4d@mail.gmail.com>
	 <9b2b86520905010538p2d781eedhd7bed86ab908c990@mail.gmail.com>
	 <20090501141235.733d4b1b@lxorguk.ukuu.org.uk>
Date: Sat, 2 May 2009 11:03:15 -0400
Message-ID: <f73f7ab80905020803hf5bae32i7f7b871e34f4e557@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Kyle Moffett <kyle@moffetthome.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 9:12 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> a) running before /dev/null and /dev/console requires hacks
>
> Not really, well not if you are writing a serious small tool anyway. In
> actual fact the bigger problem if you are using the standard dynamic
> link setup (which you wouldn't be I suspect) is /dev/zero.
>
>> b) it requires an initramfs
>> c) it pulls everything that hooks into or otherwise affects udev into
>> the initramfs; that's much more than we have at present, and a bigger
>> initramfs' can only make bootup _slower_.
>
> Ditto a bigger kernel. Remember moving stuff from initramfs to the kernel
> makes it less memory efficient usually as its now harder to get rid of
> and not pageable later on either.

Hmm... I'm almost curious how early it is possible to start userspace,
if you ensure that the userspace is very careful to limit its
dependencies.  Specifically, you could actually include software
that's little more than a paged kernel thread with its own mm.  If
there's any userspace code that we would really want to be updated in
lockstep with the kernel (possibly this udev-replacement), it could be
originally linked as part of the kernel image and later marked as
swappable pages.

So then the essential questions would be things like:

*  How early can rootfs be set up? (even if not yet populated from the
initramfs)
*  How early can pipefs be ready?
*  What syscalls are safe from that early of a context?

If those questions have satisfactory answers, you could basically
build a mini-udev as a part of the kernel, perhaps even with a
device-table automatically extracted from a specific section by the
linker script.  It would also be useful without an initramfs, as it
could replace the existing root= name-to-dev_t lookup code with
something swappable.

Cheers,
Kyle Moffett
