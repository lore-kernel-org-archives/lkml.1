Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbZJOQSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbZJOQSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762383AbZJOQSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:18:50 -0400
Received: from xenotime.net ([72.52.64.118]:60659 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758383AbZJOQSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:18:49 -0400
Date: Thu, 15 Oct 2009 09:18:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Tips for module_init() dependencies
Message-Id: <20091015091813.261e44be.rdunlap@xenotime.net>
In-Reply-To: <4AD74A2A.3090506@gmail.com>
References: <4AD71D12.9060203@gmail.com>
	<1255621559.22917.35.camel@desktop>
	<4AD7469B.9070907@gmail.com>
	<20091015090645.140e04f4.rdunlap@xenotime.net>
	<4AD74A2A.3090506@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 12:13:30 -0400 Gregory Haskins wrote:

> Randy Dunlap wrote:
> > On Thu, 15 Oct 2009 11:58:19 -0400 Gregory Haskins wrote:
> > 
> >> Daniel Walker wrote:
> >>> On Thu, 2009-10-15 at 09:01 -0400, Gregory Haskins wrote:
> >>>
> >>>> may break, because the kernel seems to have no concept of
> >>>> interdependency between foo_init() and bar_init(), and therefore
> >>>> bar_init() may call foo() before foo_init() has executed.
> >>>>
> >>>> There are various ways to solve this problem, such as deferring calling
> >>>> foo() with a workqueue or something, but I was wondering if there was a
> >>>> better/standard way to do this that I am missing?
> >>>>
> >>>> The problem I am having specifically is that I am trying to call
> >>>> configfs_register_subsystem() in a module_init(), but this breaks when
> >>>> built into the kernel based on sheer bad luck that configfs gets
> >>>> initialized after me.  To date I have worked around this by forcing my
> >>>> code to only support built-in, and using late_initcall() instead or
> >>>> module_init.  This works, but it only means I am putting the problem off
> >>>> (code that depends on *me* has to use similar tricks, etc.
> >>> You can't modify the build order so your module get "builtin" after
> >>> configfs?
> >>>
> >> Hi Daniel,
> >>
> >> Possibly.
> >>
> >> A) Any suggestions on how? Can I express this in Kconfig or something
> >> (i.e. "depends on FOO").  I currently have "select FOO" in the BAR
> >> object, but this doesn't seem to be sufficient to describe the relationship.
> > 
> > Not in Kconfig, only in Makefile(s).
> > and please put #comments in them explaining the ordering requirements/needs.
> 
> Hi Randy,
> 
> Something like this?
> 
> ----------
> 
> # cat drivers/bar/Makefile
> 
> bar.o: foo.o
> obj-$CONFIG_BAR += bar.o
> 
> ----------
> 
> ?

Just the order that they are listed in, either within one Makefile
or the order that a parent Makefile lists them, so:

obj-$CONFIG_FOO += foo.o
obj-$CONFIG_BAR += bar.o

That will fix the load/init ordering.  You may also need to specify
build dependencies in Kconfig file(s).


---
~Randy
