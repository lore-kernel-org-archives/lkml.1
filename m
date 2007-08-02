Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXHBEZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXHBEZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXHBEZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:25:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:56889 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXHBEZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=apuRCmPHqBiWPWTtzUyjR05wz7LW4MmVCWMotBNv4VbdLuAQYkH0BfbxODvyt1kXk/Goepk8zpk9XtOGPHolOeKFh6Z4TdorS/VDrNJdCv3uvhL4mosqlxnLMXgJ8RiY9r4+oa8v5Ocj1KHblPystbDS4+J42UoGpbZrZ3NJxWE=
Date: Thu, 2 Aug 2007 08:25:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
Message-ID: <20070802042528.GA5797@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in> <20070801053509.GA5905@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 05:16:59AM +0530, Satyam Sharma wrote:
> On Wed, 1 Aug 2007, Alexey Dobriyan wrote:
> 
> > On Tue, Jul 31, 2007 at 10:04:10PM +0530, Satyam Sharma wrote:
> > > Callers (especially "store" functions for sysfs or configfs attributes)
> > > that want to convert an input string to a number may often also want to
> > > check for simple input sanity or allowable range. strtol10_check_range()
> > > of netconsole does this, so extract it out into lib/vsprintf.c, make it
> > > generic w.r.t. base, and export it to the rest of the kernel and modules.
> > 
> > > --- a/drivers/net/netconsole.c
> > > +++ b/drivers/net/netconsole.c
> > > @@ -335,9 +307,11 @@ static ssize_t store_enabled(struct netconsole_target *nt,
> > >  	int err;
> > >  	long enabled;
> > >  
> > > -	enabled = strtol10_check_range(buf, 0, 1);
> > > -	if (enabled < 0)
> > > +	enabled = strtol_check_range(buf, 0, 1, 10);
> > > +	if (enabled < 0) {
> > > +		printk(KERN_ERR "netconsole: invalid input\n");
> > >  		return enabled;
> > > +	}
> > 
> > Please, copy strtonum() from BSD instead. Nobody needs another
> > home-grown converter.
>
> BSD's strtonum(3) is a detestful, horrible shame.
>
> The strtol_check_range() I implemented here does _all_ that strtonum()
> does, plus is generic w.r.t. base,

What you did with base argument is creating opportunity to fsckup,
namely, forgetting that base is last and putting it second.

> and minus the tasteless "errstr"
> argument.
>
> Tell me, how does that "errstr" ever make sense? We _anyway_ return
> errors (-EINVAL or -ERANGE) if any of those cases show up. And
> _because_ we use negative numbers to return errors, we can't use this
> function to convert negative inputs anyway ... an appropriate error
> message can always be outputted by the caller itself. [ hence the
> two WARN_ON's I added here ]
>
> But yeah, considering this implementation is so similar to strtonum(3)
> (minus the shortcomings, that is :-) we can probably rename it to
> something like kstrtonum() ...

> and we should probably be returning
> different errors for the two invalid conditions, yes.

