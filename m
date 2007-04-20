Return-Path: <linux-kernel-owner+w=401wt.eu-S2992984AbXDTP5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992984AbXDTP5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993261AbXDTP53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:57:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:62059 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992984AbXDTP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:57:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QsGOOTfvnzZEJe9ZWGUzkb7ase4J55YmwLrPAiciV6p2qlCGu+wzg0Vygyn7r5JdOf1ZPyCi4dIjGaSssFBxQ/7KwDiLu0us/G4WdXN+GGtXswC572V3Hkdfs5SAJmOyOo2qEGwYKofT8j4UGuHGrI+ml0OaLqYuOrSwj/oW4P8=
Message-ID: <d120d5000704200857s6661f700ifc18084b32675db0@mail.gmail.com>
Date: Fri, 20 Apr 2007 11:57:27 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Tejun Heo" <htejun@gmail.com>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <Pine.LNX.4.44L0.0704201016260.2616-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46284F2A.4000401@gmail.com>
	 <Pine.LNX.4.44L0.0704201016260.2616-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Dmitry, in thinking things over some more I realized there's going to be a
> problem with the autosuspend support in USB.  It has to do with the way a
> driver needs to prevent (or block) suspends from occurring while it is
> actively using a device.
>
> To understand this, you need to know that USB adds a pm_mutex to the
> device structure.  It gets used for synchronizing all suspend- or
> resume-related activities.  In particular, the driver's suspend() method
> is called with usbdev->pm_mutex held.
>
> The next idea is that a driver needs to synchronize its remove() method
> with other methods such as read() -- we mustn't allow read() to try and
> refer to the device after the driver has been unbound.  Let's say the
> driver has unbind_mutex embedded in its private data structure for this
> purpose.
>
> Now consider what read() has to do.  It needs to block suspends from
> occurring while it runs, and it needs to do an autoresume if the device
> was already suspended.  So read() will look like this:
>
>        mutex_lock(&private->unbind_mutex);
>        if (private->gone) {
>                ret = -ENODEV;
>                goto done;
>        }
>        if (private->suspended)
>                autoresume(private->usbdev);
>        ...
>  done:
>        mutex_unlock(&private->unbind_mutex);
>        return ret;
>
> Meanwhile, the suspend() method needs to block while read() is running.
> So it will look like this:
>
>        private->suspended = 1;
>        mutex_lock(&private->unbind_mutex);
>        /* Now the driver has quiesced */
>        mutex_unlock(&private->unbind_mutex);
>
> Here's the problem:  The autoresume() call inside read() tries to acquire
> usbdev->pm_mutex while holding private->unbind_mutex.  The suspend()
> method does the reverse, a locking-order violation.
>
> So far I haven't figured out any way to make this work.  Do you have a
> suggestion?  (Don't say read() should hold pm_mutex as well as
> unbind_mutex; that's no good -- although the reason is rather obscure.)
>

First of all I think that I would merge pm and unbind mutex into one -
you also need to synchronize resume and suspend with bind and unbind
so you pretty much need to always acquire both of them.

Second (and I admit I have not followed USB autoresume discussions, my
usb-devle backlog is over 5000 messages ;( ) is I am not sure why
woudl a read block autoresume. I can see write doing that but passive
reads should not affect device state.

-- 
Dmitry
