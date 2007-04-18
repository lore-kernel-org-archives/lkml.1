Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXDRPpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXDRPpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXDRPpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:45:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:28875 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXDRPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aGCORU8dGz9DPYRpa4xdJNHW+iGbX2npa8DDhI16QuCcvD0IHaH62GpSFN5uXvDs99kXcKA4rci2lvaJUQwtLcOOIY33NW0cowzcjj3EAnqTsi3+t32zqCVu3VXMD9J1DfXzvObGZjbR10WyKtjr8jG7rW4oisNzozliXBNiAbk=
Message-ID: <46263D0E.2000702@gmail.com>
Date: Thu, 19 Apr 2007 00:45:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org> <46263A82.1030703@gmail.com>
In-Reply-To: <46263A82.1030703@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> Incidentally, Tejun, I'm all in favor of a immediate-detach driver model 
>> approach.  Unfortunately it's impossible to realize fully, although we 
>> could come much closer than we are now.
>>
>> Here's an example where immediate-detach cannot be implemented.  A driver 
>> binds to a device and uses that device is a kernel thread.  The thread 
>> carries out certain operations which require it to hold the device 
>> semaphore (because, for example, they need to be mutually exclusive with 
>> unbind).
>>
>> The driver's remove() method is called with the semaphore held.  If the
>> thread tries to lock the semaphore at the same time and blocks, there is
>> no way at all for the remove() method to force the thread to drop its
>> reference.
>>
>> This isn't merely a theoretical example.  The USB hub driver works in
>> exactly this way.
> 
> Dunno if I understood the problem right but can't we do the following?
> 
> remove()
> {
> 	acquire sem;
> 	device_del();
> 	release sem;
> 	device_put_wait();
> }

More afterthoughts.  If a mutex is used to protect access against
removal.  There is no reason to hold reference to it.

kernel_thread()
{
	/* wanna dereference my_obj */
	mutex_lock();
	verify my_obj is there and use it if so.
	mutex_unlock();
}

remove()
{
	mutex_lock();
	kill_it();
	mutex_unlock();
}

I probably have over simplified it but using both mutex and reference
counts doesn't make much sense.  IOW, you get an active reference when
you grab the mutex excluding its removal and verified it's still there.

There probably are other reasons why things are done that way and we can
 and probably will have to resort to mixed solutions in foreseeable
future but I don't think there is any inherent problem in applying
immediate-disconnect in the described situation.

Feel free to scream at me if I'm getting it totally wrong.  :-)

Thanks.

-- 
tejun
