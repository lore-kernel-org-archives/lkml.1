Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXD1Jrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXD1Jrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXD1Jrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:47:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:4497 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbXD1Jrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HeDC+ZIcoVLo1a0OtJj29rVTVWVyMka1Co9c6aYjdufUuc6iHhbT6Bgwh8tEj6ObcYWHVzNAD4gGfn+WI53eau/IGJC+SvlI3ttdw8mP6jTD2lPxKhrGREYlXb6ZGBlOlLYRDQxszqh53oSNEvNctFo7YJ8p4TWufDsJX9UpkUg=
Message-ID: <d9def9db0704280247s76ebc1dcve068a31feebb57cc@mail.gmail.com>
Date: Sat, 28 Apr 2007 11:47:41 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
Cc: "Michael Krufky" <mkrufky@linuxtv.org>,
       "Linux and Kernel Video" <video4linux-list@redhat.com>,
       "Linux Kernel Mailing list" <linux-kernel@vger.kernel.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org
In-Reply-To: <Pine.LNX.4.58.0704272317280.2050@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176653207.10849.5.camel@localhost> <4622C462.8020505@linuxtv.org>
	 <20070416141535.GB10338@stusta.de> <462397A0.4040603@linuxtv.org>
	 <d9def9db0704160916y16f43c02l350e1687b2e5d8f@mail.gmail.com>
	 <Pine.LNX.4.58.0704271318480.2050@shell2.speakeasy.net>
	 <d9def9db0704271543pd38f73ck4d46f98f77b230f@mail.gmail.com>
	 <Pine.LNX.4.58.0704272317280.2050@shell2.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> On Sat, 28 Apr 2007, Markus Rechberger wrote:
> > On 4/27/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > On Mon, 16 Apr 2007, Markus Rechberger wrote:
> > > > > >> enough testing to be sent to mainline.
> > >
> > > I wish these patches had more comments about how they worked, because
> it's
> > > not clear to me exactly what they are doing or why they do it.
> > >
> > > Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> > >
> > > I'm just going to talk about this one patch, since it appears to be the
> > > simplest.
> > >
> > > This patch removes the 'wait_queue' memory of dvb_demux.  Why does a
> patch
> > > to dvbnet have anything to do with the demux device?  Should this change
> > > have been part of the previous patch, the one what fixes demux and dvr?
> > >
> >
> > The waitqueue got added in a previous patch just ignore it..
>
> Do the patches need to be applied all together?  If I apply just the first
> two, do I get something that's broken?
>

yes very likely only because of this wait_queue..

> > > The patch replace the (file_operations)->release pointer with the new
> > > function dvb_net_close() in place of dvb_generic_release().  The first
> > > part of dvb_net_close() is just a cut&paste from dvb_generic_release(),
> > > so maybe it would be better to just call dvb_generic_release() instead?
> > >
> >
> > no because it needs the dvb_net structure which cannot be used in the
> > dvb_generic_release function.
>
> I mean, have dvb_net_close() call dvb_generic_release() and then do the
> extra stuff.
>
dvb_generic_release is really generic and has no information about the
dvb net structure if it's used for eg. the frontend

for example the dvb_frontend release function:
static int dvb_frontend_release(struct inode *inode, struct file *file)
{
        struct dvb_device *dvbdev = file->private_data;
        struct dvb_frontend *fe = dvbdev->priv;
        struct dvb_frontend_private *fepriv = fe->frontend_priv;

it would be possible to use dvb_release_generic if there wouldn't be
any reference to dvb_frontend and dvb_frontend_private.
In case of dvb-net it's a dvb_net specific release function by adding
the dvb_net structure.

If you look at dvb_generic_release it only uses dvb_device which is
really generic and used by all the dvb modules (frontend/dmx/..)

> > > There is also a bug:
> > >
> > > +static int dvb_net_close(struct inode *inode, struct file *file)
> > > +{
> > > +       struct dvb_device *dvbdev = file->private_data;
> > > +       struct dvb_net *dvbnet = dvbdev->priv;
> > > +
> > > +       if (!dvbdev)
> > > +               return -ENODEV;
> > >
> > > The check for !dvbdev is too late, dvbdev was already dereferenced on
> the
> > > previous line to get dvbnet, so if dvbdev is NULL you will have already
> > > crashed.
> > >
> >
> > I think this check isn't needed at all actually, why should someone
> > release dvbdev before already?
> >
> > > Is the check for !dvbdev unnecessary paranoia?  Or can dvbdev actually
> be
> > > NULL is some cases?
> > >
> > > So, w.r.t. dvbnet, my understanding is that somehow dvb_net_release() is
> > > called while the net device is still in use.  Is that correct?
> > > dvb_net_release() will end up deleting some stuff that needs to be
> around
> > > while there is still a user of the device?
> > >
> > > Would it be possible to keep dvb_net_release() from getting called in
> the
> > > first place until there are no users of the device?
>
> What about this?  I don't have any hot pluggable hardware, so how does
> dvb_net_release() get called when the device disconnects?
>

I don't understand, it's inode based if you open the file it will also
release the file if you close it.
If it's not hotpluggable it will not use the wait_queue because the
usecount would be 0 already when unloading the module.

> > > When looking at this code, keep in mind that users starts at 1 and goes
> > > down as the device is used.
> > >
> > > void dvb_net_release (struct dvb_net *dvbnet)
> > > {
> > >         int i;
> > >
> > >         dvbnet->exit = 1;
> > >         if (dvbnet->dvbdev->users < 1)		/* line A */
> > >                 wait_event(dvbnet->dvbdev->wait_queue,  /* line B */
> > >                                 dvbnet->dvbdev->users==1);
> > > 	/* line C */
> > >         dvb_unregister_device(dvbnet->dvbdev);
> > > 	[...]
> > > }
> > >
> > > Isn't there a race condition here?  What if there are no users of the
> > > device at the time line A runs, but the device is opened before line C
> > > runs?  After the wait_even() on line B returns there are no users, but
> what
> > > if new users opens the device after the after line B?
> > >
> >
> > yes this is a valid argument, practically it will never occure though.
> > Since I also wrote that I didn't have a dvb signal at the time of
> > writing this I don't even know if the dvb-net implementation is ok at
> > all.
> > I don't even know if that part of the framework works and if someone
> > really uses it.
> >
> > > Is seems like you need something to prevent new users from opening the
> > > device, i.e. make it so that dvbnet->exit=1 prevents the device from
> > > getting opened, but if that's the intention, I don't see where it's
> > > happening.
> > >
> > > In dvb_net_close():
> > >
> > > +       if(dvbdev->users == 1 && dvbnet->exit==1) {
> > > +               fops_put(file->f_op);
> > > +               file->f_op = NULL;
> > > +               wake_up(&dvbdev->wait_queue);
> > > +       }
> > >
> > > What is the purpose of the fops_put() call and setting file->f_op to
> NULL?
> > >
> >
> > fops_put lowers the usecount on the inode, after wake_up the f_op
> > structure is invalid because it's just allocated memory which gets
> > freed by the dvb release function.
>
> fopts_put() lowers the usecount of the module that owns the inode.  I don't
> see how it works to add this when it wasn't here before?  Isn't it going to
> mess up the module usecount by doing a fopts_put() that's not matched by a
> fopts_get()?  I didn't see anything in your patch that added a fops_put().
>

fops_put is nullpointer safe, the close() function remember the
allocated memory is gone after the release function deallocates the
memory.
What other module should own a usecount of it?

If you look at file_table.c:
        if (file->f_op && file->f_op->release)
                file->f_op->release(inode, file);
        security_file_free(file);
        if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
                cdev_put(inode->i_cdev);
        fops_put(file->f_op); <- this would be invalid in our case
because the f_op structure gets deallocated earlier already so setting
it to NULL would prevent to lower the usecount.

first it calls file->f_op->release (our close/release function)
in the close/release function, while there's still a user the fops
deallocation is on hold.
As soon as the wake up function gets called the process will very
likely switch to the waked up procedure and it will immediatelly free
the f_ops structure. After cycling back to the close function we have
invalid memory and an invalid f_ops pointer.

Markus
