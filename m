Return-Path: <linux-kernel-owner+w=401wt.eu-S1765025AbXHYVxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765025AbXHYVxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXHYVxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:53:31 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:36270 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXHYVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:53:31 -0400
Date: Sat, 25 Aug 2007 17:53:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] Sort module list by pointer address to get coherent sleepable seq_file iterators
Message-ID: <20070825215329.GA17100@Krystal>
References: <20070820202600.116795129@polymtl.ca> <20070820202646.555561265@polymtl.ca> <1187654910.19435.147.camel@localhost.localdomain> <20070824154548.GB21226@Krystal> <1188078255.20041.117.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1188078255.20041.117.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:50:12 up 26 days, 22:09,  4 users,  load average: 0.20, 0.15, 0.13
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Fri, 2007-08-24 at 11:45 -0400, Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > On Mon, 2007-08-20 at 16:26 -0400, Mathieu Desnoyers wrote:
> > > > plain text document attachment (module.c-sort-module-list.patch)
> > > > A race that appears both in /proc/modules and in kallsyms: if, between the
> > > > seq file reads, the process is put to sleep and at this moment a module is
> > > > or removed from the module list, the listing will skip an amount of
> > > > modules/symbols corresponding to the amount of elements present in the unloaded
> > > > module, but at the current position in the list if the iteration is located
> > > > after the removed module.
> > > > 
> > > > The cleanest way I found to deal with this problem is to sort the module list.
> > > > We can then keep the old struct module * as the old iterator, knowing the it may
> > > > be removed between the seq file reads, but we only use it as "get next". If it
> > > > is not present in the module list, the next pointer will be used.
> > > > 
> > > > By doing this, removing a given module will now only fuzz the output related to
> > > > this specific module, not any random module anymore. Since modprobe uses
> > > > /proc/modules, it might be important to make sure multiple concurrent running
> > > > modprobes won't interfere with each other.
> > > 
> > > You've reduced, but not eliminated, the problem.  A new module inserted
> > > is quite likely to reuse the same address.
> > > 
> > 
> > Hi Rusty,
> > 
> > Please tell me if I'm wrong, but I think it would not be a problem:
> > 
> > - seq_read() makes sure that a buffer large enough is available so that
> >   m_show() can fully extract and print the information relative to 1
> >   module.
> > - m_start() and m_stop() takes the module_mutex, therefore within one
> >   seq_read(), once m_start has returned, the struct module * that we
> >   have is valid and will be consistent during the whole seq_read
> >   operation.
> > - If a module is removed, and then a different one is inserted at the
> >   same address, while we are between two seq_reads for this given struct
> >   module address, the seq_reads will copy to user-space the information
> >   that is still in the buffer for the _first_ struct module encountered,
> >   not the new one.
> > - After that, iteration will continue to the new struct module address,
> >   effectively skipping the newly inserted module.
> 
> Indeed, I thought that this was a general problem: the seq_list code was
> never intended to work on modifiable lists unless you get them in one
> big read.
> 
> If we accept this problem, what do we do about all the other users?
> 

Hum, I guess it would be best for them to switch to the proposed seq
sorted list too. I think that having one example (module.c) that shows
well how this works will be an incentive for other developers to port
their seq_file code to the sorted list (I am thinking, among others,
about kallsyms).

Mathieu

> Rusty.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
