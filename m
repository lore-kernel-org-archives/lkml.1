Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbZKKOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbZKKOqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZKKOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:46:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbZKKOqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:46:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Wed, 11 Nov 2009 15:47:21 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911111238.22696.rjw@sisk.pl> <87pr7pi40p.fsf@tac.ki.iif.hu>
In-Reply-To: <87pr7pi40p.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111547.21149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Wednesday 11 November 2009, Ferenc Wagner wrote:
> >
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >>> On Thursday 29 October 2009, Ferenc Wagner wrote:
> >>>
> >>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >>>> 
> >>>>> On Wednesday 28 October 2009, Ferenc Wagner wrote:
> >>>>> 
> >>>>>> 2.6.32-rc5 feels particularly bad, with frequent failures to switch
> >>>>>> off the machine after "S|" or freezes after "Snapshotting system".
> >>>>>> The former does not cause much trouble in itself, as the machine can
> >>>>>> be switched off and resumed all right, but the latter is nasty.
> >>>>>> Suspend to RAM works all the time.  The issue is not reproducible,
> >>>>>> unfortunately, and the kernel change happened almost together with a
> >>>>>> BIOS upgrade.  Yesterday I switched back to 2.6.31 to see whether it
> >>>>>> still works stably with the new BIOS.  I'll report back my findings in
> >>>>>> a couple of days.
> >>>>>
> >>>>> OK, thanks.
> >>>>>
> >>>>> Still, I'm really afraid we won't be able to debug it any further without a
> >>>>> reproducible test case.
> >>>>
> >>>> Can't you perhaps suggest a way forward there?  Or some tricks to create a
> >>>> reproducible test case here?
> >>>
> >>> Well, you can test if the problem is reproducible in the "shutdown" mode of
> >>> hibernation.
> >> 
> >> Well, both failure modes happen with "shutdown" mode as well (the S|
> >> freeze with yesterday's git, too), but still not reproducibly.  When
> >> s2disk is stuck in "Snapshotting system", the system is not completely
> >> dead, it echoes line feeds and Ctrl-C at least (as added to #14504).
> >> 
> >> I wonder what you did if the issue was reproducible...  Is that totally
> >> unapplicable if the problem happens with 10% probability only?  Slow,
> >> sure, but until I manage to set up an automated testing bench...
> >
> > I would try to identify the commit that made the problem appear using git
> > bisection.  However, this is really difficult with problems that are not
> > reliably reproducible.
> 
> Indeed.  I'm thinking about setting up a script, which does nothing but
> hibernates the laptop in a loop, and get my router provide a constant
> stream of WOL packets to restart it.  If it always freezes in bounded
> time that will make bisecting possible, if slow.

Alternatively, you can use the RTC alarm to wake up the machine.

> > Failing that, I would add some instrumentation to the code to identify the
> > exact place where it hangs.
> 
> I managed to achieve this with my STR problem, see
> http://bugs.freedesktop.org/show_bug.cgi?id=22126#c17, but maybe that
> status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
> wasn't deep enough, as it got no followup.  How deep should one go to be
> useful?

No, this is deep enough and indicates a BIOS issue.

> I can probably do so again, if slower; but this case may also be easier
> if I can depend on working console output.  Which are the interesting
> parts for instrumentation?  Can those parts produce console output to
> VGA or netconsole?  Wouldn't switching on ACPI debugging before invoking
> s2disk be useful?  Which parts of it (to avoid it spitting out MBs of
> useless characters)?

I usually don't do that and if the issue is reproducible in the "shutdown"
mode, ACPI is most probably not involved.

> > BTW, did you carry out the /sys/power/pm_test "core" test on the box?
> 
> I'm not clear on how to do that with user space suspend.  Simply set it
> to "cores" before invoking s2disk?

Yes, echo "core" to /sys/power/pm_test before executing s2disk.

> I already did the test for STR (see
> http://bugs.freedesktop.org/show_bug.cgi?id=22126#c3), but will redo
> with the current kernel tonight.

OK, thanks.

Best,
Rafael
