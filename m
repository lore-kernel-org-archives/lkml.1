Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbYDONw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbYDONw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759789AbYDONwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:52:20 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:60974 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633AbYDONwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:52:20 -0400
Date: Tue, 15 Apr 2008 19:22:10 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080415135210.GA17765@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins> <1208174767.7427.60.camel@twins> <20080414122741.GB7416@in.ibm.com> <1208176947.7427.68.camel@twins> <20080414144801.GC20671@in.ibm.com> <20080414151946.GA17995@osiris.boeblingen.de.ibm.com> <20080414154642.GA30018@in.ibm.com> <20080414193539.GA4438@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414193539.GA4438@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:35:39PM +0200, Heiko Carstens wrote:
> On Mon, Apr 14, 2008 at 09:16:42PM +0530, Gautham R Shenoy wrote:
> > On Mon, Apr 14, 2008 at 05:19:46PM +0200, Heiko Carstens wrote:
> > > On Mon, Apr 14, 2008 at 08:18:01PM +0530, Gautham R Shenoy wrote:
> > > > On Mon, Apr 14, 2008 at 02:42:27PM +0200, Peter Zijlstra wrote:
> > > 
> > > While you're fixing the cpu hotplug stuff anyway, there's still a bug
> > > present in a few modules init code:
> > > 
> > > Usually they do something like:
> > > 
> > > 	register_hotcpu_notifier(...);
> > > 	for_each_online_cpu(i)
> > > 		...
> > > 
> > > A module's init functions gets called from sys_init_module and there is nothing
> > > that would protect from cpu hotplug.
> > > Therefore the sequence of for_each_online_cpu() and register_hotcpu_notifier()
> > > better should be protected by a surrounding get/put_online_cpus() like this:
> > > 
> > > 	get_online_cpus();
> > > 	register_hotcpu_notifier(...);
> > > 	for_each_online_cpu(i)
> > > 		...
> > > 	put_online_cpus();
> > 
> > But shouldn't this be:
> > 	register_hotcpu_notifier(...);
> > 	get_online_cpus();
> > 	for_each_online_cpus()
> > 		...
> > 	put_online_cpus();
> > 
> > What's the problem with this ordering?
> 
> The problem here is that between register_hotcpu_notifier() and
> get_online_cpus() a cpu might have been hotplugged.
> So on cpu down the registered function might try to undo something that
> wasn't prepared in the first place.
> On cpu up however it will do things twice. Once for the cpus that got
> added between register_hotcpu_notifier() and for_each_online_cpus()
> and then again in the for_each_online_cpus() loop.
> 
> Of course all of these scenarios could be fixed in each driver, but that
> would be a lot of duplicated work. Making sure the combination of
> get_online_cpus() and register_hotcpu_notifier() cannot deadlock would
> make things much easier.

Ah, okay. Thanks for the explanation.
So how about having a new API,
something along the lines of:

kernel/cpu.c
------------------------------------------------------
register_hot_cpu_notifier_init(notifier_name, driver_hotcpu_init_function)
{
	mutex_lock(&cpu_add_remove_lock);
	get_online_cpus();
	__register_hot_cpu_notifier(notifier_name);
	driver_hotcpu_init_function();
	put_online_cpus();
	mutex_unlock(&cpu_add_remove_lock);
}

drivers/mydriver.c
--------------------------------------------------------------
driver_hotcpu_init_function()
{
	for_each_online_cpus()
		perform_subsystem_hotcpu_initialization();
}


driver_init()
{
	register_hotcpu_notifier_init(notifier_name,
			driver_hotcpu_init_function);
}



-- 
Thanks and Regards
gautham
