Return-Path: <linux-kernel-owner+w=401wt.eu-S1763946AbYDNTfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763946AbYDNTfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbYDNTfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:35:43 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34415 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYDNTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:35:43 -0400
Date: Mon, 14 Apr 2008 21:35:39 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080414193539.GA4438@osiris.boeblingen.de.ibm.com>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins> <1208174767.7427.60.camel@twins> <20080414122741.GB7416@in.ibm.com> <1208176947.7427.68.camel@twins> <20080414144801.GC20671@in.ibm.com> <20080414151946.GA17995@osiris.boeblingen.de.ibm.com> <20080414154642.GA30018@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414154642.GA30018@in.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:16:42PM +0530, Gautham R Shenoy wrote:
> On Mon, Apr 14, 2008 at 05:19:46PM +0200, Heiko Carstens wrote:
> > On Mon, Apr 14, 2008 at 08:18:01PM +0530, Gautham R Shenoy wrote:
> > > On Mon, Apr 14, 2008 at 02:42:27PM +0200, Peter Zijlstra wrote:
> > 
> > While you're fixing the cpu hotplug stuff anyway, there's still a bug
> > present in a few modules init code:
> > 
> > Usually they do something like:
> > 
> > 	register_hotcpu_notifier(...);
> > 	for_each_online_cpu(i)
> > 		...
> > 
> > A module's init functions gets called from sys_init_module and there is nothing
> > that would protect from cpu hotplug.
> > Therefore the sequence of for_each_online_cpu() and register_hotcpu_notifier()
> > better should be protected by a surrounding get/put_online_cpus() like this:
> > 
> > 	get_online_cpus();
> > 	register_hotcpu_notifier(...);
> > 	for_each_online_cpu(i)
> > 		...
> > 	put_online_cpus();
> 
> But shouldn't this be:
> 	register_hotcpu_notifier(...);
> 	get_online_cpus();
> 	for_each_online_cpus()
> 		...
> 	put_online_cpus();
> 
> What's the problem with this ordering?

The problem here is that between register_hotcpu_notifier() and
get_online_cpus() a cpu might have been hotplugged.
So on cpu down the registered function might try to undo something that
wasn't prepared in the first place.
On cpu up however it will do things twice. Once for the cpus that got
added between register_hotcpu_notifier() and for_each_online_cpus()
and then again in the for_each_online_cpus() loop.

Of course all of these scenarios could be fixed in each driver, but that
would be a lot of duplicated work. Making sure the combination of
get_online_cpus() and register_hotcpu_notifier() cannot deadlock would
make things much easier.
