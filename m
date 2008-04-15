Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbYDOOhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbYDOOhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbYDOOhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:37:32 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:54083 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbYDOOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:37:31 -0400
Date: Tue, 15 Apr 2008 16:37:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080415143728.GB25163@osiris.boeblingen.de.ibm.com>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins> <1208174767.7427.60.camel@twins> <20080414122741.GB7416@in.ibm.com> <1208176947.7427.68.camel@twins> <20080414144801.GC20671@in.ibm.com> <20080414151946.GA17995@osiris.boeblingen.de.ibm.com> <20080414154642.GA30018@in.ibm.com> <20080414193539.GA4438@osiris.boeblingen.de.ibm.com> <20080415135210.GA17765@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415135210.GA17765@in.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:22:10PM +0530, Gautham R Shenoy wrote:
> On Mon, Apr 14, 2008 at 09:35:39PM +0200, Heiko Carstens wrote:
> > The problem here is that between register_hotcpu_notifier() and
> > get_online_cpus() a cpu might have been hotplugged.
> > So on cpu down the registered function might try to undo something that
> > wasn't prepared in the first place.
> > On cpu up however it will do things twice. Once for the cpus that got
> > added between register_hotcpu_notifier() and for_each_online_cpus()
> > and then again in the for_each_online_cpus() loop.
> > 
> > Of course all of these scenarios could be fixed in each driver, but that
> > would be a lot of duplicated work. Making sure the combination of
> > get_online_cpus() and register_hotcpu_notifier() cannot deadlock would
> > make things much easier.
> 
> Ah, okay. Thanks for the explanation.
> So how about having a new API,
> something along the lines of:
> 
> kernel/cpu.c
> ------------------------------------------------------
> register_hot_cpu_notifier_init(notifier_name, driver_hotcpu_init_function)
> {
> 	mutex_lock(&cpu_add_remove_lock);
> 	get_online_cpus();
> 	__register_hot_cpu_notifier(notifier_name);
> 	driver_hotcpu_init_function();
> 	put_online_cpus();
> 	mutex_unlock(&cpu_add_remove_lock);
> }
> 
> drivers/mydriver.c
> --------------------------------------------------------------
> driver_hotcpu_init_function()
> {
> 	for_each_online_cpus()
> 		perform_subsystem_hotcpu_initialization();
> }
> 
> 
> driver_init()
> {
> 	register_hotcpu_notifier_init(notifier_name,
> 			driver_hotcpu_init_function);
> }

That looks fine to me.
