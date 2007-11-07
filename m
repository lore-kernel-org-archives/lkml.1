Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXKGTy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXKGTy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXKGTyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:54:20 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:63817 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262AbXKGTyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:54:19 -0500
Subject: Re: 2.6.24-rc2=another train wreck with amanda
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <20071107103028.f5166fd3.akpm@linux-foundation.org>
References: <200711070649.02136.gene.heskett@gmail.com>
	 <20071107103028.f5166fd3.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 07 Nov 2007 14:47:03 -0500
Message-Id: <1194464823.3956.136.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 10:30 -0800, Andrew Morton wrote:
> > On Wed, 07 Nov 2007 06:49:01 -0500 Gene Heskett <gene.heskett@gmail.com> wrote:
> > Greetings;
> > 
> > I have this line in my /etc/modprobe.conf:
> > options dm-mod major=238
> > 
> > And I had a fsckup while building 2.6.24-rc2 cuz I thought it needed to be 
> > based on 2.6.23.1 that has made 2.6.24-rc2 the only kernel that will boot 
> > without a panic, killing init message.
> > 
> > I can survive that, but amanda (tar) went bonkers last night and tried to do a 
> > level 0 on everything, which is about 50GB, but its virtual tape size is only 
> > 11GB.
> > 
> > The last time this happened that line above fixed the device mapper to a 
> > stable address at a major of 238 which tar was happy with.
> > 
> > An ls -l of /dev/mapper:
> > [root@coyote /]# ls -l /dev/mapper
> > total 0
> > crw------- 1 root root  10, 62 Nov  6 23:40 control
> > brw-rw---- 1 root disk 238,  0 Nov  6 23:40 VolGroup00-LogVol00
> > brw-rw---- 1 root disk 238,  1 Nov  6 23:40 VolGroup00-LogVol01
> > 
> > So that hasn't changed, so what did?  Amanda itself hasn't been changed in 
> > several months, running the 20070727 snapshot of amanda-2.5.2p1 all this 
> > time.  Tar was updated by smart or yumex 2 or 3 days back, so it worked 
> > correctly after the update.  That leaves something in 2.6.24-rc2.  I didn't 
> > build rc1.
> > 
> > Other than that, rc2 seems stable.  But auditd failed to start in the bootup 
> > sequence. I think that's minor and may predate this particular kernel.  
> > However, selinux did a relabel before it booted, could that be the cause?
> > 
> 
> An selinux relabelling could well have caused a full backup by amanda.
> 
> There's a way of forcing a relabelling so that you can confirm this, but I
> forget what it is (cc's added, please).
> 
> But we don't know why the relabelling happened, do we?

Gene took his question to fedora-selinux-list, which is appropriate
since the autorelabel stuff is distro-specific.

In Fedora, rc.sysinit will perform a relabel if /.autorelabel exists or
autorelabel was passed on the kernel command line.  /.autorelabel can be
created by the user, by rc.sysinit itself (if you boot with SELinux
disabled, to force a relabel if you ever re-enable SELinux later), or by
utilities like system-config-{securitylevel,selinux} in response to
changing settings.  Merely installing and booting a new kernel shouldn't
trigger it.

Even when triggered, a relabel shouldn't call setxattr on the file
unless its existing on-disk label doesn't match the file contexts
specification in policy.  There is a force option that unconditionally
sets the label on all files, but I don't see that being used by the
autorelabel support.

-- 
Stephen Smalley
National Security Agency

