Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbZHCQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbZHCQ61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932381AbZHCQ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:58:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51859 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932361AbZHCQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:58:24 -0400
Date: Mon, 3 Aug 2009 17:59:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090803175909.06f8e8e6@lxorguk.ukuu.org.uk>
In-Reply-To: <87vdl4kgne.fsf@devron.myhome.or.jp>
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
	<87k51l9apo.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
	<20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
	<20090803103746.264c3acf@lxorguk.ukuu.org.uk>
	<87vdl4kgne.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it. But, even before the patch, it seems we didn't
> 
> 	filp->f_op = &hung_up_tty_fops;
> 
> for console stuff. But, I'm still not found why we avoid to the above...

Not sure - I'd have to re-read all the specs. Could be that applications
writing to the console do not expect to get a hangup when the device for
the console ceases to be a controlling terminal. That would be a
behaviour change. Equally if we don't set the hung_up file operations we
can't call ->hangup().

I'd be very concerned about having the console behaviour changed. For a
late -rc I'd think it may even be better to leak an ldisc instance in
that case providing end users can't cause a repeated leak of that form.

(ie if its got a use count when we got to free it we just look the other
way or queue the kfree)

The more I look at this the more risky all the changes look except for
switching it to refcount properly.

We risk changing the behaviour of consoles in ways that might break apps
and certainly break our behaviour. We end up risking messing up serial
consoles and trying to printk to down devices.

Proper refcounting on the other hand fixes the real problem in a
controlled fashion without hard to analyse and define behaviour changes.

Alan
