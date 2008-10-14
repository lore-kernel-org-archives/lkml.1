Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbYJNP0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbYJNP0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYJNP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:26:35 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:37970 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYJNP0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:26:35 -0400
Subject: Re: [bug] latest -git boot hang
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20081014151236.GA18880@elte.hu>
References: <20081010203043.GA11798@elte.hu>
	 <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu>
	 <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org>
	 <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu>
	 <1223996859.5193.61.camel@moss-spartans.epoch.ncsc.mil>
	 <20081014151236.GA18880@elte.hu>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 14 Oct 2008 11:24:16 -0400
Message-Id: <1223997856.5193.81.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 17:12 +0200, Ingo Molnar wrote:
> * Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > > Right now i have about 40 such annotations for -tip testing:
> > > 
> > >   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > >   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > >   security/selinux/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > >   security/smack/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > >   security/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > 
> > What in particular under fs/Kconfig and security/*Kconfig falls into 
> > this category, and why?  What constitutes a "generic distro bootup"? 
> > For distros that support SELinux, it obviously shouldn't break the 
> > bootup (there have of course been cases where it has, but those were 
> > bugs that have been addressed, including the recent /proc/net 
> > breakage), and for other distros, it should yield no effect as no 
> > policy will be loaded and thus SELinux just allows everything.
> 
> got this one for rootplug:
> 
> --- linux.orig/security/Kconfig
> +++ linux/security/Kconfig
> @@ -93,6 +93,11 @@ config SECURITY_FILE_CAPABILITIES
>  config SECURITY_ROOTPLUG
>         bool "Root Plug Support"
>         depends on USB=y && SECURITY
> +
> +       # fails with hard-to-debug "could not find init" boot failure
> +       depends on BROKEN_BOOT_ALLOWED
> +       select BROKEN_BOOT

Makes sense - rootplug truly is "specialized".

> 
> and this one:
> 
> --- linux.orig/security/selinux/Kconfig
> +++ linux/security/selinux/Kconfig
> @@ -97,6 +97,11 @@ config SECURITY_SELINUX_CHECKREQPROT_VAL
>  config SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT
>         bool "NSA SELinux enable new secmark network controls by default"
>         depends on SECURITY_SELINUX
> +
> +       # old system booted up with this cannot ssh out
> +       depends on BROKEN_BOOT_ALLOWED
> +       select BROKEN_BOOT

What is the oldest distro you test against?  This one does need to be
disabled for distros that predate the policy support for secmark, but
we'd really like to deprecate and ultimately remove the legacy network
controls from SELinux.

> i also have this temporary annotation:
> 
> --- linux.orig/security/smack/Kconfig
> +++ linux/security/smack/Kconfig
> @@ -1,6 +1,9 @@
>  config SECURITY_SMACK
>         bool "Simplified Mandatory Access Control Kernel Support"
>         depends on NETLABEL && SECURITY_NETWORK
> +       # breaks networking (TCP connections)
> +       depends on BROKEN_BOOT_ALLOWED
> +       select BROKEN_BOOT
>         default n
>         help
>           This selects the Simplified Mandatory Access Control Kernel.
> 
> has this problem been fixed? A test is only a success if the freshly 
> booted kernel can autonomously ssh out over a real network and can 
> indicate success to the QA server. I've got a good mix of old and new 
> distros as well.

I thought that Casey had changed Smack such that packets wouldn't be
explicitly labeled by default when they were at the default/ambient
network label and thus wouldn't break sshd.

-- 
Stephen Smalley
National Security Agency

