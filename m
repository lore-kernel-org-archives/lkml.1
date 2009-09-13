Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZIMCaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZIMCaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 22:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZIMCaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 22:30:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZIMCaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 22:30:01 -0400
Subject: Re: [origin tree boot crash] Revert "selinux: clean up avc node
 cache when disabling selinux"
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090912072450.GA6767@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Sep 2009 22:28:59 -0400
Message-Id: <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 09:24 +0200, Ingo Molnar wrote:
> James - i did not see a security pull request email from you in my 
> lkml folder so i created this new thread. -tip testing found the 
> easy crash below. It reverts cleanly so i went that easy route.
> 
> At a really quick 10-seconds glance the crash happens because we 
> destroy the slab cache twice, if the sysctl is toggled twice?

Something a lot worse than SELinux here.  I added this exact code and
got this warning.  Something is wrong in the world of
kmem_cache_destroy.....

static struct kmem_cache *tmp_cachep;
tmp_cachep = kmem_cache_create("tmp_cache", sizeof(struct avc_node), 0, SLAB_PANIC, NULL);
        if (tmp_cachep)
                kmem_cache_destroy(tmp_cachep);

[    0.006076] ------------[ cut here ]------------
[    0.007019] WARNING: at lib/kobject.c:595 kobject_put+0x6e/0x80()
[    0.008011] Hardware name:
[    0.009006] kobject: '<NULL>' (ffff88001f8da128): is not initialized, yet kobject_put() is being called.
[    0.010005] Modules linked in:
[    0.011284] Pid: 0, comm: swapper Not tainted 2.6.31-next-20090911 #17
[    0.012011] Call Trace:
[    0.013008]  [<ffffffff8129460e>] ? kobject_put+0x6e/0x80
[    0.014009]  [<ffffffff81070b71>] warn_slowpath_common+0x91/0xd0
[    0.015006]  [<ffffffff81070c66>] warn_slowpath_fmt+0x76/0xa0
[    0.016016]  [<ffffffff811dd8c3>] ? sysfs_remove_dir+0x43/0xf0
[    0.017007]  [<ffffffff810b3a5d>] ? trace_hardirqs_on_caller+0x14d/0x1e0
[    0.018007]  [<ffffffff8129460e>] kobject_put+0x6e/0x80
[    0.019005]  [<ffffffff8129607e>] ? kobject_uevent+0x1e/0x40
[    0.020016]  [<ffffffff81159933>] kmem_cache_destroy+0x213/0x250
[    0.021008]  [<ffffffff812a3d37>] ? __spin_lock_init+0x47/0x90
[    0.022012]  [<ffffffff819e6860>] ? early_idt_handler+0x0/0x71
[    0.023008]  [<ffffffff81a18da3>] avc_init+0xd3/0x120
[    0.024010]  [<ffffffff81a1903e>] selinux_init+0xfe/0x210
[    0.025006]  [<ffffffff819e6860>] ? early_idt_handler+0x0/0x71
[    0.026004]  [<ffffffff81a18bb2>] security_init+0x52/0x80
[    0.027005]  [<ffffffff81a18a16>] ? key_init+0xc6/0xf0
[    0.028009]  [<ffffffff819e764a>] start_kernel+0x35a/0x490
[    0.029005]  [<ffffffff819e69d4>] x86_64_start_reservations+0x94/0xf0
[    0.030004]  [<ffffffff819e6b38>] x86_64_start_kernel+0x108/0x150
[    0.031015] ---[ end trace a7919e7f17c0a725 ]---

