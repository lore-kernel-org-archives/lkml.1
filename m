Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYFKV3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYFKV3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYFKV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:29:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbYFKV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:29:34 -0400
Date: Wed, 11 Jun 2008 14:29:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: joakim.tjernlund@transmode.se
Cc: adobriyan@parallels.com, akpm@linuxfoundation.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, busybox@busybox.net
Subject: Re: [PATCH] seq_file: make seq_lseek accept SEEK_END
Message-Id: <20080611142909.2e18f2b1.akpm@linux-foundation.org>
In-Reply-To: <1213012375.16530.9.camel@gentoo-jocke.transmode.se>
References: <200806091501.13170.adobriyan@parallels.com>
	<1213012375.16530.9.camel@gentoo-jocke.transmode.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 13:52:55 +0200
Joakim Tjernlund <joakim.tjernlund@transmode.se> wrote:

> busybox has been fixed, at least in trunk, not to do 
> xlseek(fd, 0, SEEK_END) anymore to address this problem.
> Perhaps there are other apps out there that needs this too, but I don't
> know of any. Older busyboxes needs this change though.
> I have moved on and don't have a setup handy where I can test this.
> Perhaps someone at the bb list has, CC:ing bb list.
> 

Nevertheless it'd be nice to fix old versions.

To some extent that depends on when we broke it.  See below.

> 
> On Mon, 2008-06-09 at 15:01 +0400, Alexey Dobriyan wrote:
> > Apologies for delay, such simple thing should have been sent long ago.
> > Joakim, please, confirm.
> > -------------------------------------------
> > [PATCH] seq_file: make seq_lseek accept SEEK_END
> > 
> > and pretend seq_files have zero length. This should be enough
> > to fix busybox start-stop-daemon:
> > http://marc.info/?t=120836691600002&r=1&w=2
> > 
> > It does xlseek(fd, 0, SEEK_END) to estimate amount of memory to malloc
> > but satisfied with 0. Sudden -EINVAL from lseek(2) breaks it.
> > 
> > X-Introduced-By: f16278c679aa72e28288435b313ba2d4494d6be5
> > Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
> > ---
> > 
> >  fs/seq_file.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/fs/seq_file.c
> > +++ b/fs/seq_file.c
> > @@ -254,6 +254,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int origin)
> >  	switch (origin) {
> >  		case 1:
> >  			offset += file->f_pos;
> > +		case 2:
> > +			/* pretend it's zero length */
> >  		case 0:
> >  			if (offset < 0)
> >  				break;
> > 
> > 

Is returning zero logical, given what we do with SEEK_SET?

afait we _could_ just do

	offset = <largenum>
	/* fall through */

and let the SEEK_SET code do its thing.  But I might have misread it. 
But still, it looks like it'd be possible to return a true(ish) value
from SEEK_END?


> > X-Introduced-By: f16278c679aa72e28288435b313ba2d4494d6be5

Please don't do that.  Instead, quote the commit ID _and_ the first few
lines of the commit itself, like:

commit f16278c679aa72e28288435b313ba2d4494d6be5
Author: Hans Rosenfeld <hans.rosenfeld@amd.com>
Date:   Fri Mar 21 18:46:59 2008 -0500

    Change pagemap output format to allow for future reporting of huge pages

And here we see one reason: that commit cannot be the one which
introduced this problem. 
