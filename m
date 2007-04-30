Return-Path: <linux-kernel-owner+w=401wt.eu-S1946616AbXD3Su4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946616AbXD3Su4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946625AbXD3Suz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:50:55 -0400
Received: from gw.goop.org ([64.81.55.164]:41849 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946616AbXD3SuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:50:00 -0400
Message-ID: <46363A68.6080201@goop.org>
Date: Mon, 30 Apr 2007 11:50:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org> <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I have several ideas on how we can make this work but first I have to
> ask what is it that you are trying to accomplish?
>   

The requirements are:

   1. the domain builder needs to get various information about the
      guest kernel by inspecting its ELF notes
   2. we start the kernel in 32-bit mode with paging enabled, in ring 1
   3. the guest kernel needs various pieces of runtime information from
      the hypervisor about its runtime environment

At the moment we just load a bare vmlinux kernel with a xen-specific
entrypoint, so 1 and 2 are easy.  3 is achieved by having the domain
builder start the kernel with %esi pointing to a Xen info structure
which tells the kernel what it needs to know.

That works OK for a kernel which is compiled to run under Xen and can't
run in any other environment, but now that we can generate a single
kernel which can run in any number of different environments, its
unfortunate that we still need multiple variants of the kernel image.

Clearly the Xen domain builder needs to be extended to deal with a
bzImage format kernel directly, so we can use the same actual kernel
image for native and Xen booting.  Since we're changing the domain
builder anyway, I can change the details of how it works so long as the
3 requirements can still be met.

So, I have no problem in also building a boot protocol info structure,
and passing that in %esi, so long as I can store a pointer to the
Xen-specific info as well.  Some info will be duplicated, like the
initrd location, but that's OK.

I'd already reserved a Xen bootloader ID specifically with this in mind;
all I really need is a place where I can stash the pointer.

I think I'd prefer to have the domain builder decompress/relocate the
kernel from the bzImage and start it directly, rather than have it
decompress/relocate itself, but I'm not really set on that.  It depends
on how well it can deal with having paging enabled and being in ring 1. 
Looks like it might just be a matter of starting up with "enough" memory
mapped.

So the biggest unknown is where to put the Xen ELF notes.

    J
