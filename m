Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYJNPNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYJNPNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYJNPNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:13:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbYJNPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:13:21 -0400
Date: Tue, 14 Oct 2008 17:12:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [bug] latest -git boot hang
Message-ID: <20081014151236.GA18880@elte.hu>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu> <1223996859.5193.61.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223996859.5193.61.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > Right now i have about 40 such annotations for -tip testing:
> > 
> >   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> >   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> >   security/selinux/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> >   security/smack/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> >   security/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> 
> What in particular under fs/Kconfig and security/*Kconfig falls into 
> this category, and why?  What constitutes a "generic distro bootup"? 
> For distros that support SELinux, it obviously shouldn't break the 
> bootup (there have of course been cases where it has, but those were 
> bugs that have been addressed, including the recent /proc/net 
> breakage), and for other distros, it should yield no effect as no 
> policy will be loaded and thus SELinux just allows everything.

got this one for rootplug:

--- linux.orig/security/Kconfig
+++ linux/security/Kconfig
@@ -93,6 +93,11 @@ config SECURITY_FILE_CAPABILITIES
 config SECURITY_ROOTPLUG
        bool "Root Plug Support"
        depends on USB=y && SECURITY
+
+       # fails with hard-to-debug "could not find init" boot failure
+       depends on BROKEN_BOOT_ALLOWED
+       select BROKEN_BOOT


and this one:

--- linux.orig/security/selinux/Kconfig
+++ linux/security/selinux/Kconfig
@@ -97,6 +97,11 @@ config SECURITY_SELINUX_CHECKREQPROT_VAL
 config SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT
        bool "NSA SELinux enable new secmark network controls by default"
        depends on SECURITY_SELINUX
+
+       # old system booted up with this cannot ssh out
+       depends on BROKEN_BOOT_ALLOWED
+       select BROKEN_BOOT

i also have this temporary annotation:

--- linux.orig/security/smack/Kconfig
+++ linux/security/smack/Kconfig
@@ -1,6 +1,9 @@
 config SECURITY_SMACK
        bool "Simplified Mandatory Access Control Kernel Support"
        depends on NETLABEL && SECURITY_NETWORK
+       # breaks networking (TCP connections)
+       depends on BROKEN_BOOT_ALLOWED
+       select BROKEN_BOOT
        default n
        help
          This selects the Simplified Mandatory Access Control Kernel.

has this problem been fixed? A test is only a success if the freshly 
booted kernel can autonomously ssh out over a real network and can 
indicate success to the QA server. I've got a good mix of old and new 
distros as well.

	Ingo
