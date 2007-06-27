Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbXF0NiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbXF0NiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXF0NiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:38:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:28960 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXF0Nh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r0jSeRVcODGRqb4JejG6Ad1009NgXiB3+gqroQbhJgfk0bwffxeaaFP6Wzwznp1XCgdyL530zJrqhidfa5NsvFZHBk6Zk+XFvnj/F5pIJsRk4vlY4gFxoMnzQxJd3Aa+mTZPkcf4cPFK7/MM+ZkqeK299RTu3SV1EWM/ESGsWFI=
Message-ID: <d120d5000706270637i6d37da6eve86f65dadc5c128a@mail.gmail.com>
Date: Wed, 27 Jun 2007 09:37:58 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] atkbd: cleanup only once
Cc: "Dave Young" <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070627052744.GA21354@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627105907.GA1802@darkstar.te-china.tietoenator.com>
	 <200706270034.09802.dtor@insightbb.com>
	 <20070627042820.GC13513@suse.de>
	 <200706270059.33550.dtor@insightbb.com>
	 <20070627052744.GA21354@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jun 27, 2007 at 12:59:32AM -0400, Dmitry Torokhov wrote:
> > On Wednesday 27 June 2007 00:28, Greg KH wrote:
> > > On Wed, Jun 27, 2007 at 12:34:09AM -0400, Dmitry Torokhov wrote:
> > > > Hi Dave,
> > > >
> > > > On Wednesday 27 June 2007 06:59, Dave Young wrote:
> > > > > Hi,
> > > > >
> > > > > If you press ctrl+alt+del several times as kernel booting (before user level bootin), the kernel will oops. I found the ps2_command is called more than once, then the ps2dev->serio maybe NULL pointer.
> > > > >
> > > > > 2.6.22-rc5 and 2.6.22-rc6 have same result.
> > > > >
> > > > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > > > ---
> > > > > diff -upr linux/drivers/input/keyboard/atkbd.c linux.new/drivers/input/keyboard/atkbd.c
> > > > > --- linux/drivers/input/keyboard/atkbd.c        2007-06-27 10:38:37.000000000 +0000
> > > > > +++ linux.new/drivers/input/keyboard/atkbd.c    2007-06-27 10:37:39.000000000 +0000
> > > > > @@ -795,6 +795,11 @@ static int atkbd_activate(struct atkbd *
> > > > >
> > > > >  static void atkbd_cleanup(struct serio *serio)
> > > > >  {
> > > > > +       static int flag;
> > > > > +
> > > > > +       if(flag)
> > > > > +               return;
> > > > > +       flag = 1;
> > > >
> > > > Unfortunately this will prevent atkbd from resetting keyboard on 2nd
> > > > suspend attempt. It will also not work if you have an active MUX and
> > > > have a couple of keyboards connected.
> > > >
> > > > Greg, now that you removed rwsem from subsystem (and subsystem itself
> > > > for that matter) there is nothing as far as I can see that stops
> > > > several threads from running device_shutdown() simultaneously. I also
> > > > do not see what would isolate device probing and shutting them down
> > > > at the same time. Am I missing something?
> > >
> > > There was never anything stopping that from happening before.  No driver
> > > core code was using that rwsem, so it wasn't protecting anything,
> > > despite people trying to use it as if it was :)
> > >
> >
> > It did protect device_shutdown() from itself, didn't it?
>
> Hm, yeah, it did, but that was it.  If that was its goal, it sure wasn't
> obvious at all.
>
> Do you think the driver core needs to serialize this?
>

I think that we need to have device tree (or rather list) stable while
we performing system-wide state transitions, such as shutdown.
Otheriwse if device_shutdown runs simultaneously with device discovery
and new devices get added to the list we risk leaving them (and
potentially thier parents) running. I think we had something like that
before klist conversion - kobject_add was taking device_subsys.rwsem.
However there are dangers if some device goes offline on its own right
in the middle of shutdown process and bus code deadlocks... Maybe we
only need to disable adding new devices in suspend/shutdown path while
allowing removal... I am not sure.

Overall there is lack of consistent locking in suspend/shutdown area:
shutdown interface uses BKL, suspend (swsusp et all) uses pm_mutex and
C_A_D handler does not have any locking at all at the moment.

> thanks,
>
> greg k-h
>


-- 
Dmitry
