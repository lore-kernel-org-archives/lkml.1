Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZETNo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZETNo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZETNow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:44:52 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:28769 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZETNov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:44:51 -0400
X-SourceIP: 213.93.53.227
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090520131823.GA14933@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242821938.26820.586.camel@twins>
	 <20090520131823.GA14933@redhat.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 15:44:52 +0200
Message-Id: <1242827092.26820.612.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 15:18 +0200, Oleg Nesterov wrote:
> On 05/20, Peter Zijlstra wrote:
> >
> > > > =======================================================
> > > > [ INFO: possible circular locking dependency detected ]
> > > > 2.6.30-rc5-00097-gd665355 #59
> > > > -------------------------------------------------------
> > > > pm-suspend/12129 is trying to acquire lock:
> > > >  (events){+.+.+.}, at: [<ffffffff80259496>] cleanup_workqueue_thread+0x26/0xd0
> > > >
> > > > but task is already holding lock:
> > > >  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff80246e57>]
> > > > cpu_maps_update_begin+0x17/0x20
> > > >
> > > > which lock already depends on the new lock.
> > > >
> > > >
> > > > the existing dependency chain (in reverse order) is:
> > > >
> > > > -> #5 (cpu_add_remove_lock){+.+.+.}:
> > > >        [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
> > > >        [<ffffffff80271f38>] lock_acquire+0x98/0x140
> > > >        [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
> > > >        [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
> > > >        [<ffffffff80246e57>] cpu_maps_update_begin+0x17/0x20
> > > >        [<ffffffff80259c33>] __create_workqueue_key+0xc3/0x250
> > > >        [<ffffffff80287b20>] stop_machine_create+0x40/0xb0
> > > >        [<ffffffff8027a784>] sys_delete_module+0x84/0x270
> > > >        [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
> > > >        [<ffffffffffffffff>] 0xffffffffffffffff
> >
> > Oleg, why does __create_workqueue_key() require cpu_maps_update_begin()?
> > Wouldn't get_online_cpus() be enough to freeze the online cpus?
> 
> Yes, get_online_cpus() pins online CPUs. But CPU_POST_DEAD calls
> cleanup_workqueue_thread() without cpu_hotplug.lock, this means
> that create/destroy can race with cpu_down().
> 
> We can avoid cpu_add_remove_lock, but then we have to add another
> lock to protect workqueues, cpu_populated_map, etc.

Joy..

> > Breaking the setup_lock -> cpu_add_remove_lock dependency seems
> > sufficient.
> 
> Hmm. What do you mean? Afaics setup_lock -> cpu_add_remove_lock
> is not a problem?

>From what I could see that is the only dependency that makes
cpu_add_remove_lock nest under "events" workqueue 'lock', which is what
is generating the deadlock.

