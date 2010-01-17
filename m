Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153Ab0AQQ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0AQQ1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308Ab0AQQ1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:27:21 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51060 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0AQQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:27:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=h8o0CSOOTSyt7o1Kd9vqLtiGW2fHLkbFlkeZBRYstuAyKPjHutXoykLQ1l0rVXqhC4
         7XSXmaAIPUuxHxWabfFokTYWIP4etNt5i8OYyMKVl71oS1r7fBvG/Yvc1PpMcGYw4sjt
         6FRL9G4B51pkCz1sovTgyn89U1WUEJzxWzroo=
Date: Mon, 18 Jan 2010 00:26:47 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       linux-pcmcia@lists.infradead.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] sysfs: Add lockdep annotations for the sysfs active
 reference
Message-ID: <20100118002647.35035e77@tom-lei>
In-Reply-To: <m11vi8yyrb.fsf_-_@fess.ebiederm.org>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org>
	<4B3EB687.7000005@kernel.org>
	<m11vi8yyrb.fsf_-_@fess.ebiederm.org>
Organization: private
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Jan 2010 13:37:12 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> Holding locks over device_del -> kobject_del -> sysfs_deactivate can
> cause deadlocks if those same locks are grabbed in sysfs show or store
> methods.
> 
> The I model s_active count + completion as a sleeping read/write lock.
> I describe to lockdep sysfs_get_active as a read_trylock,
> sysfs_put_active as a read_unlock, and sysfs_deactivate as a
> write_lock and write_unlock pair.  This seems to capture the essence
> for purposes of finding deadlocks, and in my testing gives finds real
> issues and ignores non-issues.
> 
> This brings us back to holding locks over kobject_del is a problem
> that ideally we should find a way of addressing, but at least lockdep
> can tell us about the problems instead of requiring developers to
> debug rare strange system deadlocks, that happen when sysfs files are
> removed while being written to.

The model has hit a possible deadlock in pcmcia, and the lockdep warning
comes when I unplug my wlan card from pcmcia slot.

Looks like socket->skt_mutex is held in remove path, and it is also
grabbed in .stor method.


[ 9207.755883] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0
[ 9207.786583] 
[ 9207.786586] =======================================================
[ 9207.786595] [ INFO: possible circular locking dependency detected ]
[ 9207.786602] 2.6.33-rc4-wl #8
[ 9207.786607] -------------------------------------------------------
[ 9207.786614] pccardd/841 is trying to acquire lock:
[ 9207.786620]  (s_active){++++.+}, at: [<ffffffff811637f1>] sysfs_addrm_finish+0x36/0x55
[ 9207.786643] 
[ 9207.786645] but task is already holding lock:
[ 9207.786651]  (&socket->skt_mutex){+.+.+.}, at: [<ffffffff812ed04c>] pccardd+0x15d/0x25f
[ 9207.786669] 
[ 9207.786671] which lock already depends on the new lock.
[ 9207.786674] 
[ 9207.786679] 
[ 9207.786680] the existing dependency chain (in reverse order) is:
[ 9207.786687] 
[ 9207.786688] -> #1 (&socket->skt_mutex){+.+.+.}:
[ 9207.786702]        [<ffffffff810796c0>] __lock_acquire+0xb73/0xd2b
[ 9207.786716]        [<ffffffff8107a36b>] lock_acquire+0xe1/0x105
[ 9207.786726]        [<ffffffff813b5ac5>] __mutex_lock_common+0x59/0x49d
[ 9207.786741]        [<ffffffff813b5fbe>] mutex_lock_nested+0x39/0x3e
[ 9207.786752]        [<ffffffff812ef3ed>] pccard_store_resource+0x6b/0xc5
[ 9207.786763]        [<ffffffff812a55da>] dev_attr_store+0x20/0x22
[ 9207.786775]        [<ffffffff8116259a>] sysfs_write_file+0x108/0x144
[ 9207.786787]        [<ffffffff8110cf48>] vfs_write+0xae/0x10b
[ 9207.786798]        [<ffffffff8110d065>] sys_write+0x4a/0x6e
[ 9207.786808]        [<ffffffff81009bc2>] system_call_fastpath+0x16/0x1b
[ 9207.786822] 
[ 9207.786824] -> #0 (s_active){++++.+}:
[ 9207.786835]        [<ffffffff8107956a>] __lock_acquire+0xa1d/0xd2b
[ 9207.786847]        [<ffffffff8107a36b>] lock_acquire+0xe1/0x105
[ 9207.786857]        [<ffffffff81163230>] sysfs_deactivate+0x8b/0xe0
[ 9207.786868]        [<ffffffff811637f1>] sysfs_addrm_finish+0x36/0x55
[ 9207.786879]        [<ffffffff81161c26>] sysfs_hash_and_remove+0x53/0x6a
[ 9207.786890]        [<ffffffff811629fd>] sysfs_remove_file+0x15/0x17
[ 9207.786900]        [<ffffffff812a650e>] device_remove_file+0x17/0x19
[ 9207.786911]        [<ffffffff81213ef7>] pci_remove_sysfs_dev_files+0x6b/0x10c
[ 9207.786924]        [<ffffffff8120dce1>] pci_stop_bus_device+0x55/0x83
[ 9207.786936]        [<ffffffff8120dd99>] pci_remove_bus_device+0x1a/0xba
[ 9207.786947]        [<ffffffff8120de5f>] pci_remove_behind_bridge+0x26/0x3f
[ 9207.786958]        [<ffffffff812efb96>] cb_free+0x4a/0x4f
[ 9207.786969]        [<ffffffff812ec682>] socket_shutdown+0x91/0xfd
[ 9207.786979]        [<ffffffff812ec88a>] socket_remove+0x4e/0x57
[ 9207.786989]        [<ffffffff812ed08b>] pccardd+0x19c/0x25f
[ 9207.787000]        [<ffffffff810674dd>] kthread+0x7f/0x87
[ 9207.787011]        [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
[ 9207.787023] 
[ 9207.787025] other info that might help us debug this:
[ 9207.787027] 
[ 9207.787034] 1 lock held by pccardd/841:
[ 9207.787039]  #0:  (&socket->skt_mutex){+.+.+.}, at: [<ffffffff812ed04c>] pccardd+0x15d/0x25f
[ 9207.787058] 
[ 9207.787060] stack backtrace:
[ 9207.787068] Pid: 841, comm: pccardd Not tainted 2.6.33-rc4-wl #8
[ 9207.787069] Call Trace:
[ 9207.787069]  [<ffffffff8107871d>] print_circular_bug+0xa8/0xb6
[ 9207.787069]  [<ffffffff8107956a>] __lock_acquire+0xa1d/0xd2b
[ 9207.787069]  [<ffffffff811637f1>] ? sysfs_addrm_finish+0x36/0x55
[ 9207.787069]  [<ffffffff8107a36b>] lock_acquire+0xe1/0x105
[ 9207.787069]  [<ffffffff811637f1>] ? sysfs_addrm_finish+0x36/0x55
[ 9207.787069]  [<ffffffff81163230>] sysfs_deactivate+0x8b/0xe0
[ 9207.787069]  [<ffffffff811637f1>] ? sysfs_addrm_finish+0x36/0x55
[ 9207.787069]  [<ffffffff8107760e>] ? trace_hardirqs_off+0xd/0xf
[ 9207.787069]  [<ffffffff813b5897>] ? __mutex_unlock_slowpath+0x119/0x14e
[ 9207.787069]  [<ffffffff811637f1>] sysfs_addrm_finish+0x36/0x55
[ 9207.787069]  [<ffffffff81161c26>] sysfs_hash_and_remove+0x53/0x6a
[ 9207.787069]  [<ffffffff811629fd>] sysfs_remove_file+0x15/0x17
[ 9207.787069]  [<ffffffff812a650e>] device_remove_file+0x17/0x19
[ 9207.787069]  [<ffffffff81213ef7>] pci_remove_sysfs_dev_files+0x6b/0x10c
[ 9207.787069]  [<ffffffff8120dce1>] pci_stop_bus_device+0x55/0x83
[ 9207.787069]  [<ffffffff8120dd99>] pci_remove_bus_device+0x1a/0xba
[ 9207.787069]  [<ffffffff8120de5f>] pci_remove_behind_bridge+0x26/0x3f
[ 9207.787069]  [<ffffffff812efb96>] cb_free+0x4a/0x4f
[ 9207.787069]  [<ffffffff812ec682>] socket_shutdown+0x91/0xfd
[ 9207.787069]  [<ffffffff812ec88a>] socket_remove+0x4e/0x57
[ 9207.787069]  [<ffffffff812ed08b>] pccardd+0x19c/0x25f
[ 9207.787069]  [<ffffffff812eceef>] ? pccardd+0x0/0x25f
[ 9207.787069]  [<ffffffff810674dd>] kthread+0x7f/0x87
[ 9207.787069]  [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
[ 9207.787069]  [<ffffffff813b8014>] ? restore_args+0x0/0x30
[ 9207.787069]  [<ffffffff8106745e>] ? kthread+0x0/0x87
[ 9207.787069]  [<ffffffff8100aa60>] ? kernel_thread_helper+0x0/0x10
[ 9207.788150] device: '0000:16:00.0': device_unregister
[ 9207.788166] PM: Removing info for pci:0000:16:00.0
[ 9207.788405] bus: 'pci': remove device 0000:16:00.0



