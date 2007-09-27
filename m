Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbXI0H2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbXI0H2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXI0H2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:28:11 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:54164 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXI0H2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:28:10 -0400
Date: Thu, 27 Sep 2007 09:28:08 +0200
From: Christer Weinigel <christer@weinigel.se>
To: David Newall <david@davidnewall.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070927092808.612c204b@localhost.localdomain>
In-Reply-To: <46FACCE0.2070005@davidnewall.com>
References: <46F0CD96.9030807@prepere.com>
	<20070919104018.3a6bcfb1@the-village.bc.nu>
	<46F16A0A.3070402@tmr.com>
	<20070919194559.36015307@the-village.bc.nu>
	<46F1A196.8060108@davidnewall.com>
	<46F401D6.6060609@cfl.rr.com>
	<20070921191012.15a0b51b@the-village.bc.nu>
	<46F9752C.5080807@cfl.rr.com>
	<20070926002340.GL8181@ftp.linux.org.uk>
	<46FA35A6.1070400@davidnewall.com>
	<20070926212408.6662231a@zoo.weinigel.se>
	<46FACCE0.2070005@davidnewall.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 06:49:28 +0930
David Newall <david@davidnewall.com> wrote:

> For sure, "a root user can get out of a chroot a million different 
> ways."  Young Alan said as much at the beginning of this
> conversation, and I have always agreed.  I don't hope to secure Linux
> within chroot, simply to fix chroot so that it does what it says it
> does.
 
> The problem is leaving cwd unchanged.  Once you've set cwd within the 
> new root, dot-dot is promised to keep you within that root; and so it 
> does.  But by leaving cwd unchanged, if you do a subsequent chroot,
> that promise is suddenly broken.  I think this is a bug.  I think
> that behavior was not intended.  Not all agree with me, but obviously
> a lot do, otherwise OpenBSD and others wouldn't have addressed this
> exact issue.  Here's what they do:

So keep reading the links I gave you:

    http://www.unixwiz.net/techtips/chroot-practices.html

    The chroot call itself does not change the working directory, so
    if the new root is below the current directory, the application
    can still have access outside resources.

    http://www.bpfh.net/simes/computing/chroot-break.html

    chdir("/foo/bar");
    chroot("/foo/bar");

    Note the use of the chdir() call before the chroot() call. This is
    to ensure that the working directory of the process is within the
    chroot()ed area before the chroot() call takes place. This is due
    to most implementations of chroot() not changing the working
    directory of the process to within the directory the process is
    now chroot()ed in.

    http://www.faqs.org/faqs/unix-faq/programmer/secure-programming/

    The chroot() call itself will only change the root file system in
    the process' context. A chroot() call must be followed by a
    chdir("/") call in order to reset the current working directory.

So the OpenBSD man page seems to be in the minority here.  Any portable
code can not assume that CWD changes.  And changing the Linux behaviour
now would be a rather big change which might break userspace.  And yes,
there are applications that rely on this, I've used it when building
software for cross compiling.  

  /Christer

On Thu, 27 Sep 2007 06:49:28 +0930
David Newall <david@davidnewall.com> wrote:

> Christer Weinigel wrote:
> > *spends five minutes with Google*
> >
> > From the OpenBSD FAQ (an operating system most know for being
> > really, really focused on security):
> >
> >     http://www.openbsd.org/faq/faq10.html
> >
> >     Any application which has to assume root privileges to operate
> > is pointless to attempt to chroot(2), as root can generally escape a
> >     chroot(2).
> >   
> 
> For sure, "a root user can get out of a chroot a million different 
> ways."  Young Alan said as much at the beginning of this
> conversation, and I have always agreed.  I don't hope to secure Linux
> within chroot, simply to fix chroot so that it does what it says it
> does.
> 
> Look, when chroot was being designed, I think they intended that even 
> root should be unable to get out.  They went so far as to say that 
> dot-dot wouldn't let you out; and it doesn't.  It's not dot-dot
> that's the problem.  Even fchdir is no problem, because you choose
> which file descriptors to leave open.  Fchdir is actually one of the
> answers. ("What if we need a way to escape?")
> 
> The problem is leaving cwd unchanged.  Once you've set cwd within the 
> new root, dot-dot is promised to keep you within that root; and so it 
> does.  But by leaving cwd unchanged, if you do a subsequent chroot,
> that promise is suddenly broken.  I think this is a bug.  I think
> that behavior was not intended.  Not all agree with me, but obviously
> a lot do, otherwise OpenBSD and others wouldn't have addressed this
> exact issue.  Here's what they do:
> 
>     "If the program is already running with an altered root directory,
>     the process's current directory is changed to the same new root
>     directory.  This prevents the current directory from being further
>     up the directory tree than the altered root directory."
>     -- OpenBSD man 2 chroot
> 
> 
> This was no more than an attempt to fix a long-standing bug.
> 
> As stated, opinion is divided as to whether this is a bug.  I think
> it is, and many people agree, for example some of the BSDs and
> probably others; some people don't.  Young Alan, for example, ummm,
> strongly (is a good word) disagrees.  I don't see that it calls for
> nastiness or emotion, and although opinion on this august list is
> divided, apparently the nays are in the majority.  We should leave it
> at that.
> 
