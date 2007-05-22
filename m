Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbXEVUEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbXEVUEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbXEVUDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:03:53 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:50286
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754887AbXEVUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:03:52 -0400
Date: Tue, 22 May 2007 22:06:02 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: use mutex instead of semaphore in RocketPort driver
Message-ID: <20070522200601.GG22360@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200705081903.l48J3lr1012622@hera.kernel.org> <1179853142.3296.1.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179853142.3296.1.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, May 22, 2007 at 09:59:01AM -0700 Arjan van de Ven ha dit:

> >  
> > -	down_interruptible(&info->write_sem);
> > +	mutex_lock_interruptible(&info->write_mtx);
> >  
> >  #ifdef ROCKET_DEBUG_WRITE
> >  	printk(KERN_INFO "rp_write %d chars...", count);
> > @@ -1773,7 +1776,7 @@ end:
> >  		wake_up_interruptible(&tty->poll_wait);
> >  #endif
> >  	}
> > -	up(&info->write_sem);
> > +	mutex_unlock(&info->write_mtx);
> >  	return retval
> 
> this code is very very buggy.

more buggy than with the use of a semaphore?
 
> mutex_lock_interruptible() may not get the mutex in case a signal
> happens... and yet you unlox the mutex unconditionally!!!

as far as i understand only the thread that locked the mutex can
unlock it (as opposed to semaphores, which can be released by any
thread/process). obviously this doesn't make the code be more
correct. what i don't know is how the kernel behaves when
trying to unlock a mutex the thread doesn't own. another and possibly
more important problem of the code is that in case of being
interrupted by a signal the data that should be protected by the
mutex/semaphore can be accessed/changed by two threads at the same
time.

would the following resolve the problem?

if(mutex_lock_interruptible(&info->write_mtx)) 
        return -ERESTARTSYS

thanks for your comments

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            Nothing is more despicable than respect based on fear
                              (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
