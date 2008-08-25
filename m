Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYHYKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYHYKB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYHYKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:01:50 -0400
Received: from haggis.mythic-beasts.com ([91.135.15.56]:45166 "EHLO
	haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYHYKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:01:49 -0400
Date: Mon, 25 Aug 2008 11:01:22 +0100
From: Keith Wansbrough <keith@lochan.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, alain@linux.lu, linux-kernel@vger.kernel.org,
       gene.heskett@gmail.com, Michael Kerrisk <mtk.manpages@googlemail.com>,
       Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] floppy: support arbitrary first-sector numbers
Message-ID: <20080825100122.GB2784@ayla.home.lochan.org>
References: <20080809184214.GA13495@ayla.home.lochan.org> <20080821123949.fc1af4ba.akpm@linux-foundation.org> <20080821125101.e8a8f256.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821125101.e8a8f256.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-BlackCat-Spam-Score: -13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 12:51:01PM -0700, Randy Dunlap wrote:
> On Thu, 21 Aug 2008 12:39:49 -0700 Andrew Morton wrote:
> 
> > On Sat, 9 Aug 2008 19:42:14 +0100
> > Keith Wansbrough <keith@lochan.org> wrote:
> > 
> > > The current floppy_struct allows floppies to number sectors starting
> > > from 0 or 1.  This patch allows arbitrary first-sector numbers - for
> > > example, 0xC1 for Amstrad CPC disks.
> > > 
> > > This extends the existing 1-bit field (FD_ZEROBASED, bit 2 of stretch) 
> > > to 8 bits (FD_SECTMASK, bits 2 to 9).
> > > 
> > > Currently 0x00 denotes a first sector number of 1, and 0x01 denotes a
> > > first sector number of 0.  We extend this by interpreting FD_SECTMASK
> > > as the first sector number with the LSB flipped.
> > > 
> > > Signed-off-by: Keith Wansbrough <keith@lochan.org>
> > > ---
> > > 
> > > I've tested formatting, writing, and reading disks with a variety of
> > > first sector numbers (including 0 and 1), and all works as expected.
> > > 
> > > I have made corresponding changes to fdutils, which I will submit
> > > separately to the fdutils maintainer.
> > > 
> > > There's no floppy maintainer listed in MAINTAINERS, so this is sent to
> > > the block subsystem maintainer and to the fdutils maintainer.  I'm cc:ing
> > > Gene because I know he's been working in this area recently.
> > > 
> > > --KW 8-)
> > > 
> > > Index: linux-2.6.27-rc1-git4/drivers/block/floppy.c
> > > ===================================================================
> > > --- linux-2.6.27-rc1-git4.orig/drivers/block/floppy.c	2008-08-02 23:36:32.000000000 +0100
> > > +++ linux-2.6.27-rc1-git4/drivers/block/floppy.c	2008-08-02 23:36:37.000000000 +0100
> > > @@ -423,8 +423,15 @@ static struct floppy_raw_cmd *raw_cmd, d
> > >   * 1581's logical side 0 is on physical side 1, whereas the Sharp's logical
> > >   * side 0 is on physical side 0 (but with the misnamed sector IDs).
> > >   * 'stretch' should probably be renamed to something more general, like
> > > - * 'options'.  Other parameters should be self-explanatory (see also
> > > - * setfdprm(8)).
> > > + * 'options'.
> > > + *
> > > + * Bits 2 through 9 of 'stretch' tell the number of the first sector.
> > > + * The LSB (bit 2) is flipped. For most disks, the first sector
> > > + * is 1 (represented by 0x00<<2).  For some CP/M and music sampler
> > > + * disks (such as Ensoniq EPS 16plus) it is 0 (represented as 0x01<<2).
> > > + * For Amstrad CPC disks it is 0xC1 (represented as 0xC0<<2).
> > > + *
> > > + * Other parameters should be self-explanatory (see also setfdprm(8)).
> > >   */
> > >  /*
> > >  	    Size
> > > @@ -2236,9 +2243,9 @@ static void setup_format_params(int trac
> > >  			}
> > >  		}
> > >  	}
> > > -	if (_floppy->stretch & FD_ZEROBASED) {
> > > +	if (_floppy->stretch & FD_SECTBASEMASK) {
> > >  		for (count = 0; count < F_SECT_PER_TRACK; count++)
> > > -			here[count].sect--;
> > > +			here[count].sect += FD_SECTBASE(_floppy) - 1;
> > >  	}
> > >  }
> > >  
> > > @@ -2649,7 +2656,7 @@ static int make_raw_rw_request(void)
> > >  	}
> > >  	HEAD = fsector_t / _floppy->sect;
> > >  
> > > -	if (((_floppy->stretch & (FD_SWAPSIDES | FD_ZEROBASED)) ||
> > > +	if (((_floppy->stretch & (FD_SWAPSIDES | FD_SECTBASEMASK)) ||
> > >  	     TESTF(FD_NEED_TWADDLE)) && fsector_t < _floppy->sect)
> > >  		max_sector = _floppy->sect;
> > >  
> > > @@ -2679,7 +2686,7 @@ static int make_raw_rw_request(void)
> > >  	CODE2SIZE;
> > >  	SECT_PER_TRACK = _floppy->sect << 2 >> SIZECODE;
> > >  	SECTOR = ((fsector_t % _floppy->sect) << 2 >> SIZECODE) +
> > > -	    ((_floppy->stretch & FD_ZEROBASED) ? 0 : 1);
> > > +	    FD_SECTBASE(_floppy);
> > >  
> > >  	/* tracksize describes the size which can be filled up with sectors
> > >  	 * of size ssize.
> > > @@ -3311,7 +3318,7 @@ static inline int set_geometry(unsigned 
> > >  	    g->head <= 0 ||
> > >  	    g->track <= 0 || g->track > UDP->tracks >> STRETCH(g) ||
> > >  	    /* check if reserved bits are set */
> > > -	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_ZEROBASED)) != 0)
> > > +	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_SECTBASEMASK)) != 0)
> > >  		return -EINVAL;
> > >  	if (type) {
> > >  		if (!capable(CAP_SYS_ADMIN))
> > > @@ -3356,7 +3363,7 @@ static inline int set_geometry(unsigned 
> > >  		if (DRS->maxblock > user_params[drive].sect ||
> > >  		    DRS->maxtrack ||
> > >  		    ((user_params[drive].sect ^ oldStretch) &
> > > -		     (FD_SWAPSIDES | FD_ZEROBASED)))
> > > +		     (FD_SWAPSIDES | FD_SECTBASEMASK)))
> > >  			invalidate_drive(bdev);
> > >  		else
> > >  			process_fd_request();
> > > Index: linux-2.6.27-rc1-git4/include/linux/fd.h
> > > ===================================================================
> > > --- linux-2.6.27-rc1-git4.orig/include/linux/fd.h	2008-08-02 23:36:32.000000000 +0100
> > > +++ linux-2.6.27-rc1-git4/include/linux/fd.h	2008-08-02 23:36:37.000000000 +0100
> > > @@ -15,10 +15,16 @@ struct floppy_struct {
> > >  			sect,		/* sectors per track */
> > >  			head,		/* nr of heads */
> > >  			track,		/* nr of tracks */
> > > -			stretch;	/* !=0 means double track steps */
> > > +			stretch;	/* bit 0 !=0 means double track steps */
> > > +					/* bit 1 != 0 means swap sides */
> > > +					/* bits 2..9 give the first sector */
> > > +					/*  number (the LSB is flipped) */
> > >  #define FD_STRETCH 1
> > >  #define FD_SWAPSIDES 2
> > >  #define FD_ZEROBASED 4
> > > +#define FD_SECTBASEMASK 0x3FC
> > > +#define FD_MKSECTBASE(s) (((s) ^ 1) << 2)
> > > +#define FD_SECTBASE(floppy) ((((floppy)->stretch & FD_SECTBASEMASK) >> 2) ^ 1)
> > >  
> > >  	unsigned char	gap,		/* gap1 size */
> > >  
> > 
> > So this is a backward-compatible enhancement to the floppy FDSETPRM and
> > FDDEFPRM ioctl.  If some userspace wasn't setting those bits to zero,
> > it loses, and probably deserved to.
> > 
> > I'd suggest an update to the FDDEFPRM documentation, only it isn't
> > documented.
> > 
> > Who is the fdutils maintainer?
> 
> man fdformat says:
> 
> AVAILABILITY
>        The  fdformat command is part of the util-linux-ng package and is avail-
>        able from ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/.
> 
> so the maintainer is   Karel Zak <kzak@redhat.com>

Andrew - thanks for adding.

Randy - I've cc'd the fdutils maintainer (alain@linux.lu,
http://fdutils.linux.lu) on this patch.  fdutils recommends not using
fdformat(8) but using superformat(1) instead, and uses setfdprm(1) to
set floppy parameters.

I've sent an fdutils patch to Alain, but haven't heard back yet.  I
couldn't find any appropriate docs to update.

Cheers,

--KW 8-)
