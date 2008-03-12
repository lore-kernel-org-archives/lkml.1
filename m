Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYCLDX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYCLDX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCLDW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:22:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbYCLDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:22:52 -0400
Date: Tue, 11 Mar 2008 20:22:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
Message-Id: <20080311202212.9fe1e5c1.akpm@linux-foundation.org>
In-Reply-To: <1205291010.9828.60.camel@nimitz.home.sr71.net>
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
	<1205291010.9828.60.camel@nimitz.home.sr71.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 20:03:30 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:

> On Wed, 2008-03-12 at 10:37 +0900, penguin-kernel@i-love.sakura.ne.jp
> ...
> > checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> > Brought up 2 CPUs
> > khelper used greatest stack depth: 2684 bytes left
> > net_namespace: 320 bytes
> > NET: Registered protocol family 16
> > INFO: trying to register non-static key.
> > the code is fine but needs lockdep annotation.
> > turning off the locking correctness validator.
> > Pid: 1, comm: swapper Not tainted 2.6.25-rc5-mm1 #1
> >  [<c013dd91>] __lock_acquire+0x194/0x6a3
> >  [<c0167ded>] ? cache_free_debugcheck+0x1fd/0x219
> >  [<c0168938>] ? kfree+0xdb/0xe5
> >  [<c013e775>] lock_acquire+0x6a/0x87
> >  [<c01368e4>] ? down+0xc/0x2f
> >  [<c03492b1>] _spin_lock_irqsave+0x25/0x55
> >  [<c01368e4>] ? down+0xc/0x2f
> >  [<c01368e4>] down+0xc/0x2f
> >  [<c022caf3>] device_add+0x152/0x243
> >  [<c022cbf6>] device_register+0x12/0x15
> >  [<c022ce9b>] device_create+0x76/0x90
> >  [<c04a1861>] vtconsole_class_init+0x72/0xb9
> >  [<c048d8ae>] ? kernel_init+0x0/0x88
> >  [<c048d784>] do_initcalls+0x59/0x134
> >  [<c014bcb1>] ? register_irq_proc+0xb1/0xca
> >  [<c01a0000>] ? proc_symlink+0x5/0x73
> >  [<c048d8ae>] ? kernel_init+0x0/0x88
> >  [<c048d87b>] do_basic_setup+0x1c/0x1e
> >  [<c048d8fb>] kernel_init+0x4d/0x88
> >  [<c01045b7>] kernel_thread_helper+0x7/0x10
> >  =======================
> 
> What is that, btw?? ^^

gregstuff.  There are changes to vt.c in -mm but afacit they aren't related
to vtconsole_class_init().


static int __init vtconsole_class_init(void)
{
	int i;

	vtconsole_class = class_create(THIS_MODULE, "vtconsole");
	if (IS_ERR(vtconsole_class)) {
		printk(KERN_WARNING "Unable to create vt console class; "
		       "errno = %ld\n", PTR_ERR(vtconsole_class));
		vtconsole_class = NULL;
	}

	/* Add system drivers to sysfs */
	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
		struct con_driver *con = &registered_con_driver[i];

		if (con->con && !con->dev) {
			con->dev = device_create(vtconsole_class, NULL,
						 MKDEV(0, con->node),
						 "vtcon%i", con->node);

			if (IS_ERR(con->dev)) {
				printk(KERN_WARNING "Unable to create "
				       "device for %s; errno = %ld\n",
				       con->desc, PTR_ERR(con->dev));
				con->dev = NULL;
			} else {
				vtconsole_init_device(con);
			}
		}
	}

	return 0;
}
postcore_initcall(vtconsole_class_init);

These lockdep-internal things keep on popping up but they're always rather
inscrutable and bound up in internal implementation minutiae and few know
what they mean.  Could this be improved in any way?  Maybe some huge
what-can-i-do-to-fix-this comments in lockdep.c?
