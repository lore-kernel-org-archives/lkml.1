Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXFLWD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXFLWD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXFLWDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:03:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44555 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbXFLWDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:03:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.22-rc4-mm2: GPF during suspend to RAM on HPC nx6325
Date: Wed, 13 Jun 2007 00:09:50 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200706110102.52946.rjw@sisk.pl> <466CF71B.2000907@gmail.com> <200706122355.26223.rjw@sisk.pl>
In-Reply-To: <200706122355.26223.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706130009.51278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 June 2007 23:55, Rafael J. Wysocki wrote:
> On Monday, 11 June 2007 09:17, Tejun Heo wrote:
> > Hello, Rafael.
> > 
> > Rafael J. Wysocki wrote:
> > > gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch breaks
> > > suspend to RAM on HPC nx6325 (x86_64).
> > > 
> > > With this patch applied I get a general protection fault in mutex_lock+0x15
> > > (kernel/mutex.c:91), called by sysfs_hash_and_remove() (fs/sysfs/inode.c:298),
> > > called by threshold_cpu_callback(), called from _cpu_down().
> > 
> > I'm not sure whether this is bug in sysfs or in sysfs handling code in
> > mce_amd and I can't test mce_amd here.  Can you please apply the
> > attached patch and post the resulting dmesg including oops?
> 
> I've applied the patch, but the oops is a kernel panic, so I can't generate a
> dmesg including it. ;-)
> 
> Here's the dmesg output from a fresh boot (runlevel 2):
> 
> http://www.sisk.pl/kernel/debug/2.6.22-rc4-mm2/dmesg.log
> 
> Here's a picture of the oops taken after a failed attempt to suspend:
> 
> http://www.sisk.pl/kernel/debug/2.6.22-rc4-mm2/during_suspend.jpg
> 
> Here's a picture of the oops taken after a failed attempt to offline CPU1
> using 'echo 1 > /sys/devices/system/cpu/cpu1/online':
> 
> http://www.sisk.pl/kernel/debug/2.6.22-rc4-mm2/after_offlining_cpu1.jpg
> 
> [Sorry for the quality of pictures, I couldn't get anything better.]

More information:

With the debug patch applied the oops is a NULL pointer dereference
at sysfs_hash_and_remove+0x16, which according to gdb is

(gdb) l *sysfs_hash_and_remove+0x16
0xffffffff802d4bff is in sysfs_hash_and_remove (/home/rafael/src/mm/linux-2.6.22-rc4-mm2/fs/sysfs/inode.c:294).
289             int found = 0;
290
291             if (!dir)
292                     return -ENOENT;
293
294             if (dir->d_inode == NULL)
295                     /* no inode means this hasn't been made visible yet */
296                     return -ENOENT;
297
298             mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);

That doesn't make much sense to me, but it's 100% reproducible.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
