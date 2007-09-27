Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbXI0D7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbXI0D7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 23:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXI0D7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 23:59:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48375 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXI0D7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 23:59:43 -0400
Date: Thu, 27 Sep 2007 04:59:26 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Newall <david@davidnewall.com>,
       Christer Weinigel <christer@weinigel.se>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070927035925.GT8181@ftp.linux.org.uk>
References: <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070926215521.GU6800@stusta.de> <46FAECC5.8040103@davidnewall.com> <20070927000137.GV6800@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927000137.GV6800@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 02:01:37AM +0200, Adrian Bunk wrote:
> <--  snip  -->
> 
> Look, when chroot was being designed, I think they intended that even root 
> should be unable to get out. They went so far as to say that dot-dot 
> wouldn't let you out; and it doesn't.
> 
> <--  snip  -->
> 
> You were clearly saying that whom you call "they" were the people who 
> designed chroot. And it was you who was claiming in this statement that
> "they" said it.
> 
> The OpenBSD manpage you quoted in this thread states chroot() was added 
> in 4.2BSD, and 4.2BSD was released in 1983.
> 
> You should therefore either bring a source where the people who designed 
> chroot() in 1983 or earlier are stating what you claim they said or 
> admit that you were talking utter bullshit.

chroot() is present in v7, thank you very much.  /usr/sys/sys/sys4.c has

chdir()
{
        chdirec(&u.u_cdir);
}

chroot()
{
        if (suser())
                chdirec(&u.u_rdir);
}

and back then it didn't stop lookups by .. at all - u_rdir is only used
in the beginning of namei() (when pathname starts with /), plus the obvious
refcounting in exit()/newproc().  So give me a break - back when it had
been introduced, it didn't do anything jail-like _at_ _all_.

That check appears only in BSD:
@@ -1,4 +1,4 @@
-/*     vfs_lookup.c    4.4     03/06/81        */
+/*     vfs_lookup.c    4.5     81/03/09        */
 
 #include "../h/param.h"
 #include "../h/systm.h"
@@ -107,6 +107,9 @@
        u.u_segflg = 1;
        eo = 0;
        bp = NULL;
+       if (dp == u.u_rdir && u.u_dent.d_name[0] == '.' &&
+           u.u_dent.d_name[1] == '.' && u.u_dent.d_name[2] == 0)
+               goto cloop;
 
 eloop:

with spectaculary lousy commit message ("lint and a minor fixed") by
wnj.  Feel free to ask Bill Joy WTF he had intended.  At a guess,
more consistent behaviour in chrooted environment (i.e. pathname
resolution looking as if the subtree had been everything).

To talk about root-safety of _anything_ at that point is bloody ridiculous.
