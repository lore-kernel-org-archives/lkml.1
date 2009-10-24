Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZJXSO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZJXSO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 14:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZJXSOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 14:14:55 -0400
Received: from icculus.org ([67.106.77.212]:50145 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZJXSOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 14:14:55 -0400
Date: Sat, 24 Oct 2009 14:14:54 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: "Anton D. Kachalov" <mouse@mayc.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
In-Reply-To: <4AE2C218.2040306@mayc.ru>
Message-ID: <alpine.OSX.1.10.0910241242570.2441@caridad.icculuslan>
References: <4AE17C1A.4060009@mayc.ru> <alpine.OSX.1.10.0910231933550.2186@caridad.icculuslan> <4AE2C218.2040306@mayc.ru>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > How does setarch work? Does it reorder the file before launching or copy out
> > one of the ELF records? 
> >   
> $ man setarch

Huh, I guess that explains the personality() thing in your patch.  :)

> > The most compelling feature of this approach is that a "truearch" binary (is
> > that the correct name?) could work with any existing Linux system, on the
> > condition that the architecture you want is the first one in the file.   
> Nope, you may put binary files in any order. It's just a linked list of
> binaries.

I was talking about an unpatched kernel in this case. Without a kernel 
change, it rejects the ELF file if the first architecture isn't the one it 
wants. So your approach is slightly better for backwards compatibility 
than mine, but not significantly so.

For a full compatibility plan, you'd probably still need to write 
something like fatelf-extract.

> As a previous state, you will able run x86_64. But you need to change order of
> binfmt and compat_binfmt in built-in.o by changing Makefile. Just swap two
> lines. I don't know why on x86_64 system first we try compat mode than native
> while simple run of native app will take more cpu cycles on x86_64 Vs. x86.

I think it was a bug. It got corrected sometime after the 2.6.28 release 
that your patch was based on (I ran into that this week, too), 
register_binfmt() adds to the other side of the list now, so the Makefile 
doesn't need changing.

> Which arch will be "fatelf-extract"? Let's say, If I'm running Linux on
> PowerPC? x86? =) Only if it is a shell script, it will be beneficial for any
> arch. I can inject "offset" portion in script file too...

Presumably, it'll be installed system-wide (as either an ELF or FatELF 
binary), like setarch, or built by the user if they don't otherwise have 
FatELF support. setarch and fatelf-extract are both simple C programs.

   http://fedorahosted.org/setarch/browser/setarch.c
   http://hg.icculus.org/icculus/fatelf/raw-file/tip/utils/fatelf-extract.c

> Nope, it just read "offset" field and seek if needed. So, if file is just
> one-arch, it will read 128 bytes only.

But if it's 10 architectures?

> In my approach, it's just a few seeks more. Just a few additional reads are
> not so much compared to overall reads from that file.

Yes, I'm not sure it's a serious concern, even if you put 200 binaries in 
there and have to iterate them all, the overhead is probably not serious. 
Still, it seems like a better practice to keep these things closer to O(1) 
when possible.

> It's necessary if you would like to use setarch to choose binaries on biarch
> systems.

I didn't understand that when I first looked at the patch; sorry for any 
confusion I caused. I should probably add a similar test to FatELF.

--ryan.

