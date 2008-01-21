Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYAUVYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYAUVYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYAUVYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:24:07 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:33274 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbYAUVYG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:24:06 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <47939363.8040603@kolumbus.fi>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jan 2008 21:23:53 +0000
Message-Id: <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
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


On Sun, 2008-01-20 at 20:30 +0200, Mika Penttilä wrote:
> > + * This is how much memory *in addition to the memory covered up to
> > + * and including _end* we need mapped initially.  We need one bit for
> > + * each possible page, but only in low memory, which means
> > + * 2^32/4096/8 = 128K worst case (4G/4G split.)
> > + *
> > + * Modulo rounding, each megabyte assigned here requires a kilobyte of
> > + * memory, which is currently unreclaimed.
> > + *
> > + * This should be a multiple of a page.
> > + */
> > +#define INIT_MAP_BEYOND_END	(128*1024)
> > +
> > +/*
> >   
> 
> You have dropped the requirement to map all of low memory (the boot 
> allocator is used for instance to construct physical mem mapping). 
> Either you should fix your INIT_MAP_BEYOND_END or make a big comment 
> telling us why it isn't necessary anymore to map low mem.

I think you are right. The patch ensures that all the initial page
tables themselves have mappings but won't map the additional pages
needed for mapping the rest of lowmem.

However, I think it is no longer necessary to map a whole new 4G worth
of page table pages because the code in kernel_physical_mapping_init now
extends the initial mappings rather than replacing them (see changes to
native_pagetable_setup_start). So now we only need to map 4G worth of
page tables including the initial page tables. That means we only need
to map a fixed set of extra pages rather than the sliding limit
currently used in the patch.

I'm not convinced by the additional 16MB for CONFIG_DEBUG_PAGEALLOC --
we map enough pages for page tables for 4G of lowmem -- adding space for
an extra 16M seems pointless.

Ian.
-- 
Ian Campbell

Good-bye.  I am leaving because I am bored.
		-- George Saunders' dying words

