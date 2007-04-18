Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXDRWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXDRWrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXDRWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:47:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:47841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXDRWrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:47:48 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 19 Apr 2007 08:47:13 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17958.40945.937891.44930@notabene.brown>
Cc: Kyle McMartin <kyle@canonical.com>, linux-kernel@vger.kernel.org,
       alan@redhat.com, bcollins@ubuntu.com
Subject: Re: [RFC] [PATCH] Allow overriding module parameters from kernel
 command_line
In-Reply-To: message from Andrew Morton on Wednesday April 18
References: <20070418155552.GA3744@athena.road.mcmartin.ca>
	<20070418144512.14528b78.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 18, akpm@linux-foundation.org wrote:
> > On Wed, 18 Apr 2007 11:55:52 -0400 Kyle McMartin <kyle@canonical.com> wrote:
> > With the move to initramfs and heavily modular configs, which include
> > loading storage drivers from early userspace, it's becoming harder
> > to provide users with a way of overriding module parameters at boot.
> > 
> > Currently, users would have to break into the initramfs, edit the
> > modprobe options, and then let boot continue. They have a much easier time
> > dealing with adding options on the command line from Grub or what have you.
> > 
> > I hacked out this patch quickly to re-parse saved_command_line[] when we
> > load a module in an attempt to rectify this.
> > 
> > (The specific use-case I was looking at here was HPA commands failing on
> >  sata_nv controllers, and needing to pass the adma=0 option to the module...
> >  Users had a hard time testing without an easy way of overriding the module.)
> > 
> > Clearly this is not entirely optimal, because we're parsing command_line
> > after the module params are parsed. This ends of being a policy decision,
> > whether the /sbin/modprobe commandline should override the kernel
> > command_line, or vice versa.
> 
> Similar-but-different: I was trying to persuade a Fedora system to use ext2
> for the root filesystem the other day.  Turns out that we somehow managed
> to break `rootfstype=' in this situation and it cheerfully continued to use
> ext3.
> 
> Fixed by changing /etc/fstab and rebuilding initrd, but IMO rootfstype=
> should have worked.

I think these are both issues that should be solved by smarts in the
initrd.

All of the (unused) kernel parameters are in the environment aren't
they? (if not, they can easily be put there).

So maybe insmod/modprobe could be updated to extract relevant options
from the environment.
And the mount of the root filesystem should be called as:

    mount ${rootfstype+-t $rootfstype} $dev $mountpoint

We are depending more and more on initrd and I think it hurts not
having a reference implementation.
Currently each distro makes their own and while I'm sure they are all
quite good in their own way, the fact that they are independent makes
community input harder.

What we really need is a single reference implementation of "mkinitrd"
which each distro can fiddle with to their heart's content.  Then
sensible ideas like the above can be incorporated into the reference,
and all distros will ultimately pick them up.

But unfortunately I don't have the time to volunteer for this role...

NeilBrown
