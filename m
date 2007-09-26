Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbXIZIWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbXIZIWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXIZIWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:22:32 -0400
Received: from www.osadl.org ([213.239.205.134]:49448 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751262AbXIZIWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:22:32 -0400
Subject: Re: [discuss] 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       discuss@x86-64.org
In-Reply-To: <46FA274B.76E4.0078.0@novell.com>
References: <200709251353.52723.rjw@sisk.pl>
	 <20070925090819.a7c6c3f3.akpm@linux-foundation.org>
	 <46FA274B.76E4.0078.0@novell.com>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 10:22:30 +0200
Message-Id: <1190794950.23376.21.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 08:32 +0100, Jan Beulich wrote:
> >ioremap_nocache() does __ioremap(..., _PAGE_PCD);, then __ioremap() does
> >ioremap_page_range(..., _PAGE_PCD | other_stuff) That's one.
> >
> >__ioremap() then does ioremap_change_attr(..., _PAGE_PCD);.  That's two.
> >
> >So I _think_ we're setting _PAGE_PCD twice on those pte's?  Unclear.  The
> >implementation is rather different from i386, too.
> >
> >I dunno why __change_page_attr() failed though.  Perhaps this, in
> >change_page_attr_addr():
> >
> >		if (!kernel_map || pte_present(pfn_pte(0, prot))) {
> >
> >should be &&
> 
> Definitely not, and this code has been that way for a while.
> 
> I rather suspect this change
> 
> -	if (!kpte) return 0;
> +	if (!kpte)
> +		return -EINVAL;
> 
> to be the reason for the failure (and I had already sent a comment to this
> respect to Andi upon his review request).

This change exposes the problem. The question is why we do not have a
page table entry for the address, which was mapped right before that.

	tglx


