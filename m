Return-Path: <linux-kernel-owner+w=401wt.eu-S933705AbXBZAAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbXBZAAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbXBZAAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:00:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701AbXBZAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:00:30 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: David Woodhouse <dwmw2@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <200612112059.kBBKx1j7022473@hera.kernel.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 19:00:57 -0500
Message-Id: <1172448057.3971.9.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2006-12-11 at 20:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d610dd52dd1da696e199e4b4545f33a2a5de5c6
> Commit:     8d610dd52dd1da696e199e4b4545f33a2a5de5c6
> Parent:     8993780a6e44fb4e7ed34e33458506a775356c6e
> Author:     Linus Torvalds <torvalds@woody.osdl.org>
> AuthorDate: Mon Dec 11 12:12:04 2006 -0800
> Committer:  Linus Torvalds <torvalds@woody.osdl.org>
> CommitDate: Mon Dec 11 12:12:04 2006 -0800
> 
>     Make sure we populate the initroot filesystem late enough
>     
>     We should not initialize rootfs before all the core initializers have
>     run.  So do it as a separate stage just before starting the regular
>     driver initializers.
>     
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>

This seems to be what's triggering the apparent memory corruption we've
been seeing recently -- in the case of the Fedora kernel it manifests
itself as a BUG() in cache_alloc_refill() when the pmac ide driver
initialises.

Another report was at http://lkml.org/lkml/2006/12/17/4

We've been seeing it on a Mac Mini too, and I managed to reproduce it on
my shinybook this evening by booting with 'mem=512M'.

One side-effect of this patch is to move the call to free_initrd() much
later in the init sequence, potentially after other memory management
code is assuming it's already been freed.

-- 
dwmw2

