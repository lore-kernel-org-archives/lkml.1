Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXDPSju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXDPSju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXDPSju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:39:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:56975 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbXDPSjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TUbnb/BjDj2v1B1+tz9ANWqnJLTFw9+F9fpVKkBILUzEKp0zrdTTKlgO9ZQgep9qbKrMTrE3GEDJYNQJnRsdCGpiQGqwx/FZZcgjVTA6oIi8afzxZ/edL7jd34frWPv+AOCXwZFW1QB3dX0d3l7E6+gXtwjcAQAnfBaQPTh8378=
Date: Tue, 17 Apr 2007 00:11:57 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrw Morton <akpm@linux-foundation.org>
Subject: Re: [KJ][PATCH]Rocket port:use mutex instead of binary  semaphore
Message-ID: <20070416184157.GC9314@arun.site>
References: <20070416174155.GA9314@arun.site> <adabqho8b65.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adabqho8b65.fsf@cisco.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:46 Mon 16 Apr     , Roland Dreier wrote:
>  > -	down_interruptible(&info->write_sem);
>  > +	if(mutex_lock_interruptible(&info->write_lock)){
>  > +		return -ERESTARTSYS;
>  > +	}
> 
> 1) This is a semantic change.  Of course using down_interruptible()
> without checking the return value is almost certainly a bug, but have
> you thought about whether returning ERESTARTSYS is correct here?  If
> you have, then please include the reasoning in your patch description.
> (Another possibility would be to just use an uninterruptible mutex_lock())
no,frankly not much..
and something which i didn't understand is
why a down  in one control path & an down_interruptible in other?

but i had in mind,which you rightly pointed out 
handling the return from _interruptible.

i have some bits and pieces of information regarding thie,
searching for more, and correction to my current understanding,
  so that i can make something meaningfull out of it.

earlier kernels used to return in EINTR & it was up to the use space to 
handle the interrupted system call. ..reissue..


then ERESTARTSYS mechanism was added and the kernel could restart the 
syscall on its own

so its up to us whether we want the interruption to be taken care by 
the userspace or kernel.
i.e return EINTR or ERESTARTSYS respectively.
CMIIW.


also i read somewhere that
ERESTARTSYS should never be seen by user space code.  The kernel should
either restart the current syscall or convert the code to EINTR before
returning to user space.  If you are seeing ERESTARTSYS in user space
then it is a kernel bug.


> 2) The coding style for the if statement is not quite right.  The
> correct way is to do
> 
> 	if (condition)
> 		one_liner;
> 
> (note the space between the 'if' and the '(', and no braces used)
> 
ok.. got it..

-- 
Milind Arun Choudhary
