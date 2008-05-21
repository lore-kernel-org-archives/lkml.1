Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbYEUXwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbYEUXwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbYEUXwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:52:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757699AbYEUXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:52:34 -0400
Date: Wed, 21 May 2008 16:51:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
In-Reply-To: <18484.44691.477859.334222@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2008, Paul Mackerras wrote:
>
> Linus Torvalds writes:
> 
> > Me personally, I've been more irritated by include/asm-xyz vs arch/xyz. It 
> > would be so nice if all the arch-specific changes woudl always show up 
> > under arch/ (both from a statistics standpoint, and just because then a 
> > diffstat really shows arch-specific stuff really obviously, and sorts all 
> > the arch-specific stuff together).
> 
> We could git mv include/asm-xyz arch/xyz/asm and then arrange to pass
> -Iarch/$(ARCH) to gcc.

That would work, but there's a few alternatives that I think would work 
even better.

The downside with what you suggest is that I'd like the arch-specific 
include files to be clearly separated (ie I think the naming should be 
"something/include/something", which makes things clearer. 

Also, I hate how doing '-Iarch/$(ARCH)' would basically make any random 
arch/xyz/ subdirectory be a potential location for a header file. I'd hate 
for the include-path to contain subdirectories that simply aren't meant 
for that (ie #include <kernel/tls.h> would now quite by mistake find the 
*private* header file in arch/x86/kernel/tls.h that was never meant to be 
generally visible!)

So the trivial alternative is to just do

	git mv include/asm-xyz arch/xyz/include

and keep the symlink that we already set up (just make it point to 
arch/xyz/include instead of include/asm-xyz). That is conceptually the 
smallest change.

But the alternative I'd actually *prefer* would avoid the symlink, and 
would be roughly:

	for i in $(arch-list)
	do
		mkdir arch/$i/include
		git mv include/asm-$i arch/$i/asm
		
	done
	git mv include/asm-generic include/asm

and then remove the symlink to asm entirely, and instead add a 
-Iarch/xyz/include, and put that as the *first* entry in the include path.

This would mean that:

 - no symlink games

 - if some architecture just uses the generic header file, it doesn't need 
   to do anything: it just wouldn't implement that header file at all, and 
   the next entry in the search-path would just find the generic 
   include/asm entry.

I dunno. It's not a huge deal, but it really would be nice to have all the 
arch/xyz code together for diffstat's etc.

		Linus
