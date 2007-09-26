Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbXIZTYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbXIZTYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXIZTYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:24:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXIZTYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:24:23 -0400
Date: Wed, 26 Sep 2007 21:23:23 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: David Newall <david@davidnewall.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug (was: sys_chroot+sys_fchdir Fix)
In-Reply-To: <46F924E3.50205@davidnewall.com>
Message-ID: <Pine.LNX.4.58.0709262046350.3113@be1.lrz>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
 <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5>
 <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com>
 <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com>
 <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com>
 <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com>
 <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18rI7UrDQ2pclzFfp+HbTJf9gcGd57gPG1ZsXm
 MfBBFOcdiqobnDkJLsYoljn5ckDqNcdWBQBNt8TGGpZhTrE5TV
 X2cSxkgZnKyjnwD1Qybvw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007, David Newall wrote:

> Miloslav Semler pointed out that a root process can chdir("..") out of 
> its chroot.  Although this is documented in the man page, it conflicts 
> with the essential function, which is to change the root directory of 
> the process.

The root directory, '/' is changed, and if the process is capable of using
chroot, it may change the root directory again. Works as defined.

>  In addition to any creative uses, for example Philipp 
> Marek's loading dynamic libraries, it seems clear that the prime purpose 
> of chroot is to aid security.

As long as root has more than a safe subset of capabilities, root can escape 
a chroot.

Besides that, fchdir on open-at-chroot fds does not decrease the security, 
since the attacker needs help from the outside root, who is not restricted 
by chroot.

I'm more concerned about abstract unix sockets, they could be used to 
send a file descriptor to compromised daemons and extend exploits to
the outside of a chroot and across namespaces - at least I suspect it.
The whole f* family of syscalls would be affected. This can be cured by
e.g. not allowing to receive fds if the root+namespace do not match.

>  Being able to cd your way out is handy 
> for the bad guys, but the good guys don't need it; there are a thousand 
> better, safer solutions.

The good guys don't cd out, they open the instalkler archive, chroot to the 
new system root and extract it there. Then they chroot back using the saved 
cwd.

> If there truly is a need to be able to pop in and out of a chroot, then 
> the solution should be obvious, such as with real versus effective user 
> and group ids.  An important quality of a solution would be a way to fix 
> that essential function: to set the root in such a way that you can no 
> longer pop out.  But that is a separate question.

As in jail()?

As far as I know, the new virtualisation features sneaking into the kernel  
will allow implementing a jail, too, in a more secure way than any hacking 
on chroot can give.

> The question: is chroot buggy?  I'm pleased to turn to SCO for an 
> independent definition for chroot, from which I get the following:
> 
> http://osr600doc.sco.com/en/man/html.S/chroot.S.html:
> >
> > The *..* entry in the root directory is interpreted to mean the root 
> > directory itself. Thus, *..* cannot be used to access files outside 
> > the subtree rooted at the root directory.
> >
> 
> I argue chroot is buggy.  Miloslav's patch might not be the right 
> solution, but he has the right idea (i.e. fix it.)

There are implementations of chroot which imply chdir(), and not having f* 
functions, they can not _directly_ acces files outside the chroot. But as 
long as they can e.g. mknod /dev/mem or strace, they can do anything.

So let's not put a fingerprint sensor on that chinese paper door.
-- 
You know you're in trouble when packet floods are competing to flood you.
	-- grc.com
