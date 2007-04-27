Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbXD0Ve3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbXD0Ve3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXD0Ve2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:34:28 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:50834 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbXD0Ve0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:34:26 -0400
Date: Fri, 27 Apr 2007 14:34:25 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Markus Rechberger <mrechberger@gmail.com>
cc: Michael Krufky <mkrufky@linuxtv.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
In-Reply-To: <d9def9db0704160916y16f43c02l350e1687b2e5d8f@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0704271318480.2050@shell2.speakeasy.net>
References: <1176653207.10849.5.camel@localhost> <4622C462.8020505@linuxtv.org>
 <20070416141535.GB10338@stusta.de> <462397A0.4040603@linuxtv.org>
 <d9def9db0704160916y16f43c02l350e1687b2e5d8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Markus Rechberger wrote:
> On 4/16/07, Michael Krufky <mkrufky@linuxtv.org> wrote:
> > Adrian Bunk wrote:
> > > On Sun, Apr 15, 2007 at 08:33:38PM -0400, Michael Krufky wrote:
> > >> Mauro,
> > >>
> > >> I've been out of town for the past few days... I just got home and saw
> > this:
> > >>
> > >>
> > >> Mauro Carvalho Chehab wrote:
> > >>>    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
> > >>>    - Fix 2/3 for bug 7819: demux and dvr
> > >>>    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> > >> I don't think that this is 2.6.21 material.  These patches have not yet
> > >> received
> > >> enough testing to be sent to mainline.

I wish these patches had more comments about how they worked, because it's
not clear to me exactly what they are doing or why they do it.

Fix 3/3 for bug 7819: fixed hotplugging for dvbnet

I'm just going to talk about this one patch, since it appears to be the
simplest.

This patch removes the 'wait_queue' memory of dvb_demux.  Why does a patch
to dvbnet have anything to do with the demux device?  Should this change
have been part of the previous patch, the one what fixes demux and dvr?

The patch replace the (file_operations)->release pointer with the new
function dvb_net_close() in place of dvb_generic_release().  The first
part of dvb_net_close() is just a cut&paste from dvb_generic_release(),
so maybe it would be better to just call dvb_generic_release() instead?

There is also a bug:

+static int dvb_net_close(struct inode *inode, struct file *file)
+{
+       struct dvb_device *dvbdev = file->private_data;
+       struct dvb_net *dvbnet = dvbdev->priv;
+
+       if (!dvbdev)
+               return -ENODEV;

The check for !dvbdev is too late, dvbdev was already dereferenced on the
previous line to get dvbnet, so if dvbdev is NULL you will have already
crashed.

Is the check for !dvbdev unnecessary paranoia?  Or can dvbdev actually be
NULL is some cases?

So, w.r.t. dvbnet, my understanding is that somehow dvb_net_release() is
called while the net device is still in use.  Is that correct?
dvb_net_release() will end up deleting some stuff that needs to be around
while there is still a user of the device?

Would it be possible to keep dvb_net_release() from getting called in the
first place until there are no users of the device?

When looking at this code, keep in mind that users starts at 1 and goes
down as the device is used.

void dvb_net_release (struct dvb_net *dvbnet)
{
        int i;

        dvbnet->exit = 1;
        if (dvbnet->dvbdev->users < 1)		/* line A */
                wait_event(dvbnet->dvbdev->wait_queue,  /* line B */
                                dvbnet->dvbdev->users==1);
	/* line C */
        dvb_unregister_device(dvbnet->dvbdev);
	[...]
}

Isn't there a race condition here?  What if there are no users of the
device at the time line A runs, but the device is opened before line C
runs?  After the wait_even() on line B returns there are no users, but what
if new users opens the device after the after line B?

Is seems like you need something to prevent new users from opening the
device, i.e. make it so that dvbnet->exit=1 prevents the device from
getting opened, but if that's the intention, I don't see where it's
happening.

In dvb_net_close():

+       if(dvbdev->users == 1 && dvbnet->exit==1) {
+               fops_put(file->f_op);
+               file->f_op = NULL;
+               wake_up(&dvbdev->wait_queue);
+       }

What is the purpose of the fops_put() call and setting file->f_op to NULL?
