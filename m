Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYLCWdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYLCWdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYLCWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:33:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:11265 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYLCWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NLWpc17kAslUlRrmAnRrKbN/V9PmC8yxCma86BpZyLpr79ZwYpTHgecFFDKIlXqLnL
         gpwSz0mZDI76C3j2xqRSDblb5T6ijeHkt7BxOfOHeWCHkV+Q1ZLzdjmMATGjMf490B2W
         TaVuwBT9ycJusRls5TYQh4h+JJ+uNTnSNJcpc=
Subject: Re: [RFC PATCH-mm] usb: file_storage use unaligned endian helpers
 rather than private versions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0812031615470.2181-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0812031615470.2181-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 14:33:06 -0800
Message-Id: <1228343586.5412.115.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 16:29 -0500, Alan Stern wrote:
> On Tue, 2 Dec 2008, Harvey Harrison wrote:
> 
> > Use the new helpers for unaligned endian access.  Make some small changes
> > to reading 24-bit lba values, read the full 32 bit value and mask.  Produces
> > smaller and faster code on x86 and on powerpc.
> > 
> > Coalesce some byte-writes in 32bit writes to allow byteswapping to happen
> > at compile time and become a 32-bit write without swapping if possible (x86
> > especially)
> > 
> > This shrinks the size of file_storage.o by ~64 bytes on x86_32.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Alan, what do you think?
> 
> Well, it looks correct... but it's awfully ugly.  Can't we keep the 
> benefits of the new helpers while not messing the code up too much?

<snip>

> Suppose instead we do this:
> 
> #define get_be16(buf)	load_be16_noalign((be16 *) (buf))
> #define get_be24(buf)	(load_be32_noalign((be32 *) (buf)) >> 8)
> #define get_be32(buf)	load_be32_noalign((be32 *) (buf))
> 
> #define put_be16(buf, val)	store_be16_noalign((be16 *) (buf), val)
> #define put_be32(buf, val)	store_be32_noalign((be32 *) (buf), val)
> 
> Then almost no more changes would be needed, only the 24-bit
> consolidation stuff.
> 

I'd rather the common functions just get used directly and cast as
necessary...but it's your code.  Or define a few generic structs
and get a pointer to those and get typechecking for free.

> > @@ -1583,9 +1552,9 @@ static int do_read(struct fsg_dev *fsg)
> >  	/* Get the starting Logical Block Address and check that it's
> >  	 * not too big */
> >  	if (fsg->cmnd[0] == SC_READ_6)
> > -		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
> > +		lba = load_be32_noalign((__be32 *)&fsg->cmnd[0]) & 0xffffff;
> 
> Like this, which would become
> 
> 		lba = get_be24(&fsg->cmnd[1]);

Again, I could live with it, but would suggest just coding it directly and
maybe just add a comment that this really only wants 24 bits (I thought it was 21 bits,
but then again, I know next to squat about scsi).  <shrug>

> 
> > @@ -2126,9 +2095,9 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
> >  static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
> >  {
> >  	struct lun	*curlun = fsg->curlun;
> > -	u32		lba = get_be32(&fsg->cmnd[2]);
> > +	u32		lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
> >  	int		pmi = fsg->cmnd[8];
> > -	u8		*buf = (u8 *) bh->buf;
> > +	__be32		*buf = (__be32 *)bh->buf;
> >  
> >  	/* Check the PMI and LBA fields */
> >  	if (pmi > 1 || (pmi == 0 && lba != 0)) {
> > @@ -2136,8 +2105,8 @@ static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
> >  		return -EINVAL;
> >  	}
> >  
> > -	put_be32(&buf[0], curlun->num_sectors - 1);	// Max logical block
> > -	put_be32(&buf[4], 512);				// Block length
> > +	store_be32_noalign(&buf[0], curlun->num_sectors - 1);	// Max logical block
> > +	store_be32_noalign(&buf[1], 512);			// Block length
> >  	return 8;
> >  }
> >  
> 
> I don't like these changes.  You've gone from an array of bytes to an
> array of 32-bit words, which doesn't agree with the data structures
> defined in the SCSI specification.  Besides, with my new macros this
> isn't needed.

OK, if you'd rather keep the array-of-bytes and use the offsets method,
that's fine too.

Something like (is this really so bad?):

	store_be32_noalign((__be32 *)&buf[0], curlun->num_sectors - 1);
	store_be32_noalign((__be32 *)&buf[4], 512);

> What do you think?

Personally I don't think it's that ugly just using the common functions
directly. BTW, note that if you know the alignment, there are aligned versions
coming as well.  YMMV.

Harvey

