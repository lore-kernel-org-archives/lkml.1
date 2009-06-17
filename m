Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbZFQIrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbZFQIrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbZFQIqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:46:53 -0400
Received: from www.tglx.de ([62.245.132.106]:58878 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbZFQIqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:46:51 -0400
Date: Wed, 17 Jun 2009 10:45:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: [ANNOUNCE] 2.6.29.5-rt21
In-Reply-To: <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain> <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain> <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain> <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain> <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain> <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain> <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

   - update to 2.6.29.5 (2.6.29.5-rt20, which I uploaded yesterday but
     did not announce due to the findings below)
 
   - softirq: lower default priority below hardirq default priority

This fixes a long standing default priority configuration problem of
the -rt series. On UP machines this can result in net_tx softirq
running in an endless loop and starving the irq threads and the other
softirq threads and of course everything with lower priority. It might
be possible to happen on a SMP machine when the hardirq thread
affinities are tweaked in the right way.

What happens is:

     tx interrupt
        lock(card->tx_lock);
        dev_kfree_skb_any(skb);
          blocks on a contended lock
	    
     net_tx softirq runs
        unlocks contended lock but does not schedule away due to equal prio
	repeat:
         calls xmit
	 try_lock(card->tx_lock) fails
	   -> reschedule skb which keeps net_tx running
         goto repeat;

The scheduler does not schedule away net_tx, so this goes on forever.

This has been there forever, but it seems to be easier to trigger in
the 29 -rt series which is probably due to the slab cache lock breaks
we did.

The problem is restricted to a dozen of wireless adapters and network
cards where e1000e is the most popular one. We could patch the
affected drivers for -rt, but we need to have a closer look at the
general assumptions of drivers vs. hardirq/softirq. Note, this is not
a mainline problem as the semantics are entirely correct there.

Lowering the priorities of the softirq threads below the hardirq
threads priorities is a safe workaround for now. It prevents the
runaway scenario under all circumstances as it resembles the mainline
semantics closely.

For all existing -rt systems the problem can be solved w/o patching
the kernel by adjusting the priority of the softirq threads from the
init scripts with chrt.

It's extremly hard to trigger this, we never had a report of that
before, and I want to say thanks to Bernd Oelker who meticulously
worked on reproducing the problem and debugging it with all evil
methods and patches I could come up with. And no, I'm not going to
tell you which nasty hacks made it possible to decode this :)

Download locations:

    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/

Information on the RT patch can be found at:

    http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29.5-rt21 tree, the following patches should be
applied:

    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.5.tar.bz2
    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.5-rt21.bz2

The broken out patches are also available at the same download
locations.

Enjoy !

       tglx

