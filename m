Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbXHAXeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbXHAXeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXHAXeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:34:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60577 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXHAXeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:34:36 -0400
Date: Thu, 2 Aug 2007 05:16:59 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
In-Reply-To: <20070801053509.GA5905@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
 <20070801053509.GA5905@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,


On Wed, 1 Aug 2007, Alexey Dobriyan wrote:

> On Tue, Jul 31, 2007 at 10:04:10PM +0530, Satyam Sharma wrote:
> > Callers (especially "store" functions for sysfs or configfs attributes)
> > that want to convert an input string to a number may often also want to
> > check for simple input sanity or allowable range. strtol10_check_range()
> > of netconsole does this, so extract it out into lib/vsprintf.c, make it
> > generic w.r.t. base, and export it to the rest of the kernel and modules.
> 
> > --- a/drivers/net/netconsole.c
> > +++ b/drivers/net/netconsole.c
> > @@ -335,9 +307,11 @@ static ssize_t store_enabled(struct netconsole_target *nt,
> >  	int err;
> >  	long enabled;
> >  
> > -	enabled = strtol10_check_range(buf, 0, 1);
> > -	if (enabled < 0)
> > +	enabled = strtol_check_range(buf, 0, 1, 10);
> > +	if (enabled < 0) {
> > +		printk(KERN_ERR "netconsole: invalid input\n");
> >  		return enabled;
> > +	}
> 
> Please, copy strtonum() from BSD instead. Nobody needs another
> home-grown converter.

BSD's strtonum(3) is a detestful, horrible shame.

The strtol_check_range() I implemented here does _all_ that strtonum()
does, plus is generic w.r.t. base, and minus the tasteless "errstr"
argument.

Tell me, how does that "errstr" ever make sense? We _anyway_ return
errors (-EINVAL or -ERANGE) if any of those cases show up. And
_because_ we use negative numbers to return errors, we can't use this
function to convert negative inputs anyway ... an appropriate error
message can always be outputted by the caller itself. [ hence the
two WARN_ON's I added here ]

But yeah, considering this implementation is so similar to strtonum(3)
(minus the shortcomings, that is :-) we can probably rename it to
something like kstrtonum() ... and we should probably be returning
different errors for the two invalid conditions, yes.


Thanks,
Satyam
