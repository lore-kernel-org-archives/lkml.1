Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbYETRWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbYETRWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYETRWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:22:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYETRWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:22:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH, RFC] char dev BKL pushdown
Date: Tue, 20 May 2008 19:21:51 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
References: <25447.1211296423@vena.lwn.net>
In-Reply-To: <25447.1211296423@vena.lwn.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805201921.53530.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+K6vKarVSwIC2Go5bm5jcPcC+6ZYQ9gIHVeZk
 79G750gv/9FL/sgNMtnSWHvGjv97r2kXlOqkN/aewN4j9dSCxT
 jcZHMVBtwVM8Hdjy7Si2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Jonathan Corbet wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I've given it a try for all the misc drivers that have an open() function.
> > The vast majority of them are actually watchdog drivers, all of which
> > register as a misc device by themselves. 
> 
> OK, it looks like the "misc" misc drivers patch can go into the
> bkl-removal tree, while the watchdog patches should not.  What that
> means, I guess, is that the final misc_open() patch cannot go in at this
> point; Alan's watchdog stuff needs to find its way in first.  Make
> sense? 

Right, unless Alan or Wim are confident enough that removing the
BKL won't break the drivers (more than they are today).
Almost all of the open functions go along the lines of

int open(struct file *f, struct inode *i)
{
	if (wd_is_open)
		return -EBUSY;
	wd_is_open = 1;
	
	start_wd();

	return nonseekable_open(f, i);
}

nonseekable_open doesn't need the BKL by itself, and the wd_is_open
variable is protected by the misc_mtx mutex.
I can't see any scenario in which start_wd() would need the BKL, or
where a watchdog driver needs cycle_kernel_lock(), but I was't confident
enough about that assessment, because I'm not really familiar with
the drivers.

> > You seem to already have a script to turn per-file changes into a
> > patch each, so I'm sending you two patches: one for all the watchdog
> > drivers (maybe Wim can take care of that as well) and one for all the
> > other misc drivers (this one needs to be split).
> 
> Alas, I have no such script.  I just committed each change as I made it
> - each one required individual attention anyway.  The misc changes look
> pretty straightforward, so I could probably hack up such a thing pretty
> quickly if you don't have a tree with broken out patches.

I've done a semi-automated split and applied the patches on top of your
tree. You can pull these from

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/cell-2.6 bkl-removal

(I guess I should do a separate tree for it, will do that if more stuff
comes up.)

	Arnd <><
