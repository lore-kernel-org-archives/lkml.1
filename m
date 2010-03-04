Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0CDExO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:53:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab0CDExM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:53:12 -0500
Message-ID: <4B8F3C94.9030805@zytor.com>
Date: Wed, 03 Mar 2010 20:52:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Alain Knaff <alain@knaff.lu>
Subject: Re: [GIT PULL] Squashfs updates for 2.6.34
References: <4B8C1873.1080700@lougher.demon.co.uk> <alpine.LFD.2.00.1003030904040.3627@localhost.localdomain> <4B8F0A42.5070405@lougher.demon.co.uk> <alpine.LFD.2.00.1003031925540.7046@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003031925540.7046@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 07:49 PM, Linus Torvalds wrote:
> 
> So rather than have those crazy header file tricks, can we just add a 
> kmalloc() _library_ file for the crazy bootloader crud, so that the 
> bootloader could just share header files with the regular kernel, and not 
> do that crazy thing?
> 
> It's insane having that malloc() implementation, and those STATIC games, 
> in a header file, and the games we play with "error()" sometimes being a 
> function pointer and sometimes being a function. Crazy, crazy.
> 

If with library you mean a linking library, that won't work everywhere,
because on some platforms the early-kernel decompressor needs to be
compiled with differently than the kernel as a whole.  However, it would
be easy enough to have a source-level library (I don't mean an include
file, obviously) and a common include file to wrap this all up in.

> So Phillip split up these things:
> 
> 	#ifdef STATIC
> 	/* Code active when included from pre-boot environment: */
> 	#define INIT
> 	#else
> 	/* Compile for initramfs/initrd code only */
> 	#define INIT __init
> 	static void(*error)(char *m);
> 	#endif
> 
> and I refuse to see three new copies of that disgusting thing (bunzip, 
> inflate, lzma). So I'd really _really_ want for the pre-boot environment 
> to have that same __init declaration, and the _same_ indirect error() 
> handler model, so that we don't have this kind of thing spreading.

Such a common header file for the preboot environment could simply do:

#undef __init

... and be done with it.  That way we don't have to worry about mucking
with $DEITY knows how many linker scripts... it seems the easiest, and
would certainly eliminate any uglies outside the common file.

> It was ugly enough in <compress/mm.h> (which really should be nuked from 
> orbit - it's the only way to be sure), but when I see it spreading, I go 
> into full zombie-attack mode, and want to start up the chainsaw and run 
> around naked.

OK, we really really don't want that... simply because there just aren't
enough zombies to go around already.  Last I heard, the EPA was
considering classifying them as an endangered species, only to get stuck
in a bureaucratic mess if they can be classified as a "species" at all,
or if they should be classified together with bread mold, toxic waste
and Microsoft salesmen.

The only problem with this is that it'll touch nearly every
architecture, so it probably is going to have to be .35 material.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

