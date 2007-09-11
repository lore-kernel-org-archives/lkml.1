Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbXIKNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbXIKNMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXIKNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:12:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXIKNMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:12:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 15:23:32 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709111355.07369.rjw@sisk.pl> <200709111512.35348.rjw@sisk.pl>
In-Reply-To: <200709111512.35348.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111523.33968.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 15:12, Rafael J. Wysocki wrote:
> On Tuesday, 11 September 2007 13:55, Rafael J. Wysocki wrote:
> > On Tuesday, 11 September 2007 13:27, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > On Tuesday 11 September 2007 21:04:22 Rafael J. Wysocki wrote:
> > > > On Tuesday, 11 September 2007 05:54, Nigel Cunningham wrote:
> > > > > Hi all.
> > > > > 
> > > > > Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel 
> > > threads
> > > > > nonfreezable by default) breaks freezing when attempting to resume from an
> > > > > initrd, because the init (which is freezeable) spins while waiting for 
> > > another
> > > > > thread to run /linuxrc, but doesn't check whether it has been told to 
> > > enter
> > > > > the refrigerator.
> > > > 
> > > > Hm.
> > > > 
> > > > I use a resume from an initrd on a regular basis and it works without the 
> > > patch
> > > > below.
> > > > 
> > > > I think we need to investigate what happens in your test case a bit.
> > > 
> > > Ah. That makes me realise that I see that too - my AMD64 uniprocessor laptop 
> > > didn't need the patch (guess that's why I didn't notice the need and ack'd 
> > > the patch). But my x86 SMP machine... it needs this. I'll see if they're 
> > > running on different processors.
> > 
> > Well, strange.  My x86_64 SMP machines don't need the patch too.
> 
> Anyway, yes, init is freezable, but should it be?
> 
> I mean, shouldn't we rather add PF_NOFREEZE to kernel_init()?

Argh, no.  PF_NOFREEZE is inherited by the children.

So, I think that your patch is correct, but there's some suspend2-specific
stuff in it.  I've rediffed it against 2.6.23-rc6 and moved try_to_freeze()
before yield().

---
From: Nigel Cunningham <nigel@nigel.suspend2.net>

Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel threads
nonfreezable by default) breaks freezing when attempting to resume from an
initrd, because the init (which is freezeable) spins while waiting for another
thread to run /linuxrc, but doesn't check whether it has been told to enter
the refrigerator. The original patch replaced a call to try_to_freeze() with a
call to yield(). I believe a simple reversion is wrong because
if !CONFIG_PM_SLEEP, try_to_freeze() is a noop. It should still yield.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 init/do_mounts_initrd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc6/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.23-rc6.orig/init/do_mounts_initrd.c
+++ linux-2.6.23-rc6/init/do_mounts_initrd.c
@@ -57,8 +57,10 @@ static void __init handle_initrd(void)
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
+			try_to_freeze();
 			yield();
+		}
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
