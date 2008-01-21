Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYAUVq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYAUVq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYAUVqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:46:52 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:42090 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYAUVqv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:46:51 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <479510CE.7010706@zytor.com>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jan 2008 21:46:36 +0000
Message-Id: <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 13:38 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > On Sun, 2008-01-20 at 20:30 +0200, Mika Penttilä wrote:
> >>>   
> >> You have dropped the requirement to map all of low memory (the boot 
> >> allocator is used for instance to construct physical mem mapping). 
> >> Either you should fix your INIT_MAP_BEYOND_END or make a big comment 
> >> telling us why it isn't necessary anymore to map low mem.
> > 
> > I think you are right. The patch ensures that all the initial page
> > tables themselves have mappings but won't map the additional pages
> > needed for mapping the rest of lowmem.
> > 
> > However, I think it is no longer necessary to map a whole new 4G worth
> > of page table pages because the code in kernel_physical_mapping_init now
> > extends the initial mappings rather than replacing them (see changes to
> > native_pagetable_setup_start). So now we only need to map 4G worth of
> > page tables including the initial page tables. That means we only need
> > to map a fixed set of extra pages rather than the sliding limit
> > currently used in the patch.
> > 
> 
> We still need to be able to construct those page tables, which is what 
> that stuff is about...

Yes, my initial patch was wrong. However with the patch we no longer
throw away the non-PAE initial page tables and replace them with PAE
ones, instead we augment the initial PAE page tables. This means we only
need initial mappings of 4G worth of page tables rather than 4G plus
what is needed for the non-PAE initial page tables.

I don't think I explained that at all well on either attempt...
Hopefully what I mean will be clearer in patch form -- coming in a
second...

> > I'm not convinced by the additional 16MB for CONFIG_DEBUG_PAGEALLOC --
> > we map enough pages for page tables for 4G of lowmem -- adding space for
> > an extra 16M seems pointless.
> 
> If so, adjusting the limit should be a separate patch.
> 
> Either way, I'm increasingly thinking that setting up the initial page 
> tables via an assembly loop instead of worrying about the C accessors is 
> actually cleaner (I prototyped it yesterday, although I still need the 
> rest of the machinery.)

I'm just preparing to send out a version which uses the native_* way of
doing things, its not actually as clean as I would like so I'd be
interested to see the ASM variant.

Ian.
-- 
Ian Campbell

You shall be rewarded for a dastardly deed.

