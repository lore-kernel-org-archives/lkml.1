Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbYBWMWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbYBWMWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYBWMWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:22:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYBWMWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:22:44 -0500
Date: Sat, 23 Feb 2008 13:22:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080223122222.GA323@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >  Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not if
> >  your distributor already did it for you.
> 
> Have you tried sysprof? It's really nice to setup and use compared to 
> oprofile when profiling user-space.

yes, it's very nice and very usable - and that's all that matters 
really. It's almost a _duty_ of the mainstream kernel to include that 
trivial 200 lines of sysprof code, given how poor instrumentation 
support is on Linux.

As a comparison, here's a session of a newbie developer, meeting 
oprofile for the first time in his life (using a fresh package, 
oprofile-0.9.3-6.fc8):

  ---------------------->
  [ Newbie: WTF, no GUI tool? ]
  [ Narrator: we lose 90% of the developers at this point. ]
  [ Newbie is adventurous and has heard about opcontrol and tries it. ]
 
  # opcontrol

  [ Newbie sees tons of output. User scratches head. After looking 
    around, finds the following option listed:
    "-s/--start       start data collection". That must be it! ]

  # opcontrol -s
  No vmlinux file specified. You must specify the correct vmlinux file, e.g.
  opcontrol --vmlinux=/path/to/vmlinux
  If you do not have a vmlinux file, use
  opcontrol --no-vmlinux
  Enter opcontrol --help for full options

  [ Newbie: WTF? Doesnt oprofile think that what I want to do is to 
    profile ... the currently running kernel, wherever a kernel is 
    and whatever a vmlinux might be?? ]

  [ Narrator: At this point oprofile has confused about 99% of all 
    user-space developers who have no freaking idea about what a vmlinux 
    is. ]

  [ Newbie user figures that --no-vmlinux might be the right option: ]

  # opcontrol -s --no-vmlinux
  Option "--setup" not valid with "-s".

  [ Newbie: WTF? what not valid? Why should i care? Damnit, i only want 
    to profile stuff!!! ]

  [ The newbie user eventually finds out that opcontrol help text is 
    buggy and that -s does not mean --start, but --setup. ]

  [ Narrator: we now have lost 99.99% of the first-time users. ]

  [ Newbie, armed with this nontrivial piece of information: ]

  # opcontrol --start --no-vmlinux
 
  Using default event: CPU_CLK_UNHALTED:100000:0:1:1
  Using 2.6+ OProfile kernel interface.
  Using log file /var/lib/oprofile/samples/oprofiled.log
  Daemon started.
  Profiler running.

  [ Newbie: wow, it's working! Lets start an infinite loop and lets try 
    this opreport thing: ]

  # opreport

   CPU_CLK_UNHALT...|
     samples|      %|
   ------------------
       160405 82.9309 loop

  [ Newbie: hm, i see where the overhead is - but which function is 
    calling it? ]

  [ Newbie user wants to restart profiling and figures that
    opcontrol --reset will do that: ]

  # opcontrol --reset
  Signalling daemon... done

  [ GREAT! It even said "done". Now lets see our new profile: ]

  # opreport
  opreport error: No sample file found: try running opcontrol --dump
  or specify a session containing sample files

  [ Newbie: WTF???? ]

  [ Narrator: we've now lost 99.99999% of the testers at this point. The 
    reamining 10 kernel developers still using oprofile have written up 
    all the commands to the back of their keyboards, for easy reference. ]
  <----------------------

We should hang our collective heads in shame. Oprofile is an utter joke 
in terms of usability. It had 5-10 years to get its stuff together and 
didnt.

200 lines of totally isolated sysprof code is the least thing we can do 
which we _must do_ to help our users.

	Ingo
