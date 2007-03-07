Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXCGGHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXCGGHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbXCGGHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:07:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXCGGHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:07:15 -0500
Date: Tue, 6 Mar 2007 22:06:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sonic Zhang" <sonic.adi@gmail.com>
Cc: bryan.wu@analog.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070306220641.d7bd92bf.akpm@linux-foundation.org>
In-Reply-To: <4e5ebad50703062117j5a6866d9x8580060ae0f83a94@mail.gmail.com>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070305231846.d4a31502.akpm@linux-foundation.org>
	<4e5ebad50703062117j5a6866d9x8580060ae0f83a94@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 13:17:57 +0800 "Sonic Zhang" <sonic.adi@gmail.com> wrote:

> On 3/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 06 Mar 2007 14:54:18 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> >
> > > Hi folks,
> > >
> > > [PATCH] Blackfin: blackfin i2c driver
> > >
> 
> > > +     struct i2c_msg *pmsg;
> > > +     int i, ret;
> > > +     int rc = 0;
> > > +
> > > +     if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
> > > +             return -ENXIO;
> > > +
> > > +     down(&iface->twi_lock);
> > > +
> > > +     while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
> > > +             up(&iface->twi_lock);
> > > +             schedule();
> > > +             down(&iface->twi_lock);
> > > +     }
> >
> > That's a busy loop until this task's timeslice has expired.  It'll work,
> > but it'll suck a bit.  (Repeated in several places)
> >
> 
> OK, I change it into yield(). So, current process will be move to the
> tail of the run queue. Is that OK with you?

Nope, yield is terribly bad when there are busy processes running: it can
stall for a very long time indeed,

Is this hardware not capable of generating an interrupt when BUSBUSY gets
negated?

I guess not, in which case you're stuck with having to poll it - probably
use a cond_resched() in the loop, and an angry comment.

