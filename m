Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbXIZMyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbXIZMyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 08:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXIZMyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 08:54:44 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:57704 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXIZMyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 08:54:43 -0400
In-Reply-To: <46FA341A.80706@davidnewall.com>
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com>
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Chroot bug
Date: Wed, 26 Sep 2007 08:54:35 -0400
To: David Newall <david@davidnewall.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 26, 2007, at 06:27:38, David Newall wrote:
> Kyle Moffett wrote:
>> David, please do tell myself and Adrian how "locking down" chroot 
>> () the way you want will avoid letting root break out through any  
>> of the above ways?
>
> As has been said, there are thousands of ways to break out of a  
> chroot.  It's just that one of them should not be that chroot lets  
> you walk out.  I can't explain it clearer than that.  If you don't  
> see it now you probably never will.

Let me put it this way:  You *CANNOT* enforce chroot() the way you  
want to without a completely unacceptable performance penalty.  Let's  
start with the simplest example of:

fd = open("/", O_DIRECTORY);
chroot("/foo");
fchdir(fd);
chroot(".");

If you had ever actually looked at the Linux VFS, it is completely  
*impossible* to tell whether "fd" at the time of the chroot is inside  
or outside of "/foo" without tracking an enormous amount of extra  
state.  Even then, any such determination may not be valid since an  
FD may be opened to an inode which is hardlinked at multiple  
locations in the directory tree.  It could also be bind-mounted at  
multiple locations, or it may not even be mounted at all in this  
namespace (CDROM that was lazy-unmounted).  That FD may be later  
passed over an open UNIX-domain socket from another process.   
Moreover, arbitrarily closing FDs would break a huge number of  
programs.  Furthermore, since you can't fix the "trivial" case of  
'fchdir()', then there's no point in even *attempting* to fix the  
"cwd is outside of chroot" problem, although that is basically  
equivalent in difficulty to fixing the "dir-fd is outside of chroot"  
problem.

As for the nested-chroot() bit, the root user inside of a chroot is  
always allowed to chroot().  This is necessary for test-suites for  
various distro installers, chroot once to enter the installer  
playpen, installer chroots again to configure the test-installed- 
system.  Once you allow a second chroot, you're back at the "can't  
reliably and efficiently track directory sub-tree members" problem.

So if you think it can and should be fixed, then PROVIDE THE CODE.

Cheers,
Kyle Moffett

