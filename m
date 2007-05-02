Return-Path: <linux-kernel-owner+w=401wt.eu-S2992954AbXEBJcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992954AbXEBJcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992958AbXEBJcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:32:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992954AbXEBJcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:32:21 -0400
Message-ID: <46385A8A.6070405@redhat.com>
Date: Wed, 02 May 2007 11:31:54 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de>	<46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>	<4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>
In-Reply-To: <46363A68.6080201@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
>> I have several ideas on how we can make this work but first I have to
>> ask what is it that you are trying to accomplish?
> 
> The requirements are:
> 
>    1. the domain builder needs to get various information about the
>       guest kernel by inspecting its ELF notes

Doesn't need to be ELF notes.  The current (3.0.5+) domain builder has 
pluggable binary parsers.  Right now there are two:  ELF (obviously ...) 
and binary (with a multiboot-like header).  Filling the informations 
such as virt_base is a function of the parser, so when adding one more 
parser to the domain builder for bzImage kernels the parser could do 
something completely different to gather the needed information ...

> That works OK for a kernel which is compiled to run under Xen and can't
> run in any other environment, but now that we can generate a single
> kernel which can run in any number of different environments, its
> unfortunate that we still need multiple variants of the kernel image.

Yep, although already much better than completely different kernels. 
Most space of a typical distro kernel is modules which are shared even 
with different kernel binaries.

> So, I have no problem in also building a boot protocol info structure,
> and passing that in %esi, so long as I can store a pointer to the
> Xen-specific info as well.

Yep, should work fine.

> I think I'd prefer to have the domain builder decompress/relocate the
> kernel from the bzImage and start it directly, rather than have it
> decompress/relocate itself,

I'd expect that work better too.

> It depends
> on how well it can deal with having paging enabled and being in ring 1. 

Xen direct paging mode requiring (leaf) page tables being mapped 
read-only makes page table manipulation a bit difficult.  Xen has to 
care whenever the memory it maps is a page table.  Native hasn't.

Also switching to a completely different set of page tables isn't easy 
under Xen.  My xen guest kexec patches have to perform some intresting 
tricks because of that ...

> Looks like it might just be a matter of starting up with "enough" memory
> mapped.

Doesn't solve the problem of having to switch from identity mapping to 
the 0xc0000000 one ...

cheers,
   Gerd


