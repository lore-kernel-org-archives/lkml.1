Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYKQVLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYKQVLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYKQVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:09:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959AbYKQVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:09:48 -0500
Date: Mon, 17 Nov 2008 13:09:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Steven Rostedt wrote:
>
>  45)     4992    1280   .block_read_full_page+0x23c/0x430
>  46)     3712    1280   .do_mpage_readpage+0x43c/0x740

Ouch.

> Notice at line 45 and 46 the stack usage of block_read_full_page and 
> do_mpage_readpage. They each use 1280 bytes of stack! Looking at the start 
> of these two:
> 
> int block_read_full_page(struct page *page, get_block_t *get_block)
> {
> 	struct inode *inode = page->mapping->host;
> 	sector_t iblock, lblock;
> 	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];

Yeah, that's unacceptable.

Well, it's not unacceptable on good CPU's with 4kB blocks (just an 8-entry 
array), but as you say:

> On PPC64 I'm told that the page size is 64K, which makes the above equal 
> to: 64K / 512 = 128  multiply that by 8 byte words, we have 1024 bytes.

Yeah. Not good. I think 64kB pages are insane. In fact, I think 32kB 
pages are insane, and 16kB pages are borderline. I've told people so.

The ppc people run databases, and they don't care about sane people 
telling them the big pages suck. It's made worse by the fact that they 
also have horribly bad TLB fills on their broken CPU's, and years and 
years of telling people that the MMU on ppc's are sh*t has only been 
reacted to with "talk to the hand, we know better".

Quite frankly, 64kB pages are INSANE. But yes, in this case they actually 
cause bugs. With a sane page-size, that *arr[MAX_BUF_PER_PAGE] thing uses 
64 bytes, not 1kB.

I suspect the PPC people need to figure out some way to handle this in 
their broken setups (since I don't really expect them to finally admit 
that they were full of sh*t with their big pages), but since I think it's 
a ppc bug, I'm not at all interested in a fix that penalizes the _good_ 
case.

So either make it some kind of (clean) conditional dynamic non-stack 
allocation, or make it do some outer loop over the whole page that turns 
into a compile-time no-op when the page is sufficiently small to be done 
in one go.

Or perhaps say "if you have 64kB pages, you're a moron, and to counteract 
that moronic page size, you cannot do 512-byte granularity IO any more".

Of course, that would likely mean that FAT etc wouldn't work on ppc64, so 
I don't think that's a valid model either. But if the 64kB page size is 
just a "database server crazy-people config option", then maybe it's 
acceptable.

Database people usually don't want to connect their cameras or mp3-players 
with their FAT12 filesystems.

			Linus
