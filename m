Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYKFAyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYKFAyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYKFAxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:53:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38025 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYKFAxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:53:53 -0500
Date: Thu, 6 Nov 2008 09:53:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
 hotplug
Message-Id: <20081106095314.8e65f443.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1225931281.11514.27.camel@nimitz>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	<1225817945.12673.602.camel@nimitz>
	<20081105093837.e073c373.kamezawa.hiroyu@jp.fujitsu.com>
	<200811051208.26628.rjw@sisk.pl>
	<20081106091441.6517c072.kamezawa.hiroyu@jp.fujitsu.com>
	<1225931281.11514.27.camel@nimitz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008 16:28:01 -0800
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2008-11-06 at 09:14 +0900, KAMEZAWA Hiroyuki wrote:
> > Ok, please consider "when memory hotplug happens." 
> > 
> > In general, it happens when
> >   1. memory is inserted to slot.
> >   2. the firmware notifes the system to enable already inserted memory.
> > 
> > To trigger "1", you have to open cover of server/pc. Do you open pc while the system
> > starts hibernation ? for usual people, no.
> 
> You're right, this won't happen very often.  We're trying to close a
> theoretical hole that hasn't ever been observed in practice.  But, we
> don't exactly leave races in code just because we haven't observed them.
> I think this is a classic race.
> 
> If we don't close it now, then someone doing some really weirdo hotplug
> is going to run into it at some point.  Who knows what tomorrow's
> hardware/firmware will do?
> 
Hmm, people tend to make crazy hardware, oh yes. the pc may fly in the sky with rocket engine.

My answer to this was "add mutex used in hibernation to memory hotplug interface".
When the mutex blocks ONLINE/OFFLINE memory, the memory range which hibernation should save
will not change. 

Possible solution for this interrupt handling is to do __add_memory() operation
in some kernel thread. Then, we can wait the mutex. 

> > To trigger "2", the user have special console to tell firmware "enable this memory".
> > Such firmware console or users have to know "the system works well." And, more important,
> > when the system is suspended, the firmware can't do hotplug because the kernel is sleeping.
> > So, such firmware console or operator have to know the system status.
> > 
> > Am I missing some ? Current linux can know PCI/USB hotplug while the
> > system is suspended ?
> 
> * echo 'disk' > /sys/power/state
> * count number of pages to write to disk
> * turn all interrupts off
> * copy pages to disk
> * power down
> 
> I think the race we're trying to close is the one between when we count
> pages and when we turn interrupts off.  I assume that there is a reason
> that we don't do the *entire* hibernation process with interrupts off,
> probably because it would "lock" the system up for too long, and can
> even possibly fail.
> 
Hmm, while interrupts off, lru_add_drain_all() or some smp_call_function() will be blocked.
Can't we do 
    while(..){
            go to next mem_section
            if (!section_is_available)
		continue;
            freeze this mem_section.
	    count pages should be saved.
    	    write it to disk
    }
per mem_section ? (maybe addling lock bit in mem_section->section_mem_map is enough.)

Hmm? 

-Kame

