Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZDARny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZDARny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZDARno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:43:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46976 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZDARnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:43:43 -0400
Date: Wed, 1 Apr 2009 18:43:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090401174336.GA14726@srcf.ucam.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401173521.GA15423@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 01:35:21PM -0400, Theodore Tso wrote:
> On Wed, Apr 01, 2009 at 04:12:21PM +0100, Matthew Garrett wrote:
> > On Wed, Apr 01, 2009 at 06:20:50AM +0100, Sitsofe Wheeler wrote:
> > 
> > > Just out of curiosity, when laptop mode is happening is there a
> > > guarantee that writes to other files won't be reordered to before the
> > > fsync? 
> > 
> > laptop-mode does two things - tweak the dirty page semantics slightly 
> > (not in an interestingly relevant way) and call sys_sync() a few seconds 
> > after something hits disk rather than cache. In contrast to Ted's 
> > suggestion that laptop-mode reduces data integrity, it actually enhances 
> > it by opportunistically ensuring that data hits disk. It's the 
> > lengthening of the commit intervals that usually accompanies it that 
> > increases the risk of data loss.
> 
> It *can* reduce data integrity; it really depends on how it's tuned
> and what scenario you're talking about.  To the extent that it uses
> sys_sync(), it could help in some cases as well, since filesystems
> that do delayed allocation will wake up when the commit interval
> fires, and then force out all writes to the disk, yes.  But before the
> commit interval, there is an increased risk of data loss --- which the
> user requested.

Not from laptop-mode. Let's separate the functionality from the typical 
use case.

> The other subtlety comes if we add fsync() suppression to laptop mode
> --- which is something that Bart Samwel is very interested in doing
> and I talked to him at FOSDEM about this.  As Jeff Garzik recently
> pointed out, however, if we let the system reorder writes across
> fsync() boundaries, or if we combine two writes to the same block
> separated by an fsync(), and the system crashes in the middle of
> pushing all of these blocks out to the disk, we can end up trashing
> the consistency guarantees of a database such as mysql or postgres.
> It's a good point, but it only applies if we add fsync() suppression
> to laptop mode --- which we haven't done yet.

I've got absolutely no idea why anyone would want fsync() to stop 
meaning "Put my data on the disk please". laptop-mode isn't intended to 
reduce data integrity - it's intended to batch disk write-outs such that 
there's a lower risk of needing to perform further write-outs in future. 
It makes sense for applications which really desperately want 
information on disk to fsync() (for instance, saving a file in 
OpenOffice).

laptop-mode is something that makes sense as a default behaviour under a 
lot of circumstances. Adding fsync() suppression means it's utterly 
impossible to use it in that way. An additional mode would be perfectly 
reasonable, as long as it's made clear that it's really a request for 
data to be discarded at some point. The current mode isn't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
