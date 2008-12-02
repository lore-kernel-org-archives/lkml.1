Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYLBDc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYLBDc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYLBDcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:32:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYLBDcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:32:47 -0500
Date: Mon, 1 Dec 2008 19:32:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812020320.31876.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Rafael J. Wysocki wrote:
>  			r_size = resource_size(r);
>  			/* For bridges size != alignment */
> -			align = resource_alignment(r);
> +			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;

Hmm. This means that something set the alignment flags incorrectly. The 
resource _should_ have IORESOURCE_SIZEALIGN set for a resource with size 
alignment, and IORESOURCE_STARTALIGN for one that has start alignment.

Your patch doesn't fix anything, it just hides the bug.

It would be good to hear what resource this is, and where it got set. So 
instead of that broken patch that just hides the problem, please try to 
debug it with something like

	resource_size_t expected_align;

	expected_align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
	align = resource_alignment(r);
	if (align != expected_align) {
		dev_warn(&dev->dev,
			"BAR %d %llx-%llx wrong alignment flags %lx %llx (%llx)\n",
			i,
			(unsigned long long) r->start,
			(unsigned long long) r->end,
			r->flags,
			(unsigned long long) align,
			(unsigned long long) expected_align);
		/* Hacky and wrong, but trying to keep things 
		align = expected_align;
	}

or something like that. And then we just need to figure out which setup 
routine sets the wrong alignment flag,.

		Linus
