Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZDUVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZDUVby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZDUVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:31:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58651 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZDUVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:31:40 -0400
Date: Tue, 21 Apr 2009 15:31:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
Message-ID: <20090421213139.GB1926@parisc-linux.org>
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org> <49EE3AD2.7030100@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE3AD2.7030100@xenotime.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 02:29:54PM -0700, Randy Dunlap wrote:
> > Fix READ CAPACITY 10 with drives over 1TB
> > 
> > Shifting an unsigned char implicitly casts it to a signed int.  This
> > caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> > which was not supported by at least one drive.  Making 'lba' an unsigned
> > int ensures that sign extension will not occur.
> > 
> > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 3fcb64b..c856b1b 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -1373,7 +1373,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >  	int sense_valid = 0;
> >  	int the_result;
> >  	int retries = 3;
> > -	sector_t lba;
> > +	unsigned lba;
> 
> sector_t is either unsigned long or u64, depending on CONFIG_LBD.
> Are you saying (implying) that the higher-order bits of it don't matter here?
> If so, I'd just like for that to be clear(er).

We're reading 32 bits of information from the drive response.  The top
32 bits are implicitly zero.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
