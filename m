Return-Path: <linux-kernel-owner+w=401wt.eu-S1764978AbXKUA3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764978AbXKUA3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXKUA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:29:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46586 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbXKUA27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:28:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system after loading - now 2.6.24-rc3
Date: Wed, 21 Nov 2007 01:46:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Chris Friedhoff <chris@friedhoff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20071110221629.1d180480.chris@friedhoff.org> <200711200058.29663.rjw@sisk.pl> <20071120055519.GD20436@elte.hu>
In-Reply-To: <20071120055519.GD20436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210146.30254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 of November 2007, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > increasing CONFIG_BLK_DEV_RAM_SIZE from 7777 to 131072 hasn't 
> > > changed the non-functioning of 2.6.24-rc3
> > > 
> > > s2disk works with 2.6.23.8 ; I tested 4 cycles in a row, 2 from 
> > > console and 2 from within X
> > 
> > I've attached a patch to the bugzilla entry, please test it.
> [...]
> > --- linux-2.6.orig/init/do_mounts_initrd.c
> > +++ linux-2.6/init/do_mounts_initrd.c
> > @@ -55,6 +55,8 @@ static void __init handle_initrd(void)
> >  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
> >  	sys_chroot(".");
> >  
> > +	current->flags |= PF_NOFREEZE;
> > +
> >  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
> >  	if (pid > 0)
> >  		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
> 
> this is not the first time (and not the last time) that a missing 
> PF_NOFREEZE is causing hard to debug suspend problems. I think we should 
> be more robust about this and at minimum include some debug mechanism 
> that determines when a PF_NOFREEZE annotation is missing. (or at least 
> detect the condition somehow and report it) This bug took 10 days to 
> track down.

In fact all of the needed pieces are in there, I only needed the right dmesg
output to figure out what's wrong.

Also, I don't think we should use PF_NOFREEZE in there, as this is an
exceptional case.  I'd prefer to use the appended fix, which also has been
tested.

Thanks,
Rafael


---
 init/do_mounts_initrd.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.orig/init/do_mounts_initrd.c
+++ linux-2.6/init/do_mounts_initrd.c
@@ -55,12 +55,18 @@ static void __init handle_initrd(void)
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 
+	/*
+	 * In case that a resume from disk is carreid out by linuxrc or one of
+	 * its children, we need to tell the freezer not to wait for us
+	 */
+	current->flags |= PF_FREEZER_SKIP;
+
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
-			try_to_freeze();
+		while (pid != sys_wait4(-1, NULL, 0, NULL))
 			yield();
-		}
+
+	current->flags &= ~PF_FREEZER_SKIP;
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
