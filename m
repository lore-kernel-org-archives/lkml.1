Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYH0Woh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYH0Woh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbYH0WoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:44:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:13863 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYH0WoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ph6FzrykRf4C6wHNC9WMCS/odxQiI2M2Z3zMGtK1b6HbQOG7GvwNY/gS7P2woqcYxX
         JmaAAy1D0BrI5gxF4Vo9BAEm7ankI9gkwNyMPPkq+qwyXxhYLkj4YzKRf6ZVMT37yFOU
         0YNon8nznQLDttZGGny1095AJEjaVRs5WdDrU=
Date: Thu, 28 Aug 2008 02:45:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Osterlund <petero2@telia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080827224556.GA2361@x200.localdomain>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <20080827230828.4285022b@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 03:38:16PM -0700, Linus Torvalds wrote:
> On Wed, 27 Aug 2008, Alan Cox wrote:
> > 
> > Easier just to fix it. Its a case of building everything until it
> > compiles with the prototype change. Almost all stuff  will just take the
> > argument initially and not use it.
> > 
> > Anyone else plan to do it or shall I hit all the x86 cases and post a
> > patch ?
> 
> Well, I alrady reverted it, but if you actually fix unlocked_ioctl() to 
> have the same calling convention as regular ioctl() then a lot of the 
> noise from ioctl conversion goes away, and all that remains is literally 
> just the BKL part.
> 
> Btw, why is unlocked_ioctl returning "long"? Does anybody depend on that 
> too? That's another difference between the "unlocked" and the traditional 
> version..
> 
> As to the "x86 cases", I think you should try to hit them all. Doing a 
> "git grep unlocked_ioctl" gets 185 entries, and it looks like only 
> something like 8 of them are non-x86 (3 in the arch/ directory, five in 
> s390 drivers).
> 
> Of course, some of them may be drivers that aren't available on x86 for 
> other reasons (ie the ARM embedded stuff), but regardless..
> 
> Anyway, the pure size of that patch makes me suspect that we might as well 
> leave it until the next merge window, but if you do it and it's obviously 
> totally mechanical, I'd be likely to just let it slip in early.

Anybody doing this, don't forget to actually use "inode" instead of all those
dereferences:

	struct inode *inode = filp->f_path.dentry->d_inode;

