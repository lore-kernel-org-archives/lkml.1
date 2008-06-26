Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbYFZSWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbYFZSWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYFZSWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:22:44 -0400
Received: from bu3sch.de ([62.75.166.246]:38231 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYFZSWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:22:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Oops when using growisofs
Date: Thu, 26 Jun 2008 20:21:31 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200806221818.24372.mb@bu3sch.de> <20080626170513.GE23386@duck.suse.cz> <20080626181142.GH20851@kernel.dk>
In-Reply-To: <20080626181142.GH20851@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806262021.32140.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 20:11:42 Jens Axboe wrote:
> On Thu, Jun 26 2008, Jan Kara wrote:
> > On Wed 25-06-08 11:46:29, Michael Buesch wrote:
> > > On Wednesday 25 June 2008 11:37:00 Jan Kara wrote:
> > > > > Yeah the IO error is the trigger.
> > > > > I noticed that it had obvious troubles accessing the DVD that was in the drive.
> > > > > It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> > > > > and then oopsed. But after that everything continued to work as usual.
> > > > > (Except kded of course)
> > > >   Hmm, by "accessing" do you mean that you've mounted the burned DVD and when
> > > > browsing it the IO error and the oops occured or that IO error happened
> > > > when burning? It is important because in the first case i_blkbits would be
> > > > taken from some ISOFS inode desribing some file while in the second case
> > > > i_blkbits are from the inode of the device...
> > > I don't know. kded, which caused the oops, is always running. It is a KDE daemon
> > > that polls device state and so on. So yeah, it might have accessed the drive
> > > while growisofs was writing to it.
> > > 
> > > However with "accessing" I mean the DVD drive motor was spinning up and down
> > > and the laser lens was moving like crazy. The sound that happens, if you put
> > > a completely scratched DVD into the drive and it is unable to make sense of it.
> > > However, this was not scratched. It was a new DVD with one session on it that
> > > I just burnt 5 minutes before that. So I wanted to append another session to it
> > > and it crashed and resulted in IO errors in growisofs.
> >   I've been looking into this problem for some time. The only way how
> >   I see blocksize can be set so big is in cdrom_read_capacity() in
> >   drivers/ide/ide-cd.c. That basically blindly fills in
> >   queue->hardsect_size with what the drive returns and this can
> >   propagate in bd_set_size() to i_blkbits.  Jens, do you think that is
> >   possible? Shouldn't ide_cd_read_toc() do some sanity checks of the
> >   blocksize returned?
> 
> It can't hurt, the value should be >= 512b and <= 4kb. Normally it would
> be 2kb, but some devices have a 512b switch so that is also seen. Not
> sure that 1kb and 4kb are valid, but at least it would still point to
> the drive possibly returning valid data and not garbage. So accept all
> those, reject (and complain) if it isn't one of those and default to 2kb.

I agree with the need for a hardware sanity check and I would happily test
any RFC patch :)

-- 
Greetings Michael.
