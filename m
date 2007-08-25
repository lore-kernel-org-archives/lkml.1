Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXHYVpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXHYVpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHYVo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:44:56 -0400
Received: from ozlabs.org ([203.10.76.45]:39590 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXHYVoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:44:55 -0400
Subject: Re: [patch 2/2] Sort module list by pointer address to get
	coherent sleepable seq_file iterators
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070824154548.GB21226@Krystal>
References: <20070820202600.116795129@polymtl.ca>
	 <20070820202646.555561265@polymtl.ca>
	 <1187654910.19435.147.camel@localhost.localdomain>
	 <20070824154548.GB21226@Krystal>
Content-Type: text/plain
Date: Sun, 26 Aug 2007 07:44:15 +1000
Message-Id: <1188078255.20041.117.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 11:45 -0400, Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > On Mon, 2007-08-20 at 16:26 -0400, Mathieu Desnoyers wrote:
> > > plain text document attachment (module.c-sort-module-list.patch)
> > > A race that appears both in /proc/modules and in kallsyms: if, between the
> > > seq file reads, the process is put to sleep and at this moment a module is
> > > or removed from the module list, the listing will skip an amount of
> > > modules/symbols corresponding to the amount of elements present in the unloaded
> > > module, but at the current position in the list if the iteration is located
> > > after the removed module.
> > > 
> > > The cleanest way I found to deal with this problem is to sort the module list.
> > > We can then keep the old struct module * as the old iterator, knowing the it may
> > > be removed between the seq file reads, but we only use it as "get next". If it
> > > is not present in the module list, the next pointer will be used.
> > > 
> > > By doing this, removing a given module will now only fuzz the output related to
> > > this specific module, not any random module anymore. Since modprobe uses
> > > /proc/modules, it might be important to make sure multiple concurrent running
> > > modprobes won't interfere with each other.
> > 
> > You've reduced, but not eliminated, the problem.  A new module inserted
> > is quite likely to reuse the same address.
> > 
> 
> Hi Rusty,
> 
> Please tell me if I'm wrong, but I think it would not be a problem:
> 
> - seq_read() makes sure that a buffer large enough is available so that
>   m_show() can fully extract and print the information relative to 1
>   module.
> - m_start() and m_stop() takes the module_mutex, therefore within one
>   seq_read(), once m_start has returned, the struct module * that we
>   have is valid and will be consistent during the whole seq_read
>   operation.
> - If a module is removed, and then a different one is inserted at the
>   same address, while we are between two seq_reads for this given struct
>   module address, the seq_reads will copy to user-space the information
>   that is still in the buffer for the _first_ struct module encountered,
>   not the new one.
> - After that, iteration will continue to the new struct module address,
>   effectively skipping the newly inserted module.

Indeed, I thought that this was a general problem: the seq_list code was
never intended to work on modifiable lists unless you get them in one
big read.

If we accept this problem, what do we do about all the other users?

Rusty.


