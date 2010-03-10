Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0CJP4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:56:00 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44985 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab0CJPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:55:58 -0500
Date: Wed, 10 Mar 2010 16:55:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
	protection
Message-ID: <20100310155557.GA5768@kernel.dk>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-2-git-send-regression-fweisbec@gmail.com> <20100309083410.GD5768@kernel.dk> <20100309083536.GE5768@kernel.dk> <20100310000533.GF5058@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310000533.GF5058@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10 2010, Frederic Weisbecker wrote:
> On Tue, Mar 09, 2010 at 09:35:37AM +0100, Jens Axboe wrote:
> > Which, btw, throws a new lockdep warning fest:
> > 
> > [   42.247718] scsi7 : ioc0: LSISAS1068E B3, FwRev=011b0300h, Ports=1, MaxQ=483, IRQ=26
> > [   42.281125] BUG: key ffff880c7cb75250 not in .data!
> > [   42.288346] ------------[ cut here ]------------
> > [   42.294490] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x545/0x5f0()
> > [   42.304013] Hardware name: QSSC-S4R
> > [   42.309674] Modules linked in: hid_apple usbhid ehci_hcd uhci_hcd usbcore nls_base mptsas(+) mptscsih mptbase scsi_transport_sas igb sg sr_mod cdrom
> > [   42.332072] Pid: 5197, comm: modprobe Not tainted 2.6.34-rc1 #176
> > [   42.340597] Call Trace:
> > [   42.345335]  [<ffffffff8107fb8d>] ? is_module_address+0x2d/0x60
> > [   42.353670]  [<ffffffff81074aa5>] ? lockdep_init_map+0x545/0x5f0
> > [   42.362154]  [<ffffffff81044648>] warn_slowpath_common+0x78/0xd0
> > [   42.371913]  [<ffffffff810446af>] warn_slowpath_null+0xf/0x20
> > [   42.380109]  [<ffffffff81074aa5>] lockdep_init_map+0x545/0x5f0
> 
> 
> 
> This doesn't look related to my patch, it also happen in -rc1 right?

It's not related, it does happen in -rc1 plain as well.

> > [   42.388402]  [<ffffffff81156636>] ? sysfs_new_dirent+0x76/0x120
> 
> 
> This calls:
> 
> #define sysfs_dirent_init_lockdep(sd)				\
> do {								\
> 	struct attribute *attr = sd->s_attr.attr;		\
> 	struct lock_class_key *key = attr->key;			\
> 	if (!key)						\
> 		key = &attr->skey;				\
> 								\
> 	lockdep_init_map(&sd->dep_map, "s_active", key, 0);	\
> } while(0)
> 
> 
> Looks like the struct lock_class_key is dynamically allocated
> and lockdep doesn't like that.

I saw someone else report the same warning, but from a different path
than mine. I'll try and bisect it.

-- 
Jens Axboe

