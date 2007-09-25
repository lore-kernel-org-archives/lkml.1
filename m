Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXIYQx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXIYQx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXIYQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:53:46 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:39257 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752814AbXIYQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:53:45 -0400
X-YMail-OSG: W9zXGFMVM1ll5sd87DJuFd5KcUHsUW.Keb7JYJSOzHl898JOSo69ArVULwuzzT4sv2oyWztfog--
Date: Tue, 25 Sep 2007 11:53:41 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Miloslav Semler <majkls@prepere.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, serge@hallyn.com,
       davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070925165341.GA12422@vino.hallyn.com>
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr> <46F92C17.3060405@davidnewall.com> <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr> <46F9351D.8020906@prepere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9351D.8020906@prepere.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miloslav Semler (majkls@prepere.com):
>
>>>> So what? Just do this: chdir into the root after chroot.
>>>>       
>>> I don't think so.  His exploit just got me all the way out of a chroot 
>>> within a
>>> chroot within a chroot, inclusive of lots of chdirs.
>>>     
>>
>> Close all fds that point to directories outside the root ;-)
>>
>>   
> This  does not help.  Let's try:
> chroot somewhere
> mkdir foo
> fd = open /
> chroot foo
> fchdir fd
> chdir ".."
> ....
> chdir ".."
> chroot "."
> so you are in root.
>

Yes, to understand why that doesn't work it helps to understand why
pivot_root *does* work.  Pivot_root takes the new_root, which must be
a mount, and detaches it from it's mountpoint.  So it's not that we
try to intercept a chdir(root_dir/..), but rather we remove root_dir
from it's parent dir so that root_dir/.. must always return root_dir.

I'm sorry but I really don't see where hacking chroot to try and
detect and prevent chroot escapes is going to be acceptable to
anyone so long as pivot_root does the trick anyway.  If you want
portable, then write a little linux-only safe_chroot() library call
which does unshare();pivot_root() on linux and just chroot on a
system that does try to stop chroot escapes.

Besides as others have alluded to, if you have root privs, you can
always mknod /dev/hda1, mount that under /mnt, and then chroot or
pivot_root to there.

The containers work will, in fact, be intended to be a *safe*
jail.  That'll happen through pivot_root, capability masking,
perhaps device namespaces, etc.  But a secure container is still
a ways off.

-serge
