Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbXEDMWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbXEDMWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXEDMV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:21:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41537 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbXEDMV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:21:58 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 08:21:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
In-Reply-To: <Pine.LNX.4.61.0705041340310.18504@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705040809510.24097@localhost.localdomain>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
 <20070503231814.e12ad2d7.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0705041008180.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705040410390.20834@localhost.localdomain>
 <Pine.LNX.4.61.0705041340310.18504@yvahk01.tjqt.qr>
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

On Fri, 4 May 2007, Jan Engelhardt wrote:

> On May 4 2007 04:14, Robert P. J. Day wrote:
> >> On May 3 2007 23:18, Andrew Morton wrote:
> >> >>  	struct inode *i = file->f_mapping->host;
> >> >>
> >> >> -	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
> >> >> +	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
> >> >>  }
> >> >
> >> >there's no runtime change, and I count a couple hundred MAJORs in the tree.
> >>
> >> Why do we even have imajor() if all it does is calling the MAJOR()
> >> macro?
> >
> >  i'm guessing it's to hide the underlying implementation of
> >extracting the major/minor numbers from an inode, in case that
> >implementation ever changes, which strikes me as perfectly reasonable.
>
> How often has the implementation changed? I think i_rdev has been
> there for a looong time. But yes, doing the MAJOR => imajor
> conversion is preferable. Because you don't need the struct
> declaration for inode then, and may omit to #include <linux/fs.h>.
> (Other things may need fs.h so it's a bit of a corner case.)
>
> >  all i was doing was standardizing the small handful of holdouts.
>
> Please continue, this was not a rant :)

that was it, that one-line patch.  as i pointed out, the entire source
tree currently contains precisely this set of holdouts:

arch/sh/boards/landisk/landisk_pwb.c:   minor = MINOR(inode->i_rdev);
arch/sh/boards/landisk/landisk_pwb.c:   minor = MINOR(inode->i_rdev);
drivers/block/loop.c:   return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
drivers/media/video/ivtv/ivtv-fileops.c:        int minor = MINOR(inode->i_rdev);
include/linux/fs.h:     return MINOR(inode->i_rdev);
include/linux/fs.h:     return MAJOR(inode->i_rdev);
sound/oss/au1550_ac97.c:        int             minor = MINOR(inode->i_rdev);

  the first two are SH-related and i mailed the SH maintainer offline
about them, that previous patch was for the loop.c file, i'm not sure
who's in charge of video/ivtv (hints?), the next two lines are the
header files that define the functions, and i long ago decided not to
invest any time cleaning anything in the OSS directory.

  so, really, it's all of four lines that need to be updated to
complete the job.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
