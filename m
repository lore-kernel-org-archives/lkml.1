Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbXIKTXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbXIKTXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762833AbXIKTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:23:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762433AbXIKTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:23:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: clockevents: fix resume logic
Date: Tue, 11 Sep 2007 21:35:15 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200707220159.l6M1xBgH001236@hera.kernel.org> <200709111409.13796.rjw@sisk.pl> <20070911112531.80bac380.akpm@linux-foundation.org>
In-Reply-To: <20070911112531.80bac380.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112135.16639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 20:25, Andrew Morton wrote:
> On Tue, 11 Sep 2007 14:09:12 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 11 September 2007 13:22, Andrew Morton wrote:
> > > On Tue, 11 Sep 2007 13:23:55 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Tuesday, 11 September 2007 12:31, Andrew Morton wrote:
> > > > > On Tue, 11 Sep 2007 11:16:04 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > > 
> > > > > > On Tue, 2007-09-11 at 01:35 -0700, Andrew Morton wrote:
> > > > > > > On Tue, 11 Sep 2007 01:20:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > > > 
> > > > > > > > On Tue, 11 Sep 2007 09:47:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > > > > > 
> > > > > > > > > On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > > > > > > > > > I went back to the original patch which I sent to Linus and it matches
> > > > > > > > > > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > > > > > > > > > must have been something else in the tree which I tested which fixed the
> > > > > > > > > > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > > > > > > > > > 
> > > > > > > > > > > Can you think what would cause the symptoms which I described?  
> > > > > > > > > > 
> > > > > > > > > > It seems that time is not updated. Timer interrupt not active or some
> > > > > > > > > > other odd thing. I figure out what's going on when I find a box which
> > > > > > > > > > exposes the problem.
> > > > > > > > 
> > > > > > > > 2.6.22-rc6-mm1's git-acpi.patch contains something which fixes this bug. 
> > > > > > > 
> > > > > > > Len's current tree fixes it too.
> > > > 
> > > > Do you mean this one:
> > > > 
> > > > http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git
> > > 
> > > Nope.
> > > 
> > > Here's the algorthm: go to the latest -mm tree and look at the first line
> > > of broken-out/git-acpi.patch:
> > > 
> > > GIT f94aac9883f9b02700270cf286577a9bccf98f47 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git#test
> > > 
> > > that gives the URL, the branch and the top-level commit.  All the -mm git
> > > trees have that first line.
> > > 
> > > 
> > > 
> > > Anyway, I was able to extract all the diffs and generate a patch series. 
> > > The below patch fixes current mainline on the Vaio.
> > 
> > It evidently assumes cpuidle to be present, which is not in the mainline.
> 
> Bear in mind that the cpuidle patch fixes resume-from-ram when cpuidle is
> disabled in config.
> 
> > It seems to me that the total effect of this one and the hackpatch is that
> > the C states are not handled any more.
> 
> hm.
> 
> dmesg without the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-bad.txt
> dmesg with the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-good.txt
> difference: http://userweb.kernel.org/~akpm/dmesg-diff.txt
> 
> there doesn't seem to be a lot of difference in the time handling, except
> there are large changes in when things happen in the bootup sequence.

Hm, these things look like they may be related to the suspend/resume problems:

+Marking TSC unstable due to: possible TSC halt in C2.

+Clocksource tsc unstable (delta = -458965792 ns)
