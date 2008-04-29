Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYD2EJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYD2EJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYD2EJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:09:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:43535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYD2EJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:09:05 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 14:09:20 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18454.40816.524759.863861@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 007 of 9] md: prevent duplicates in bind_rdev_to_array
In-Reply-To: message from Andrew Morton on Monday April 28
References: <20080429133104.20146.patches@notabene>
	<1080429033527.20385@suse.de>
	<20080428205108.874eb9e3.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 28, akpm@linux-foundation.org wrote:
> On Tue, 29 Apr 2008 13:35:27 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > 
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > Found when trying to reassemble an active externally managed array.
> > Without this check we hit the more noisy "sysfs duplicate" warning in
> > the later call to kobject_add.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Neil Brown <neilb@suse.de>
> > 
> > ### Diffstat output
> >  ./drivers/md/md.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff .prev/drivers/md/md.c ./drivers/md/md.c
> > --- .prev/drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
> > +++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
> > @@ -1369,6 +1369,11 @@ static int bind_rdev_to_array(mdk_rdev_t
> >  		MD_BUG();
> >  		return -EINVAL;
> >  	}
> > +
> > +	/* prevent duplicates */
> > +	if (find_rdev(mddev, rdev->bdev->bd_dev))
> > +		return -EEXIST;
> > +
> >  	/* make sure rdev->size exceeds mddev->size */
> >  	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
> >  		if (mddev->pers) {
> 
> Smells racy.  Do we have enough locking in place here to make this more
> than a best-effort thing?


Yes.  We have exclusive access to the mddev at this point, so no race.

NeilBrown
