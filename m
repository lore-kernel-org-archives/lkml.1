Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472Ab0ADRRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0ADRRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251Ab0ADRRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:17:19 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:41552 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753408Ab0ADRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:17:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RQU6PXE7ayU5czuqAYBf8knDwt1uISpXDvDJWHyECsKxGkpDTYAYSiMOa5jH4xZXoEqd1HaBn37zrvKpBUT1qZ14v4nTyDXtOpR2fPE8bOlu5wDgbLmb49soSOA0kA8K;
Date: Mon, 4 Jan 2010 09:17:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Update] Re: [RFC] Asynchronous suspend/resume - test results
Message-ID: <20100104091712.5f2521a4@jbarnes-piketon>
In-Reply-To: <201001022228.31436.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0912211200200.2979-100000@iolanthe.rowland.org>
	<200912212136.12665.rjw@sisk.pl>
	<200912232135.25041.rjw@sisk.pl>
	<201001022228.31436.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jan 2010 22:28:31 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 23 December 2009, Rafael J. Wysocki wrote:
> > On Monday 21 December 2009, Rafael J. Wysocki wrote:
> > > On Monday 21 December 2009, Alan Stern wrote:
> > > > On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:
> > ...
> > > > You should also make SCSI targets and hosts async.  Hosts are
> > > > added in drivers/scsi/hosts.c:scsi_add_host_with_dma() (in
> > > > 2.6.32 this was named scsi_add_host()).  Targets are added in
> > > > drivers/scsi/scsi_sysfs.c:scsi_target_add().  And for
> > > > thoroughness, SCSI devices are added in scsi_sysfs_add_sdev()
> > > > in the same file.
> > > 
> > > Thanks a lot for the pointers.
> > 
> > I put device_enable_async_suspend() in all of these places and that
> > resulted in major reduction of suspend time without starting the
> > async threads upfront. Now, however, starting them upfront helps
> > only a little, within the standard deviation from the "non-upfront"
> > case.
> > 
> > In turn, resume _without_ starting the async threads upfront makes
> > a little sense on my test boxes.  In fact, it only helped on the
> > nx6325 and made things worse on the other two (I added the results
> > from Toshiba Portege R500, but it has the same chipset as the Wind
> > U100, ie. ICH7).
> > 
> > The results are as follows:
> > 
> > 			HP nx6325	MSI Wind U100
> > Toshiba Portege R500
> > 
> > sync suspend		1357 (+/- 35)	 656 (+/-
> > 50)	 889 (+/- 29) sync resume		3027 (+/-
> > 6)	3372 (+/- 30)	4552 (+/- 35)
> > 
> > async suspend		1053 (+/- 50)	 490 (+/-
> > 42)	 620 (+/- 52) async resume		2291 (+/-
> > 7)	3406 (+/- 52)	4557 (+/- 26)
> > 
> > async "upfront" suspend	1040 (+/- 35)	 476 (+/-
> > 9)	 585 (+/- 29) async "upfront" resume	1787 (+/-
> > 7)	1724 (+/- 48)	1990 (+/- 25)
> > 
> > The raw data are at
> > http://www.sisk.pl/kernel/data/async-suspend-updated.pdf
> > http://www.sisk.pl/kernel/data/r500/
> > http://www.sisk.pl/kernel/data/nx6325/
> > http://www.sisk.pl/kernel/data/wind/
> > 
> > and the previous results were moved into
> > http://www.sisk.pl/kernel/data/091220/
> > 
> > The patches used in the testing are in my async branch at
> > http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/async
> > The patches in this branch are not for upstream, but it's on top of
> > the linux-next branch containing patches for the 2.6.34 merge
> > window.
> 
> Here's a small update to this I thought might be interesting to
> someone.
> 
> Namely, I replaced the rotational disk in the Toshiba Portege R500
> with an SSD and ran a few suspend/resume speed tests with the KMS on
> (the previous results for the R500 are with the userspace
> modesetting).  The results are here:
> 
> http://www.sisk.pl/kernel/data/r500-ssd/
> 
> As you can see here:
> 
> http://www.sisk.pl/kernel/data/r500/times-r500-async-resume.txt
> http://www.sisk.pl/kernel/data/r500-ssd/times-r500-async-resume.txt
> 
> the resume times changed quite a bit.  First, the device 0:0:0:0+
> (the SSD) now takes about 0.33 s to resume (the rotational disk took
> about 1.7 s), pretty much as expected.  Second, the slowest resuming
> device is now the graphics (1.1 s), while without the KMS it resumed
> in no time.

Yeah, we've pushed all the work into the kernel, so any needed delays
for i2c or clock settling will be felt by the kernel on resume or mode
set time.

Making the KMS code async was one of the wins for the fast boot stuff
Arjan worked on.

-- 
Jesse Barnes, Intel Open Source Technology Center
