Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZDBLhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZDBLhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZDBLhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:37:39 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40495 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbZDBLhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:37:38 -0400
Date: Thu, 2 Apr 2009 12:37:31 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Theodore Tso <tytso@mit.edu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402113731.GB24532@sucs.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401173521.GA15423@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

That's fair enough and always seemed to be part of the bargain (let the
disk spin down for longer but risk losing 30 seconds of non-synced
recent data in a crash). The result shouldn't be corruption though.

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

eek.

If this goes in it needs to come with scary warnings so a distro doesn't
enable it by default (think of all those sqlite database that are
springing up). I know my system is crummy, all of this is only concerned
with if the system crashes uncontrollably (which it shouldn't do) and I
don't do things that would make it safer (like mount with sync) because
I like the speed but there's a risk limit. I don't want to increase my
chances of corruption (as opposed to "just" loss of non recent data) to
be too high...

-- 
Sitsofe | http://sucs.org/~sits/
