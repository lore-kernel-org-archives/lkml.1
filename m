Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbXHLLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbXHLLU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbXHLLUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:20:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36352 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673AbXHLLUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:20:48 -0400
Date: Sun, 12 Aug 2007 14:20:46 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: v2.6.23-rc2 locks up during boot (without acpi=off)
In-Reply-To: <20070812012826.cfc9f5bb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708121154150.31747@kivilampi-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0708012131480.1479@kivilampi-30.cs.helsinki.fi>
 <20070812012826.cfc9f5bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; boundary="-696243703-2095005193-1186909427=:31747"
Content-ID: <Pine.LNX.4.64.0708121412480.29120@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-2095005193-1186909427=:31747
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0708121412481.29120@kivilampi-30.cs.helsinki.fi>

On Sun, 12 Aug 2007, Andrew Morton wrote:

> On Sat, 11 Aug 2007 15:39:30 +0300 (EEST) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> 
> > I noticed that v2.6.23-rc1 locks up during boot, same thing happens now 
> > with the latest linus' tree (+net-2.6.24 and tcp-2.6 tree stuff on top 
> > of it; in -rc1 test they weren't though). The exact location of hang
> > varies a bit though. No OOPS, does not respond to sysrq or anything else 
> > besides reset. Last known bootable one is something like 2.6.22-rc4 
> > (I usually run 2.6.21.5 on this machine, haven't tried any 2.6.22 on
> > this after those rcs). Problem seems to start after this line:
> > 
> > Time: acpi_pm clocksource has been installed.
> > 
> > ...the power led starts blinking (not periodic cycle but more or less 
> > varying on-off cycle, never seen that led blink before at all, didn't know 
> > that one can make it blink :-)) and the machine gets consideably slower 
> > too. Never have it been able to complete booting all they way up to login 
> > prompt before lock up.
> > 
> > Tried with acpi=off, boots just fine.
>
> It'd be great if you could run a git bisection search please.

...was already in process... :-)

Here is the result:

git-bisect start
# bad: [7d57c74238cdf570bca20b711b2c0b31a553c1e5] Linux 2.6.23-rc1
git-bisect bad 7d57c74238cdf570bca20b711b2c0b31a553c1e5
# good: [5b78c77092a64e253fe1fde9fbbe818b49330ffc] Linux 2.6.22-rc4
git-bisect good 5b78c77092a64e253fe1fde9fbbe818b49330ffc
# good: [0a6d3a2a3813e7b25267366cfbf9a4a4698dd1c2] uml: fix request->sector update
git-bisect good 0a6d3a2a3813e7b25267366cfbf9a4a4698dd1c2
# good: [29a68ee73ec6a5510cbf9d803cbf6190b615e276] Chinese translation of Documentation/stable_api_nonsense.txt
git-bisect good 29a68ee73ec6a5510cbf9d803cbf6190b615e276
# good: [7f46e6ca0183568a688e6bfe40e3ab9adb305d03] Merge branch 'linus' of master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa
git-bisect good 7f46e6ca0183568a688e6bfe40e3ab9adb305d03
# good: [753811dc82a6a39554c34c13c996c3de9f4aa634] x86_64: arch/x86_64/kernel/aperture.c lower printk severity
git-bisect good 753811dc82a6a39554c34c13c996c3de9f4aa634
# bad: [dc79747019b43c28d1f50aad69b8039f8d8db301] Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc
git-bisect bad dc79747019b43c28d1f50aad69b8039f8d8db301
# bad: [d6da5ce8cc71a13e2f3671361c5a8bd9b82e014d] Pull sony into release branch
git-bisect bad d6da5ce8cc71a13e2f3671361c5a8bd9b82e014d
# good: [b43035a5ec4deecd43019728ab9347df82dd121f] Pull sbs into release branch
git-bisect good b43035a5ec4deecd43019728ab9347df82dd121f
# good: [e8b495fe09bc793ae26774e7b2667f7f658d56e2] Pull dock-bay into release branch
git-bisect good e8b495fe09bc793ae26774e7b2667f7f658d56e2
# bad: [8b8eb7d8cfc6cd95ed00cd58754e8493322505bd] ACPI: update ACPI proc I/F removal schedule
git-bisect bad 8b8eb7d8cfc6cd95ed00cd58754e8493322505bd
# good: [33ce2033433195ccc1fbad00d26ad854b2ab68d0] ACPI: suspend: delete toshiba S1 quirk
git-bisect good 33ce2033433195ccc1fbad00d26ad854b2ab68d0
# bad: [4ebf83c8cf89ab13bc23e46b0fcb6178ca23b43c] ACPI: fix empty macros found by -Wextra
git-bisect bad 4ebf83c8cf89ab13bc23e46b0fcb6178ca23b43c
# bad: [0dc070bb0242481a6100c95e5deaa07b267399a8] ACPI: drivers/acpi/pci_link.c: lower printk severity
git-bisect bad 0dc070bb0242481a6100c95e5deaa07b267399a8

...didn't bother to go any further as the other one just deals with printk 
string... So this is the main suspect:

commit 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Jun 15 19:37:00 2007 -0400

    ACPI: Enable C3 even when PM2_control is zero
    
    On systems that do not have pm2_control_block, we cannot really use
    ARB_DISABLE before C3. We used to disable C3 totally on such systems.
    
    To be compatible with Windows, we need to enable C3 on such systems now.
    We just skip ARB_DISABLE step before entering the C3-state and assume
    hardware is handling things correctly. Also, ACPI spec is not clear
    about pm2_control is _needed_ for C3 or not.
    
    We have atleast one system that need this to enable C3.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>



-- 
 i.
---696243703-2095005193-1186909427=:31747--
