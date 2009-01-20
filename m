Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZATOX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZATOX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZATOXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:23:11 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:41706 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZATOXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:23:08 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090120125652.GA1457@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>
	 <20090120125652.GA1457@elte.hu>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Wed, 21 Jan 2009 00:53:00 +1030
Message-Id: <1232461380.4895.33.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 13:56 +0100, Ingo Molnar wrote:
> * Kevin Shanahan <kmshanah@ucwb.org.au> wrote:
> > > This suggests some sort of KVM-specific problem. Scheduler latencies 
> > > in the seconds that occur under normal load situations are noticed and 
> > > reported quickly - and there are no such open regressions currently.
> > 
> > It at least suggests a problem with interaction between the scheduler 
> > and kvm, otherwise reverting that scheduler patch wouldn't have made the 
> > regression go away.
> 
> the scheduler affects almost everything, so almost by definition a 
> scheduler change can tickle a race or other timing bug in just about any 
> code - and reverting that change in the scheduler can make the bug go 
> away. But yes, it could also be a genuine scheduler bug - that is always a 
> possibility.

Okay, I understand.

> Could you please run a cfs-debug-info.sh session on a CONFIG_SCHED_DEBUG=y 
> and CONFIG_SCHEDSTATS=y kernel, while you are experiencing those 
> latencies:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> and post that (relatively large) somewhere, or send it as a reply after 
> bzip2 -9 compressing it? It will include a lot of information about the 
> delays your tasks are experiencing.

Running it while the problem is occuring will be tricky, as it only
lasts for a few seconds at a time. Is it going to be useful at all to
just see those statistics if the system is running normally?

I might need to modify the script a little. Am I right that everything
above "gathering statistics..." is pretty much static information?

I could run top, vmstat and cat /proc/sched_debug in a loop until the
problem occurs and then trim it. Something like:

while true; do
  date                                >> $FILE
  echo "-- top: --"                   >> $FILE
  top -H -c -b -d 1 -n 0.5            >> $FILE 2>/dev/null
  echo "-- vmstat: --"                >> $FILE
  vmstat                              >> $FILE 2>/dev/null
  echo "-- sched_debug #$i: --"       >> $FILE
  cat /proc/sched_debug               >> $FILE 2>/dev/null
done

That should take a snapshot every half second or so.

Regards,
Kevin.

P.S. Please keep kmshanah@flexo.wumi.org.au out of the CC list (it won't
     route properly anyway). I don't know how it got added - the only
     place it would have appeared was in the "revert" commit message
     when I was testing 2.6.28 with the commit I bisected down to
     removed.


