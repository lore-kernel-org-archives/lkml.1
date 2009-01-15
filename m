Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZAOQgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZAOQgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZAOQgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:36:36 -0500
Received: from websrv.werbeagentur-aufwind.de ([88.198.253.206]:35391 "EHLO
	websrv.werbeagentur-aufwind.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbZAOQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:36:35 -0500
Subject: Re: OOPS and panic on 2.6.29-rc1 on xen-x86
From: Christophe Saout <christophe@saout.de>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, linux-mm@kvack.org
In-Reply-To: <3e8340490901141619g3c32ebads482d1176efbd98a3@mail.gmail.com>
References: <20090112172613.GA8746@shion.is.fushizen.net>
	 <3e8340490901122054q4af2b4cm3303c361477defc0@mail.gmail.com>
	 <20090114025910.GA17395@wotan.suse.de>
	 <3e8340490901141619g3c32ebads482d1176efbd98a3@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 17:36:32 +0100
Message-Id: <1232037392.4604.4.camel@leto.intern.saout.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 14.01.2009, 19:19 -0500 schrieb Bryan Donlan:
> On Tue, Jan 13, 2009 at 9:59 PM, Nick Piggin <npiggin@suse.de> wrote:
> > On Mon, Jan 12, 2009 at 11:54:32PM -0500, Bryan Donlan wrote:
> >>
> >> I've bisected the bug in question, and the faulty commit appears to be:
> >> commit e97a630eb0f5b8b380fd67504de6cedebb489003
> >> Author: Nick Piggin <npiggin@suse.de>
> >> Date:   Tue Jan 6 14:39:19 2009 -0800
> >>
> >>     mm: vmalloc use mutex for purge
> >>
> >>     The vmalloc purge lock can be a mutex so we can sleep while a purge is
> >>     going on (purge involves a global kernel TLB invalidate, so it can take
> >>     quite a while).
> >>
> >>     Signed-off-by: Nick Piggin <npiggin@suse.de>
> >>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >>
> >> The bug is easily reproducable by a kernel build on -j4 - it will
> >> generally OOPS and panic before the build completes.
> >> Also, I've tested it with ext3, and it still occurs, so it seems
> >> unrelated to btrfs at least :)
> >>
>
> Here's one from a config with CONFIG_DEBUG_BUGVERBOSE:
> 
> ------------[ cut here ]------------
> kernel BUG at /root/linux-2.6/arch/x86/include/asm/mmu_context_32.h:39!

For the record, I was getting the same bug on x86_64:

(in mmu_context_64.h):

...
#ifdef CONFIG_SMP
        else {
                write_pda(mmu_state, TLBSTATE_OK);
                if (read_pda(active_mm) != next)    
                        BUG();
...

Christophe


