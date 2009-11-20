Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZKTXvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZKTXvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZKTXvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:51:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZKTXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:51:50 -0500
Date: Fri, 20 Nov 2009 15:51:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jslaby@novell.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Char: cyclades, fix compiler warning
Message-Id: <20091120155152.1fe79030.akpm@linux-foundation.org>
In-Reply-To: <20091120174328.GB14888@kroah.com>
References: <20091114080505.7715b022.akpm@linux-foundation.org>
	<1258546702-29591-1-git-send-email-jslaby@novell.com>
	<20091120174328.GB14888@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 09:43:28 -0800
Greg KH <greg@kroah.com> wrote:

> > diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
> > index a188c05..e026f24 100644
> > --- a/drivers/char/cyclades.c
> > +++ b/drivers/char/cyclades.c
> > @@ -595,14 +595,8 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
> >  	channel = save_xir & CyIRChannel;
> >  	save_car = readb(base_addr + (CyCAR << index));
> >  	cy_writeb(base_addr + (CyCAR << index), save_xir);
> > -	info = &cinfo->ports[channel + chip * 4];
> >  
> > -	/* validate the port# (as configured and open) */
> > -	if (channel + chip * 4 >= cinfo->nports) {
> > -		cy_writeb(base_addr + (CySRER << index),
> > -			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
> > -		goto end;
> > -	}
> > +	info = &cinfo->ports[channel + chip * 4];
> 
> Wierd, but this doesn't apply at all to my or Linus's tree.  Are there
> some other cyclades patch floating around out there that is needed here
> before this one?

Jiri's patch is based on top of my initial half-assed fix.  Against
mainline:

From: Jiri Slaby <jslaby@novell.com>

With gcc 4.0.2:
drivers/char/cyclades.c: In function 'cyy_interrupt':
drivers/char/cyclades.c:581: warning: 'info' may be used uninitialized in this function

introduced by

: commit 3aeea5b92210083c7cffd4f08a0bb141d3f2d574
: Author:     Jiri Slaby <jirislaby@gmail.com>
: AuthorDate: Sat Sep 19 13:13:16 2009 -0700
: Commit:     Live-CD User <linux@linux.site>
: CommitDate: Sat Sep 19 13:13:16 2009 -0700
:
:    cyclades: introduce cyy_readb/writeb

In fact the true branch which uses uninitialized 'info' can never
happen because chip is always less than ->nchips and channel is
always less than 4 which we alloc.

So behave similar to rx handling and remove the test completely.

I wonder why gcc 4.4.1 doesn't spit a word.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jiri Slaby <jslaby@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-compiler-warning drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-compiler-warning
+++ a/drivers/char/cyclades.c
@@ -598,12 +598,6 @@ static void cyy_chip_tx(struct cyclades_
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
-	/* validate the port# (as configured and open) */
-	if (channel + chip * 4 >= cinfo->nports) {
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
-		goto end;
-	}
 	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
_

