Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYDNPUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYDNPUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYDNPTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:19:49 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:21629 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYDNPTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:19:48 -0400
Date: Mon, 14 Apr 2008 17:19:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080414151946.GA17995@osiris.boeblingen.de.ibm.com>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins> <1208174767.7427.60.camel@twins> <20080414122741.GB7416@in.ibm.com> <1208176947.7427.68.camel@twins> <20080414144801.GC20671@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414144801.GC20671@in.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 08:18:01PM +0530, Gautham R Shenoy wrote:
> On Mon, Apr 14, 2008 at 02:42:27PM +0200, Peter Zijlstra wrote:

While you're fixing the cpu hotplug stuff anyway, there's still a bug
present in a few modules init code:

Usually they do something like:

	register_hotcpu_notifier(...);
	for_each_online_cpu(i)
		...

A module's init functions gets called from sys_init_module and there is nothing
that would protect from cpu hotplug.
Therefore the sequence of for_each_online_cpu() and register_hotcpu_notifier()
better should be protected by a surrounding get/put_online_cpus() like this:

	get_online_cpus();
	register_hotcpu_notifier(...);
	for_each_online_cpu(i)
		...
	put_online_cpus();

But as far as I can see that can lead to a deadlock if e.g. cpu 0 would
execute the code above whild cpu 1 is executing some cpu hotplug code:

cpu0: get_online_cpus()
       -> increase cpu_hotplug.refcount
cpu1: cpu_down()
       -> cpu_maps_update_begin()
       -> grab cpu_add_remove_lock
       -> wait for cpu_hotplug.refcount to drop to zero again
cpu0: register_hotcpu_notifier()
       -> cpu_maps_update_begin
       -> tries to grab cpu_add_remove_lock that cpu 1 holds already
          -> dead
