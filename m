Return-Path: <linux-kernel-owner+w=401wt.eu-S933520AbXBXQ7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbXBXQ7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933525AbXBXQ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:59:12 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:41255 "EHLO
	asav03.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520AbXBXQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:59:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAKL930VKhRO4UGdsb2JhbACHTIc9AQEqkx4BAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: input.c: start on release
Date: Sat, 24 Feb 2007 11:57:07 -0500
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <20070222212919.850ceafe.zaitcev@redhat.com> <d120d5000702230706u4e7576du6661ce1b58e058aa@mail.gmail.com> <20070223164424.0454e11e.zaitcev@redhat.com>
In-Reply-To: <20070223164424.0454e11e.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241157.08228.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 February 2007 19:44, Pete Zaitcev wrote:
> On Fri, 23 Feb 2007 10:06:14 -0500, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> > On 2/23/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> 
> > > void input_release_device(struct input_handle *handle)
> > > {
> > > ....
> > >        if (handle->handler->start)
> > >                handle->handler->start(handle);
> 
> > It should be ->start(). You are probably confused a little by the name
> > of the function. input_release_device() is called when userspace
> > issues ioctl(fd, EVIOCGRAB, 0) releasing (or ungrabbing) the device
> > (as opposed to xxx_release(file, inode) type functions that are called
> > when last user of a file drops off). In our case we want to give
> > handlers a chance to resume their control over device. Right now
> > standard keyboard driver uses start method do bring back in sync LED
> > state of a keyborad-like device after it was released (ungrabbed).
> 
> Thanks for the explanation. I suspect people asked you 100 times before.
> I can see why we would want to do this when a grab ends, but why do
> we do this on every close of /dev/input/mice? The call path is:
> 
>  mousedev_release ->
>  mixdev_release (optional for some majors)
>  input_close_device ->
>  input_release_device
>

The actual work withing input_release_device happens only when called
for handle that grabbed the device earlier. The reason why we call it
when closing a device so that device is not left in grabbed state if
userspace forgot to release it voluntarily.
 
> Same thing happens upon disconnect, though this is probably harmless,
> as the device is gone already anyway.
> 
> To tell you the truth, all I really want is to hold a static mutex
> across a call to input_close_device(). Can I do that?

Are you trying to fix locking in mousedev?

-- 
Dmitry
