Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXILR6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXILR6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968370AbXILR6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:58:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:60350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765995AbXILR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:58:35 -0400
From: Neil Brown <neilb@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 12 Sep 2007 19:57:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18152.10361.790323.494668@notabene.brown>
Cc: Greg KH <greg@kroah.com>, Robert Schwebel <r.schwebel@pengutronix.de>,
       Heiko Schocher <hs@denx.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Detlev Zundel <dzu@denx.de>
Subject: Re: SYSFS: need a noncaching read
In-Reply-To: message from Nick Piggin on Wednesday September 12
References: <1189503798.6674.46.camel@Zeus.EmbLux>
	<20070912053207.GH23573@pengutronix.de>
	<20070912100123.GA23182@kroah.com>
	<200709120519.39960.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday September 12, nickpiggin@yahoo.com.au wrote:
> On Wednesday 12 September 2007 20:01, Greg KH wrote:
> > On Wed, Sep 12, 2007 at 07:32:07AM +0200, Robert Schwebel wrote:
> > > On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> > > > I have developed a device driver and use the sysFS to export some
> > > > registers to userspace.
> > >
> > > Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
> > > not to play around with registers from userspace.
> > >
> > > > I opened the sysFS File for one register and did some reads from this
> > > > File, but I alwas becoming the same value from the register, whats not
> > > > OK, because they are changing. So I found out that the sysFS caches
> > > > the reads ... :-(
> > >
> > > Yes, it does. What you can do is close()ing the file handle between
> > > accesses, which makes it work but is slow.
> >
> > Do an lseek back to 0 and then re-read, you will get called in your
> > driver again.
> 
> Can you do a pread with offset 0 to avoid the two syscalls? (which some
> people seem to be concerned about)

No.
Looking in fs/sysfs/file.c, we notice the field "needs_read_fill" in
struct sysfs_buffer.

sysfs_read_file will only call fill_read_buffer  (which calls the
->show routine) if this is 1;

It is cleared by fill_read_buffer and set to 1:
 - at open
 - by fill_write_buffer (i.e. if you write to the file descriptor)
 - by sysfs_poll when an event was detected.

So currently you cannot simply open a sysfs file an read multiple
times.

One option would be to call fill_read_buffer if *ppos == 0.
I cannot see that being a problem in practice, but maybe there is a
reason why it wasn't done that way.
Another option might be to call fill_read_buffer also if 
	buffer->event != atomic_read(&attr_sd->s_event)
and require drivers to call sysfs_notify when they make a change that
should be noticed.  But I doubt that is really important.

NeilBrown
