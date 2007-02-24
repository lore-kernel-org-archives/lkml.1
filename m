Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbXBXAp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbXBXAp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbXBXAp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:45:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284AbXBXAp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:45:57 -0500
Date: Fri, 23 Feb 2007 16:44:24 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: input.c: start on release
Message-Id: <20070223164424.0454e11e.zaitcev@redhat.com>
In-Reply-To: <d120d5000702230706u4e7576du6661ce1b58e058aa@mail.gmail.com>
References: <20070222212919.850ceafe.zaitcev@redhat.com>
	<d120d5000702230706u4e7576du6661ce1b58e058aa@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007 10:06:14 -0500, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> On 2/23/07, Pete Zaitcev <zaitcev@redhat.com> wrote:

> > void input_release_device(struct input_handle *handle)
> > {
> > ....
> >        if (handle->handler->start)
> >                handle->handler->start(handle);

> It should be ->start(). You are probably confused a little by the name
> of the function. input_release_device() is called when userspace
> issues ioctl(fd, EVIOCGRAB, 0) releasing (or ungrabbing) the device
> (as opposed to xxx_release(file, inode) type functions that are called
> when last user of a file drops off). In our case we want to give
> handlers a chance to resume their control over device. Right now
> standard keyboard driver uses start method do bring back in sync LED
> state of a keyborad-like device after it was released (ungrabbed).

Thanks for the explanation. I suspect people asked you 100 times before.
I can see why we would want to do this when a grab ends, but why do
we do this on every close of /dev/input/mice? The call path is:

 mousedev_release ->
 mixdev_release (optional for some majors)
 input_close_device ->
 input_release_device

Same thing happens upon disconnect, though this is probably harmless,
as the device is gone already anyway.

To tell you the truth, all I really want is to hold a static mutex
across a call to input_close_device(). Can I do that?

-- Pete
