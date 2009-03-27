Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZC0Lzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZC0Lzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZC0Lzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:55:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZC0Lzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:55:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: Resume after hibernation regression in 2.6.29
Date: Fri, 27 Mar 2009 12:55:35 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>
References: <200903261920.32173.tvrtko@ursulin.net> <200903270009.00479.rjw@sisk.pl> <200903270801.46712.tvrtko@ursulin.net>
In-Reply-To: <200903270801.46712.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271255.36429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Tvrtko A. Ursulin wrote:
> On Thursday 26 March 2009 23:08:59 Rafael J. Wysocki wrote:
> > On Friday 27 March 2009, Tvrtko A. Ursulin wrote:
> > > On Thursday 26 March 2009 22:38:55 Pavel Machek wrote:
> > > > On Thu 2009-03-26 22:01:03, Tvrtko A. Ursulin wrote:
> > > > > On Thursday 26 March 2009 21:35:29 Rafael J. Wysocki wrote:
> > > > > > On Thursday 26 March 2009, Pavel Machek wrote:
> > > > > > > On Thu 2009-03-26 20:55:23, Tvrtko A. Ursulin wrote:
> > > > > > > > On Thursday 26 March 2009 20:18:40 Pavel Machek wrote:
> > > > > > > > > On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
> > > > > > > > > > Hi guys,
> > > > > > > > > > I have been running custom compiled 2.6.28.7 in OpenSUSE
> > > > > > > > > > 11.1 and using hiberation/resume daily as configured by the
> > > > > > > > > > distro. Yesterday I upgraded to 2.6.29 (make oldconfig from
> > > > > > > > > > 2.6.28.7, attached) and after resume networking (at least)
> > > > > > > > > > does not work. Reboot at this point takes very long because
> > > > > > > > > > of timeouts on CIFS and whatelse.
> > > > > > > > > >
> > > > > > > > > > Below is how /var/log/messagess looks for one cycle
> > > > > > > > > > (hibernate-resume-reboot) and I am also attaching kernel
> > > > > > > > > > config and /var/log/pm-suspend.log.
> > > > > > > > > >
> > > > > > > > > > You will probably notice evil nvidia.ko in there but don't
> > > > > > > > > > panic, it all happens without it as well. Tested from
> > > > > > > > > > runlevel 3 and by running pm-hibernate. After resume from
> > > > > > > > > > that NIC LEDs were off. I tried /etc/init.d/network restart
> > > > > > > > > > but that hung so I ^C and tried rmmod forcedeth && modprobe
> > > > > > > > > > forcedeth && ifup eth0 and after some time network went
> > > > > > > > > > live again. Haven't had time to test further though, so
> > > > > > > > > > this is all pretty rough.
> > > > > > > > >
> > > > > > > > > Ok, can you try to rmmod forcedeth before hibernation, then
> > > > > > > > > insmod it after resume?
> > > > > > > >
> > > > > > > > Sure, after insmod and /etc/init.d/network start following
> > > > > > > > resume network was fine. Guess I could kludge that sequence
> > > > > > > > into pm scripts somehow but would rather avoid that since it
> > > > > > > > slows down the cycle and would make scripts non-stock.
> > > > > > >
> > > > > > > Ok, I guess you need to talk to forcedeth maintainers then...
> > > > > > > sounds like a forcedeth problem to me.
> > > > > >
> > > > > > I have a box with forcedeth somewhere here, I should be able to
> > > > > > check that in the next few days.
> > > > >
> > > > > Not a lot activity in forcedeth.c from 2.6.28 to 2.6.29 so I will CC
> > > > > two guys who commited changes in that period. Ayaz, Tobias, forcedeth
> > > > > does not seem to come up after hibernation well for me. Actual
> > > > > hardware is:
> > > > >
> > > > > 00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev
> > > > > a2)
> > > > >
> > > > > Anything more I can do just shout!
> > > >
> > > > Actually yes. Testing forcedeth from 2.6.28 in 2.6.29 would be nice
> > > > way to prove problem is indeed in that module.
> > >
> > > Good idea, I had to massage it a bit due to some API changes, but the end
> > > result is a correct resume which proves that the problem really is in
> > > forcedeth.
> >
> > Well, since you can easily check what commits changed forcedeth between
> > 2.6.28 and 2.6.29, you can find the one that introduced the problem for
> > you.
> 
> Not so easily :/ I don't know git for start,

I didn't know that, sorry.

Basically, you can do:

$ git whatchanged v2.6.28..v2.6.29 drivers/net/forcedeth.c | grep '^commit'

> what I did so far was through the 
> web interface, but this morning a lot more commits appeared so my assumption 
> that if I start by selecting 2.6.29 tag and then tree, that leaves the view 
> in 2.6.29 tagged state was obviously wrong.
> 
> What I managed to do is to revert this:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=34edaa88324004baf4884fb0388f86059d9c4878
> 
> But that didn't fix the problem. That one was also the last commit yesterday, 
> but not any more today as I said. Interestingly, the next one 
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e70049b9e74267dd47e1ffa62302073487afcb48#patch203) 
> seems to introduce the same change.
> 
> Anyway, I won't have time due to personal and business commitments to test 
> this further for a couple of weeks.

and here's the result (in case you have some time to check):

commit 34edaa88324004baf4884fb0388f86059d9c4878
commit eb10a781824ca63c4e484c4642a19b3370980792
commit a7ee2f73f3ce90d73736de1cf432339c35a3faf2
commit f1405d32e392f2f5f80f4687fe186305de300bf6
commit 001eb84bbf7205f8cc541a75364a6a0892b5d0a2
commit 36994a0a7004fd4777cd93a4b658b5f84bf4c93e
commit 908a7a16b852ffd618a9127be8d62432182d81b4
commit b74ca3a896b9ab5f952bc440154758e708c48884
commit cb52deba12f27af90a46d2f8667a64888118a888
commit 008298231abbeb91bc7be9e8b078607b816d1a4a
commit b94426bd9d16fb2753ada1255c7a432f49dfebcb
commit babcda74e9d96bb58fd9c6c5112dbdbff169e695
commit dccd547e2bf2c01a13c967ae03a705338394fad6
commit e174961ca1a0b28f7abf0be47973ad57cb74e5f0

Thanks,
Rafael
