Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYDKIpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYDKIpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYDKIpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:45:05 -0400
Received: from www.tglx.de ([62.245.132.106]:47268 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYDKIpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:45:03 -0400
Date: Fri, 11 Apr 2008 10:44:55 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UIO: hold a reference to the device's owner while
	the device is open
Message-ID: <20080411084454.GA3185@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410210229.GF3193@local> <20080411065027.GB18096@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411065027.GB18096@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:50:27AM +0200, Uwe Kleine-König wrote:
> > And I'd like to hear Greg's opinion: Do you agree we can omit
> > try_module_get() in uio_mmap()?
> As Greg already pointed out, mmap only works for open files and so the
> reference is already hold there.

Yes, that's OK.

>  
> > >  	if (idev->info->open) {
> > > -		if (!try_module_get(idev->owner))
> > > -			return -ENODEV;
> > >  		ret = idev->info->open(idev->info, inode);
> > > -		module_put(idev->owner);
> > > -	}
> > > +		if (ret) {
> > > +			kfree(listener);
> > > +err_alloc_listener:
> > >  
> > > -	if (ret)
> > > -		kfree(listener);
> > > +			module_put(idev->owner);
> > > +err_module_get:
> > >  
> > > -	return ret;
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > >  }
> > 
> > I really don't like these labels inside the if-block. I find it hard to
> > read. What about this:
> > 
> > 
> > if (idev->info->open) {
> > 	ret = idev->info->open(idev->info, inode);
> > 	if (ret)
> > 		kfree(listener);
> > 	return ret;
> > }
> > 
> > err_alloc_listener:
> > 	module_put(idev->owner);
> > err_module_get:
> > 	return ret;
> With that you leak a reference to idev->owner if idev->info->open() fails.
> Things like that don't happen that easy if all error handing is in one
> place.

Maybe. It's merely an example to explain what I mean.
Documentation/CodingStyle says nothing about how to place labels, but I
find it best to have all error path exits at the end of a function. All
the UIO code does it that way.

>  
> > The label err_module_get should probably be omitted because it's used only
> > once and has just one line of code. You could simply write "return ret"
> > instead of "goto err_module_get".
> This makes code shuffling easier.  For example if someone decides that
> try_module_get should be done after allocating listener then you only
> have to exchange the two corresponding code blocks and the two groups
> (label + cleanup) in the error handling block.
> If the error handling is spread over the whole functions you can easily
> miss something---as happend above. :-)

Well, it depends. It's all about readability. Any function should be
written in a way that makes it as clear as possible what it does. Your
code is certainly not critical regarding that aspect, but I think it can
still be improved. And a label that is used only once and contains only
one line of code is definetly unnecessary. I don't follow the
maybe-one-day-in-the-future-it-might-be-useful philosophy. I like code
that is as clean and readable as possible _now_. And as this patch is
not just a driver but affects the UIO core, this is even more important.

Could you please send an updated patch?

Thanks,
Hans


