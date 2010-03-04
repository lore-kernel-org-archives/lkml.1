Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0CDDuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:50:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab0CDDtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:49:55 -0500
Date: Wed, 3 Mar 2010 19:49:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Alain Knaff <alain@knaff.lu>,
       Peter Anvin <hpa@zytor.com>
Subject: Re: [GIT PULL] Squashfs updates for 2.6.34
In-Reply-To: <4B8F0A42.5070405@lougher.demon.co.uk>
Message-ID: <alpine.LFD.2.00.1003031925540.7046@localhost.localdomain>
References: <4B8C1873.1080700@lougher.demon.co.uk> <alpine.LFD.2.00.1003030904040.3627@localhost.localdomain> <4B8F0A42.5070405@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Phillip Lougher wrote:
> 
> In my defence with these patches I was trying for the best solution while
> touching as little of the mess as possible.  As that's not acceptable, I'll
> go away and try and fix some of the mess, before trying for another merge.

I know, I understand. The whole thing is messy as hell, I just don't want 
that mess to spread even more.

Let's ask Peter for help. He's been involved with that whole crazy init 
loader decompressor thing.

Peter, see the thread and my unhappiness on lkml (if you don't have any 
other archives, see for example http://lkml.org/lkml/2010/3/3/275).

That whole crazy "let's hide a crappy malloc implementation in a header 
file, and then make things depend on '#ifdef STATIC'" just makes me puke. 
And I'm sure Phillip has been gouging his eyes out too, while he was 
spreading it out into those _new_ crazy header file fragments for each 
decompressor.

So rather than have those crazy header file tricks, can we just add a 
kmalloc() _library_ file for the crazy bootloader crud, so that the 
bootloader could just share header files with the regular kernel, and not 
do that crazy thing?

It's insane having that malloc() implementation, and those STATIC games, 
in a header file, and the games we play with "error()" sometimes being a 
function pointer and sometimes being a function. Crazy, crazy.

So Phillip split up these things:

	#ifdef STATIC
	/* Code active when included from pre-boot environment: */
	#define INIT
	#else
	/* Compile for initramfs/initrd code only */
	#define INIT __init
	static void(*error)(char *m);
	#endif

and I refuse to see three new copies of that disgusting thing (bunzip, 
inflate, lzma). So I'd really _really_ want for the pre-boot environment 
to have that same __init declaration, and the _same_ indirect error() 
handler model, so that we don't have this kind of thing spreading.

It was ugly enough in <compress/mm.h> (which really should be nuked from 
orbit - it's the only way to be sure), but when I see it spreading, I go 
into full zombie-attack mode, and want to start up the chainsaw and run 
around naked.

		Linus
