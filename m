Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309Ab0AFTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0AFTLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698Ab0AFTLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:11:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:58877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab0AFTLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:11:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,230,1262592000"; 
   d="scan'208";a="481826743"
Date: Wed, 6 Jan 2010 11:11:32 -0800
From: mark gross <mgross@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: 640E9920 <640e9920@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC] PM_QOS api update to use handles 1/5
Message-ID: <20100106191132.GD21316@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20091130010953.GA4732@mgross-laptop>
 <20100104083127.GA1450@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104083127.GA1450@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 09:31:27AM +0100, Pavel Machek wrote:
> On Sun 2009-11-29 17:09:53, 640E9920 wrote:
> > I'm using this crazy email address because I have problems getting to
> > linux.intel.com from home, and my work at intel has changed a bit.
> > 
> > This is the first in a 5 part series that attempts to update PM_QOS to
> > use handles instead of named strings in its kernel api.  It seams that
> > some folks are using pm_qos on hot paths and the overhead of the list
> > walks and string compares is a problem.
> > 
> > Most of the changes came from aili@codeaurora.org, and I spent some time
> > cleaning up the API.
> > 
> > Also, I couldn't resist myself in renaming the API's a bit give the fact
> > that the signatures changed enough that I had to touch all the pm_qos
> > users anyway.  I changed *requirement* to *request* in keeping with the
> > way PM_QOS really only does best effort.  I've felt "requirement" is too
> > strong a word for the way it works.
> 
> Looks good on quick scan. Moving away from strings is certainly good.

thanks I'll target to get this into linux-next for 2.6.34.

> 
> > @@ -384,15 +363,14 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  		size_t count, loff_t *f_pos)
> >  {
> >  	s32 value;
> > -	int pm_qos_class;
> > +	struct pm_qos_request_list *pm_qos_req;
> >  
> > -	pm_qos_class = (long)filp->private_data;
> >  	if (count != sizeof(s32))
> >  		return -EINVAL;
> >  	if (copy_from_user(&value, buf, sizeof(s32)))
> >  		return -EFAULT;
> > -	sprintf(name, "process_%d", current->pid);
> > -	pm_qos_update_requirement(pm_qos_class, name, value);
> > +	pm_qos_req = (struct pm_qos_request_list *)filp->private_data;
> > +	pm_qos_update_request(pm_qos_req, value);
> >  
> >  	return  sizeof(s32);
> >  }
> 
> Umm.. passing binary numbers like that... is not exactly good
> interface. Think endianness issues  when writing to it from high-level
> language.
> 

yeah.  At the moment I can't recall why I went binary for the ABI, 
we can revisit this, but its been in the wild for a few years now :(

I guess I can do some tricks to see if its a hex string representation
of a number and parse that as well as supporting the s32.  i.e. accept
strings "0x0000000" ... "0xFFFFFFFF" and return -EINVAL for anything
else.

--mgross

> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
