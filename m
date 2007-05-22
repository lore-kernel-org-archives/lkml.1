Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbXEVVEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbXEVVEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXEVVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:04:25 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54067 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbXEVVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:04:25 -0400
Message-ID: <46535AD3.9060904@simon.arlott.org.uk>
Date: Tue, 22 May 2007 22:04:19 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: use mutex instead of semaphore in RocketPort driver
References: <200705081903.l48J3lr1012622@hera.kernel.org> <1179853142.3296.1.camel@laptopd505.fenrus.org> <20070522200601.GG22360@traven>
In-Reply-To: <20070522200601.GG22360@traven>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/07 21:06, Matthias Kaehlcke wrote:
> El Tue, May 22, 2007 at 09:59:01AM -0700 Arjan van de Ven ha dit:
> 
>>>  

Please provide context when quoting a patch, git grep takes a while...

>>> -	down_interruptible(&info->write_sem);
>>> +	mutex_lock_interruptible(&info->write_mtx);
>>>  
>>>  #ifdef ROCKET_DEBUG_WRITE
>>>  	printk(KERN_INFO "rp_write %d chars...", count);
>>> @@ -1773,7 +1776,7 @@ end:
>>>  		wake_up_interruptible(&tty->poll_wait);
>>>  #endif
>>>  	}
>>> -	up(&info->write_sem);
>>> +	mutex_unlock(&info->write_mtx);
>>>  	return retval
>> this code is very very buggy.
> 
> more buggy than with the use of a semaphore?
>  
>> mutex_lock_interruptible() may not get the mutex in case a signal
>> happens... and yet you unlox the mutex unconditionally!!!
> 
> as far as i understand only the thread that locked the mutex can
> unlock it (as opposed to semaphores, which can be released by any
> thread/process). obviously this doesn't make the code be more
> correct. what i don't know is how the kernel behaves when
> trying to unlock a mutex the thread doesn't own. another and possibly
> more important problem of the code is that in case of being
> interrupted by a signal the data that should be protected by the
> mutex/semaphore can be accessed/changed by two threads at the same
> time.
> 
> would the following resolve the problem?
> 
> if(mutex_lock_interruptible(&info->write_mtx)) 
>         return -ERESTARTSYS
> 
> thanks for your comments
> 

No. At least one user of tty_operations/tty_driver's write function 
doesn't check the return value so it would never be retried, mutex_lock 
should be used instead.

All of the _interruptible and functions that return -ERESTARTSYS should 
probably use __must_check...

-- 
Simon Arlott
