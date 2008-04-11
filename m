Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYDKGvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYDKGvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYDKGvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:51:04 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:47367 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752926AbYDKGvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:51:02 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-29.messagelabs.com!1207896661!10607362!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 11 Apr 2008 08:50:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UIO: hold a reference to the device's owner while the device is open
Message-ID: <20080411065027.GB18096@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410210229.GF3193@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410210229.GF3193@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Apr 2008 06:50:27.0628 (UTC) FILETIME=[53654EC0:01C89BA0]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--16.599000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hans J. Koch wrote:
> On Thu, Apr 10, 2008 at 02:37:00PM +0200, Uwe Kleine-König wrote:
> > Otherwise the device might just disappear while /dev/uioX is being used
> > which results in an Oops.
> 
> And I'd like to hear Greg's opinion: Do you agree we can omit
> try_module_get() in uio_mmap()?
As Greg already pointed out, mmap only works for open files and so the
reference is already hold there.
 
> >  	if (idev->info->open) {
> > -		if (!try_module_get(idev->owner))
> > -			return -ENODEV;
> >  		ret = idev->info->open(idev->info, inode);
> > -		module_put(idev->owner);
> > -	}
> > +		if (ret) {
> > +			kfree(listener);
> > +err_alloc_listener:
> >  
> > -	if (ret)
> > -		kfree(listener);
> > +			module_put(idev->owner);
> > +err_module_get:
> >  
> > -	return ret;
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> >  }
> 
> I really don't like these labels inside the if-block. I find it hard to
> read. What about this:
> 
> 
> if (idev->info->open) {
> 	ret = idev->info->open(idev->info, inode);
> 	if (ret)
> 		kfree(listener);
> 	return ret;
> }
> 
> err_alloc_listener:
> 	module_put(idev->owner);
> err_module_get:
> 	return ret;
With that you leak a reference to idev->owner if idev->info->open() fails.
Things like that don't happen that easy if all error handing is in one
place.
 
> The label err_module_get should probably be omitted because it's used only
> once and has just one line of code. You could simply write "return ret"
> instead of "goto err_module_get".
This makes code shuffling easier.  For example if someone decides that
try_module_get should be done after allocating listener then you only
have to exchange the two corresponding code blocks and the two groups
(label + cleanup) in the error handling block.
If the error handling is spread over the whole functions you can easily
miss something---as happend above. :-)

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
