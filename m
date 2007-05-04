Return-Path: <linux-kernel-owner+w=401wt.eu-S1767586AbXEDHUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767586AbXEDHUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767598AbXEDHUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:20:37 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56974 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767586AbXEDHUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:20:36 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 03:20:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
In-Reply-To: <20070503231814.e12ad2d7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705040315410.19399@localhost.localdomain>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
 <20070503231814.e12ad2d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Andrew Morton wrote:

> On Sat, 28 Apr 2007 06:23:54 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> > Replace the MAJOR() macro invocation with a call to the inline
> > imajor() routine.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> > diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> > index 6b5b642..08da15b 100644
> > --- a/drivers/block/loop.c
> > +++ b/drivers/block/loop.c
> > @@ -710,7 +710,7 @@ static inline int is_loop_device(struct file *file)
> >  {
> >  	struct inode *i = file->f_mapping->host;
> >
> > -	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
> > +	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
> >  }
>
> there's no runtime change, and I count a couple hundred MAJORs in
> the tree.
>
> I don't want to receive 200 one-line patches please.  If you're
> going to do this then please do decent-sized per-subsystem patches
> and see if you can persuade the subsystem maintainers to take them
> directly.

  you misunderstand the point of that patch.  it's not to replace all
instances of MAJOR(), only those that are being used in specifically
that context -- to extract the major (or minor) number from an inode,
and there's a *very* small number of those:

$ grep -Er "(MINOR|MAJOR).*i_rdev" *
arch/sh/boards/landisk/landisk_pwb.c:   minor = MINOR(inode->i_rdev);
arch/sh/boards/landisk/landisk_pwb.c:   minor = MINOR(inode->i_rdev);
drivers/block/loop.c:   return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
drivers/media/video/ivtv/ivtv-fileops.c:        int minor = MINOR(inode->i_rdev);
include/linux/fs.h:     return MINOR(inode->i_rdev);
include/linux/fs.h:     return MAJOR(inode->i_rdev);
sound/oss/au1550_ac97.c:        int             minor = MINOR(inode->i_rdev);

  it's just standardizing on using the imajor() and iminor() inlines
defined in include/linux/fs.h.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
