Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab0BCJri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:47:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab0BCJrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:47:36 -0500
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
From: Bastien Nocera <hadess@hadess.net>
To: Michael Poole <mdpoole@troilus.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <87bpg7glf7.fsf@troilus.org>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <87bpg7glf7.fsf@troilus.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 03 Feb 2010 09:47:20 +0000
Message-ID: <1265190440.32444.8417.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 20:25 -0500, Michael Poole wrote:
> Bastien Nocera writes:
> 
> > On Fri, 2010-01-29 at 19:46 -0500, Michael Poole wrote:
> >> > [1]: Comments on the patch at
> >> > http://thread.gmane.org/gmane.linux.bluez.kernel/4279 would be
> >> > appreciated
> >> 
> >> This patch does not work for me.  Before, the first time after each
> >> boot
> >> that I tried to connect to an Apple Magic Mouse, it failed with -14
> >> (EFAULT).  With this patch, it fails with -22 (EINVAL) instead.  The
> >> -EFAULT *was* due to hidp_parse()'s copy_from_user().  I have not
> >> looked
> >> yet to see where the -EINVAL is coming from -- would that help?  (Both
> >> with and without your patch, the second attempt to connect works.) 
> >
> > I don't get -EFAULT anymore (it was failing to copy the rd_data from
> > user-space), but I do get -EINVALs now. I haven't investigated it
> > though. My guess is that the hid parser fails.
> >
> > Could you compare the sizes of the data gathered in user-space?
> 
> The bug mysteriously disappeared when I tried to apply kgdb to the
> problem.  Your patch won't do the trick because the hidp_connadd_req
> structure has also gone out of scope by the time the hid-(whatever)
> probe function is called.  The ioctl has returned to the user, but the
> new hid-(whatever) module is not yet loaded.

Right. I knew that rd_data would already be out of scope, didn't think
about the hidp_connadd_req structure itself.

I guess we should make a copy of the rd_data/rd_size in hidp_setup_hid()
instead.

> That is, the sequence looks like this:
> 
>   - Application triggers hidp_sock_ioctl(socket, HIDPCONNADD, &connadd).
>     - This starts the connection, and returns 0...
>     - ... but also indicates that some other module needs to be loaded.
> 
>   - User-space loads the appropriate module does init_module()...
>     - which calls the module_init() function...
>     - which calls hid_register_driver()...
>     - which eventually attaches the new driver to the device...
>     - triggering the module's probe() function to call hid_parse()...
>     - hid_parse() fails because its hidp_connadd_req is gone.
> 
> Marcel, I think this is a case where the subsystem maintainer should
> make the call on how to fix it.  I can write and locally test a patch,
> but I don't want to assume that (for example) the desired solution is to
> keep a copy of the Report descriptor in the hidp_session.

I would think it would be the cleanest way to do it. Quite a few members
of the hidp_connadd_req structure are already copied into the session in
hidp_setup_hid().

>   The USB HID
> core sends a GET_DESCRIPTOR request for the Report descriptor, which
> isn't practical here because that descriptor is only available through
> SDP.

And we only do SDP queries in user-space...

If you're not going to work on it shortly, I can take a look at cooking
a patch by the end of the week. Otherwise, I'd be happy testing your
patches.

Cheers

