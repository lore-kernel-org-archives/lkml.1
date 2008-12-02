Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYLBPuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYLBPuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYLBPuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:50:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYLBPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:50:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 16:49:26 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021649.27148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 2 of December 2008, Linus Torvalds wrote:
> 
> On Tue, 2 Dec 2008, Rafael J. Wysocki wrote:
> >  			r_size = resource_size(r);
> >  			/* For bridges size != alignment */
> > -			align = resource_alignment(r);
> > +			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
> 
> Hmm. This means that something set the alignment flags incorrectly. The 
> resource _should_ have IORESOURCE_SIZEALIGN set for a resource with size 
> alignment, and IORESOURCE_STARTALIGN for one that has start alignment.
> 
> Your patch doesn't fix anything, it just hides the bug.

Well, it's just a partial revert of commit
5f17cfce5776c566d64430f543a289e5cfa4538b ("PCI: fix pbus_size_mem() resource
alignment for CardBus controllers"). 

> It would be good to hear what resource this is, and where it got set. So 
> instead of that broken patch that just hides the problem, please try to 
> debug it with something like
> 
> 	resource_size_t expected_align;
> 
> 	expected_align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
> 	align = resource_alignment(r);
> 	if (align != expected_align) {
> 		dev_warn(&dev->dev,
> 			"BAR %d %llx-%llx wrong alignment flags %lx %llx (%llx)\n",
> 			i,
> 			(unsigned long long) r->start,
> 			(unsigned long long) r->end,
> 			r->flags,
> 			(unsigned long long) align,
> 			(unsigned long long) expected_align);
> 		/* Hacky and wrong, but trying to keep things 
> 		align = expected_align;
> 	}
> 
> or something like that. And then we just need to figure out which setup 
> routine sets the wrong alignment flag,.

Yeah, I'll give it a try later today, when I get back from the Uni.

Thanks,
Rafael
