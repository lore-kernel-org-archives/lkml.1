Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXGMNFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXGMNFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbXGMNFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:05:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:23834 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758874AbXGMNFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:05:24 -0400
Date: Fri, 13 Jul 2007 15:05:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Message-ID: <20070713130508.GQ5328@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <20070704132346.591348000@pademelon.sonytel.be> <1184331741.3402.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184331741.3402.13.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, James Bottomley wrote:
> On Wed, 2007-07-04 at 15:22 +0200, Geert Uytterhoeven wrote:
> > +                       kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > +                       if (!kaddr)
> > +                               return -1;
> > +                       len = sgpnt->length;
> > +                       if ((req_len + len) > buflen) {
> > +                               active = 0;
> > +                               len = buflen - req_len;
> > +                       }
> > +                       memcpy(kaddr + sgpnt->offset, buf + req_len,
> > len);
> > +                       kunmap_atomic(kaddr, KM_USER0);
> 
> This isn't a SCSI objection, but this sequence appears several times in
> this driver.  It's wrong for a non-PIPT architecture (and I believe the
> PS3 is VIPT) because you copy into the kernel alias for the page, which
> dirties the line in the cache of that alias (the user alias cache line
> was already invalidated).  However, unless you flush the kernel alias to
> main memory, the user could read stale data.  The way this is supposed
> to be done is to do a 
> 
> flush_kernel_dcache_page(kaddr)
> 
> before doing the kunmap.
> 
> Otherwise it looks OK from the SCSI point of view.

Well, even worse is that fact that it's using KM_USER0 from interrupt
context.

-- 
Jens Axboe

