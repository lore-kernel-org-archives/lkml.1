Return-Path: <linux-kernel-owner+w=401wt.eu-S968294AbXEHOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968294AbXEHOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968287AbXEHOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:43:21 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:42331 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968285AbXEHOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:43:20 -0400
Subject: Re: [PATCH] Cleanup libata HPA support
From: Ben Collins <ben.collins@ubuntu.com>
To: Mark Lord <liml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Kyle McMartin <kyle@ubuntu.com>, linux-ide@vger.kernel.org
In-Reply-To: <46407ED4.9090301@rtr.ca>
References: <1178621978.6962.75.camel@cunning>  <46407ED4.9090301@rtr.ca>
Content-Type: text/plain
Organization: Canonical
Date: Tue, 08 May 2007 16:43:14 +0200
Message-Id: <1178635394.6962.97.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 09:44 -0400, Mark Lord wrote:
> Ben Collins wrote:
> ..
> >  static u64 ata_tf_to_lba48(struct ata_taskfile *tf)
> >  {
> > -	u64 sectors = 0;
> > +	u64 sectors;
> > +	u32 high, low;
> >  
> > -	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
> > -	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
> > -	sectors |= (tf->hob_lbal & 0xff) << 24;
> > -	sectors |= (tf->lbah & 0xff) << 16;
> > -	sectors |= (tf->lbam & 0xff) << 8;
> > -	sectors |= (tf->lbal & 0xff);
> > +	high = (tf->hob_lbah << 16) |
> > +	       (tf->hob_lbam <<  8) |
> > +		tf->hob_lbal;
> > +	low  = (tf->lbah << 16) |
> > +	       (tf->lbam <<  8) |
> > +		tf->lbal;
> >  
> > -	return ++sectors;
> > +	sectors = ((u64)high << 24) | low;
> > +
> > +	return sectors + 1;
> >  }
> 
> Ben, I very much prefer the fixed version of this function
> as implemented by the patch above.
> 
> But.. is the original code actually broken, or just messy?

Due to the bugs we were seeing, we actually noticed that this function
was having signed extension issues as originally implemented. I didn't
look for the actual bug, but reimplemented it based on code in
ide_disk.c, which resolved the issue.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

