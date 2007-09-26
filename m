Return-Path: <linux-kernel-owner+w=401wt.eu-S1762505AbXIZVTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762505AbXIZVTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXIZVTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:19:36 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34434 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968AbXIZVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:19:35 -0400
Message-ID: <46FACCE0.2070005@davidnewall.com>
Date: Thu, 27 Sep 2007 06:49:28 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com>	<20070919104018.3a6bcfb1@the-village.bc.nu>	<46F16A0A.3070402@tmr.com>	<20070919194559.36015307@the-village.bc.nu>	<46F1A196.8060108@davidnewall.com>	<46F401D6.6060609@cfl.rr.com>	<20070921191012.15a0b51b@the-village.bc.nu>	<46F9752C.5080807@cfl.rr.com>	<20070926002340.GL8181@ftp.linux.org.uk>	<46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se>
In-Reply-To: <20070926212408.6662231a@zoo.weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> *spends five minutes with Google*
>
> From the OpenBSD FAQ (an operating system most know for being really,
> really focused on security):
>
>     http://www.openbsd.org/faq/faq10.html
>
>     Any application which has to assume root privileges to operate is
>     pointless to attempt to chroot(2), as root can generally escape a
>     chroot(2).
>   

For sure, "a root user can get out of a chroot a million different 
ways."  Young Alan said as much at the beginning of this conversation, 
and I have always agreed.  I don't hope to secure Linux within chroot, 
simply to fix chroot so that it does what it says it does.

Look, when chroot was being designed, I think they intended that even 
root should be unable to get out.  They went so far as to say that 
dot-dot wouldn't let you out; and it doesn't.  It's not dot-dot that's 
the problem.  Even fchdir is no problem, because you choose which file 
descriptors to leave open.  Fchdir is actually one of the answers.  
("What if we need a way to escape?")

The problem is leaving cwd unchanged.  Once you've set cwd within the 
new root, dot-dot is promised to keep you within that root; and so it 
does.  But by leaving cwd unchanged, if you do a subsequent chroot, that 
promise is suddenly broken.  I think this is a bug.  I think that 
behavior was not intended.  Not all agree with me, but obviously a lot 
do, otherwise OpenBSD and others wouldn't have addressed this exact 
issue.  Here's what they do:

    "If the program is already running with an altered root directory,
    the process's current directory is changed to the same new root
    directory.  This prevents the current directory from being further
    up the directory tree than the altered root directory."
    -- OpenBSD man 2 chroot


This was no more than an attempt to fix a long-standing bug.

As stated, opinion is divided as to whether this is a bug.  I think it 
is, and many people agree, for example some of the BSDs and probably 
others; some people don't.  Young Alan, for example, ummm, strongly (is 
a good word) disagrees.  I don't see that it calls for nastiness or 
emotion, and although opinion on this august list is divided, apparently 
the nays are in the majority.  We should leave it at that.
