Return-Path: <linux-kernel-owner+w=401wt.eu-S935822AbYEUPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822AbYEUPRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbYEUPRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:17:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59049 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239AbYEUPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:17:00 -0400
Date: Wed, 21 May 2008 08:16:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix sleep-while-holding-spinlock in sata_nv
Message-ID: <20080521081644.3944cc46@infradead.org>
In-Reply-To: <4834323E.1060608@shaw.ca>
References: <fa.m+kShlzXY/wmFlvZXsE0W7wQIxU@ifi.uio.no>
	<48338624.3000304@shaw.ca>
	<20080520214311.2d2aa8d3@infradead.org>
	<4834323E.1060608@shaw.ca>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 08:31:26 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> rjan van de Ven wrote:
> >> I'm not certain this is safe to do it quite this way. It would be
> >> better to keep that spinlock held so that no operations could be in
> >> progress on either port while these operations are happening.
> > 
> > blk_bounce_limit can sleep. that's just a fact of life ;(
> 
> Now it can, for no reason. Under the conditions it was used before,
> it never could.

"never" is.. a dangerous assumption. It depends on the details of what
GFP_DMA exactly means and how the exact zoning in the system is set up.
All of that is undergoing flux (Andi Kleen has been hacking on that for
example)

But yes, on the existing VM layout on a 32 bit X86 system it wouldn't
sleep if you set the mask to exactly 32 bit (except for the bug)

> > the condition under which it sleeps might be slightly buggy on your
> > exact x86 machine... but that doesn't mean that that is guaranteed
> > to be so forever going forward.... it's still a sleeping function.
> 
> More than slightly buggy, I think.. It seems like it is going to be 
> bouncing block layer accesses to devices with 32-bit DMA masks
> through the 16MB ZONE_DMA. If that's what's actually going on, I'm
> surprised there haven't been more regression reports. The fact that
> the function now sleeps when it didn't before is the least of the
> problems here..

you're absolutely right that the current implementation has a bug.
But the sleepy-ness part isn't really part of that bug. When we get
pools to fill for other masks we'll need to sleep as well. Heck,
it's not unthinkable that swiotlb on 64 bit will go do the same...

