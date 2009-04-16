Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZDPX5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZDPX5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZDPX4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:56:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46581 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbZDPX4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:56:53 -0400
Date: Fri, 17 Apr 2009 00:56:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090416235649.GF26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416160645.GB17804@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 06:06:45PM +0200, Ingo Molnar wrote:
> 
> * Alessio Igor Bogani <abogani@texware.it> wrote:
> 
> > Replace ths BKL in sys_mount()/sys_umount() syscalls with a regular mutex.
> > 
> > Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> > ---
> >  fs/namespace.c |   16 +++++++++-------
> >  fs/super.c     |    9 ++++-----
> >  2 files changed, 13 insertions(+), 12 deletions(-)
> 
> Ok, this patch needs to be flamed^W commented on by Al.
> 
> Al: this patch is very likely broken as i cannot imagine you leaving 
> the BKL there just so. So lets accept that (and your NAK) as a given 
> and not get upset about it too much.

NAK is certainly given.  Dealing with force-umount is laughable - there
are so few instances, that we simply ought to take (all two? of) them
individually.

remount is potentially nastier, but then it *is* nasty.  Again, it's only
per-fs stuff, so the obvious first step is taking BKL down into the instances.
It doesn't protect anything in VFS; all uses are fs internal, so that'll
take review of individual filesystems.

NOTE: do not assume that code in fs/foo/* is correct; "it doesn't take BKL
elsewhere" does _not_ mean that we don't have races.  IOW, the same review
ought to look for such beasts and deal with them.  Mere "oh, no BKL anywhere
in that fs" is not enough to discard the ->remount_fs() instance.
 
> I'm wondering how much the BKL use here is made necessary by the 
> sys_open() BKL use in device drivers. Jonathan has done extensive 
> work on the sys_open front (and there's more such work in 
> tip:core/kill-the-BKL) - perhaps that has largely paved the way for 
> this change?
> 
> There's also ioctl BKL use - is the BKL use here in sys_mount 
> necessiated by the (naked) BKL use in those handlers?

No.  It's all about fs internals protected from themselves.  ->remount_fs()
tends to be grotty shite, so nobody had enough courage to do proper review
and fixes.  And it's not a place where we would really suffer from contention,
so it didn't get high priority that way either.
