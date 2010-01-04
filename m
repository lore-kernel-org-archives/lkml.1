Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143Ab0ADVMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0ADVMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120Ab0ADVMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:12:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57657 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0ADVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:12:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s23qC5iGPAHVUca4Z0nsKfX2312Ko+tRTOASB8CPcBVtkwp+BPtSmhlZ/C2cf8/Ysv
         z/GNK1rqg3PZScusX6PnsrT/589kWxBYfRfsqVUlSbWpX/MVmqmUcU+9h1/0ffplACxW
         5JXv/fZz4tTXfH+NYPeOqGJ3crKTSVaak5uIU=
Date: Mon, 4 Jan 2010 13:12:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
Message-ID: <20100104211233.GA6282@core.coreip.homeip.net>
References: <m1fx6rtu31.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
 <m11vi9c0td.fsf@fess.ebiederm.org>
 <4B3EB687.7000005@kernel.org>
 <m17hs0xjmn.fsf@fess.ebiederm.org>
 <4B3FE586.7020109@kernel.org>
 <20100103074745.GA2314@core.coreip.homeip.net>
 <m1tyv3sbg4.fsf@fess.ebiederm.org>
 <20100104185755.GB2597@core.coreip.homeip.net>
 <m14on1fygh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14on1fygh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 11:43:10AM -0800, Eric W. Biederman wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> > On Sun, Jan 03, 2010 at 02:57:15AM -0800, Eric W. Biederman wrote:
> >> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> >> 
> >> >
> >> > Overall I am not concerned about lockdep bitching about serio because it
> >> > still bitches if you simply reload psmouse on a box with Synaptics with a
> >> > pass-through port even though there are nested annotations and it is
> >> > silent first time around.
> >> 
> >> This is a new lockdep annotation, and looking into it this appears to
> >> be a true possible deadlock in the serio/sysfs interactions.
> >> 
> >> We have serio_pin_driver() called from all of the sysfs attributes
> >> which does:
> >>    mutex_lock(&serio->drv_mutex);
> >> 
> >> We have serio_disconnect_driver() called on an unplug which does:
> >>    mutex_lock(&serio->drv_mutex);
> >> 
> >> The deadlock potential is if someone reads say the psmouse rate
> >> sysfs file while the mouse is being unplugged.  There is a race
> >> such that we can have:
> >> 
> >> 						  sysfs_read_file()
> >>                                                     fill_read_buffer()
> >> 						       sysfs_get_active_two()
> >> 							 psmouse_attr_show_helper()
> >>                                         		   serio_pin_driver()
> >> serio_disconnect_driver()		
> >>   mutex_lock(&serio->drv_mutex);		
> >> 				<----------------->	   mutex_lock(&serio_drv_mutex);
> >>     psmouse_disconnect()
> >>       sysfs_remove_group(... psmouse_attr_group);
> >> 	....
> >> 	sysfs_deactivate(); 
> >> 	  wait_for_completion();
> >> 
> >> 
> >> So it is unlikely but possible to deadlock by accessing a serio
> >> attribute of a serio device that is being removed.
> >
> > Hmm, I guess I was too quick dismissing lockdep complaints here. Now
> > that sysfs remove waits deadlock indeed is possible. Actually the locks
> > on serio->drv_mutex in attributes were added to make sure we don't
> > access device that was unbound from the driver through stale sysfs
> > attributes.
> 
> Cool.  So we have solved the problem generically but we have left over
> layer specific solutions.  That seems like a good problem to have.
> 
> >> What to do about it is another question.
> >
> > I think we should simply not take serio->drv_mutex in attributes and use
> > driver-private mutex to serialize "set" methods that may alter device
> > state.
> 
> Do you have any ideas what those might be?  It looks like we are only
> talking about psmouse and atkbd.  So the audit for this chunk should
> not be too bad.

Right, only these 2.

> 
> The psmouse code already has a mutex on it's set operations only the
> atkbd does not.  The atkbd code does do a driver stop/start, which is
> similar (but race prone without the serio->drv_mutex).
> 
> Except for the lack of atkbd_enable/disable locking the patch below should
> be good.  Opinions from someone who knows the serio code better than I do
> would be helpful.

Thanks Eric, this looks good. I'll add the missing mutex to atkbd and
apply. I think it can wait for .34 though - the window is quite small.

-- 
Dmitry
