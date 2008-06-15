Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYFOXDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYFOXDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbYFOXDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:03:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:30124 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbYFOXCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hhGVdrp98DCoFA1uxCrbyvVBHUz1jFJKrxInc1Gwbo0XFtm9NmkCSm6nlxv19ypH6o
         fk2IaxURvKyUIgR1TVy1agfhhrLRdZMGk+I2qGjw/rQHtVyaoppZQHsnhbqkNjD7rfSH
         stBk3cVFrYCzoxYAREJQTK5uLQ2CZc6AfYR98=
Date: Mon, 16 Jun 2008 02:58:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: joakim.tjernlund@transmode.se, adobriyan@parallels.com,
       akpm@linuxfoundation.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, busybox@busybox.net
Subject: Re: [PATCH] seq_file: make seq_lseek accept SEEK_END
Message-ID: <20080615225835.GA7221@martell.zuzino.mipt.ru>
References: <200806091501.13170.adobriyan@parallels.com> <1213012375.16530.9.camel@gentoo-jocke.transmode.se> <20080611142909.2e18f2b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611142909.2e18f2b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 02:29:09PM -0700, Andrew Morton wrote:
> On Mon, 09 Jun 2008 13:52:55 +0200
> Joakim Tjernlund <joakim.tjernlund@transmode.se> wrote:
> 
> > busybox has been fixed, at least in trunk, not to do 
> > xlseek(fd, 0, SEEK_END) anymore to address this problem.
> > Perhaps there are other apps out there that needs this too, but I don't
> > know of any. Older busyboxes needs this change though.
> > I have moved on and don't have a setup handy where I can test this.
> > Perhaps someone at the bb list has, CC:ing bb list.
> > 
> 
> Nevertheless it'd be nice to fix old versions.
> 
> To some extent that depends on when we broke it.  See below.
> 
> > 
> > On Mon, 2008-06-09 at 15:01 +0400, Alexey Dobriyan wrote:
> > > Apologies for delay, such simple thing should have been sent long ago.
> > > Joakim, please, confirm.
> > > -------------------------------------------
> > > [PATCH] seq_file: make seq_lseek accept SEEK_END
> > > 
> > > and pretend seq_files have zero length. This should be enough
> > > to fix busybox start-stop-daemon:
> > > http://marc.info/?t=120836691600002&r=1&w=2
> > > 
> > > It does xlseek(fd, 0, SEEK_END) to estimate amount of memory to malloc
> > > but satisfied with 0. Sudden -EINVAL from lseek(2) breaks it.
> > > 
> > > X-Introduced-By: f16278c679aa72e28288435b313ba2d4494d6be5
> > > Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
> > > ---
> > > 
> > >  fs/seq_file.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > --- a/fs/seq_file.c
> > > +++ b/fs/seq_file.c
> > > @@ -254,6 +254,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int origin)
> > >  	switch (origin) {
> > >  		case 1:
> > >  			offset += file->f_pos;
> > > +		case 2:
> > > +			/* pretend it's zero length */
> > >  		case 0:
> > >  			if (offset < 0)
> > >  				break;
> > > 
> > > 
> 
> Is returning zero logical, given what we do with SEEK_SET?

Definitely illogical. :-)

> afait we _could_ just do
> 
> 	offset = <largenum>
> 	/* fall through */
> 
> and let the SEEK_SET code do its thing.  But I might have misread it. 

If it's largenum, not enough output will be generated during each
iteration until kmalloc() will refuse to give more memory.

> But still, it looks like it'd be possible to return a true(ish) value
> from SEEK_END?

I think this is doable.

On the other side is
a) ugliness (remember how much output each item generates, remember ->index,
   allocate memory to do that),
b) SEEK_END reported and reports zero-length for other proc files
   (and sysctls), and nobody really cared.

