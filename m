Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZILOdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZILOdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZILOdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:33:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:46104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZILOdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:33:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186912163"
Date: Sat, 12 Sep 2009 22:32:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] devmem: remove redundant test on len
Message-ID: <20090912143256.GA6511@localhost>
References: <20090911022333.324128054@intel.com> <20090911023200.518171489@intel.com> <20090911170047.94de0896.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911170047.94de0896.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 08:00:47AM +0800, Andrew Morton wrote:
> On Fri, 11 Sep 2009 10:23:34 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > The len test in write_kmem() is always true, so can be reduced.
> > 
> > CC: Marcelo Tosatti <mtosatti@redhat.com>
> > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > CC: Johannes Berg <johannes@sipsolutions.net>
> > CC: Avi Kivity <avi@qumranet.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  drivers/char/mem.c |   14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> > 
> > --- linux.orig/drivers/char/mem.c
> > +++ linux/drivers/char/mem.c
> > @@ -580,18 +580,16 @@ static ssize_t write_kmem(struct file * 
> >  		while (count > 0) {
> >  			int len = count;
> >  
> >  			if (len > PAGE_SIZE)
> >  				len = PAGE_SIZE;
> > -			if (len) {
> > -				written = copy_from_user(kbuf, buf, len);
> > -				if (written) {
> > -					if (wrote + virtr)
> > -						break;
> > -					free_page((unsigned long)kbuf);
> > -					return -EFAULT;
> > -				}
> > +			written = copy_from_user(kbuf, buf, len);
> > +			if (written) {
> > +				if (wrote + virtr)
> > +					break;
> > +				free_page((unsigned long)kbuf);
> > +				return -EFAULT;
> >  			}
> >  			len = vwrite(kbuf, (char *)p, len);
> >  			count -= len;
> >  			buf += len;
> >  			virtr += len;
> 
> humpf.  But take a closer look at what remains.

Yeah, it asks for more cleanup patches..

> 
> Local var `written' is unneeded here.
> 
> 
> Which makes us look at what `written' _does_ do:
> 
> 		if (written != wrote)
> 			return written;
> 		wrote = written;
> 
> lolwhowrotethat?
> 
> local var `written' can at least be made local to the first loop.

Right, I'll make this straight.

> write_kmem() has a lot of typecasts which indicates that the choices of
> types were inappropriate.

It seems hard to improve because of a fundamental issue: the same
value is taken as both virtual and physical address, and also be
compared and calculated as numbers..

Thanks,
Fengguang

