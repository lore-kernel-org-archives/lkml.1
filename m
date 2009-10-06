Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZJFBgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZJFBgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZJFBgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:36:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:59653 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbZJFBgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:36:46 -0400
Message-ID: <4ACA9EE5.5000104@kernel.org>
Date: Tue, 06 Oct 2009 10:35:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Colin Guthrie <cguthrie@mandriva.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: get_device_parent() race bug
References: <4ABC7DB5.9010402@kernel.org> <20091005233919.GA13029@kroah.com>
In-Reply-To: <20091005233919.GA13029@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 01:35:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Greg KH wrote:
> On Fri, Sep 25, 2009 at 05:22:13PM +0900, Tejun Heo wrote:
>> Hello, Greg, Kay, Guthrie.
>>
>> This problem was reported in bko#14023.  (aiee.. again, sorry about
>> the delay)
>>
>>   http://bugzilla.kernel.org/show_bug.cgi?id=14023
>>
>> sysfs is creating several devices in cuse class concurrently and with
>> CONFIG_SYSFS_DEPRECATED turned off, it triggers the following oops.
>>
>>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>>  IP: [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
>>  PGD 75bb067 PUD 75be067 PMD 0
>>  Oops: 0000 [#1] PREEMPT SMP
>>  last sysfs file: /sys/devices/system/cpu/cpu7/topology/core_siblings
>>  CPU 1
>>  Modules linked in: cuse fuse
>>  Pid: 4737, comm: osspd Not tainted 2.6.31-work #77
>>  RIP: 0010:[<ffffffff81158b0a>]  [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
>>  RSP: 0018:ffff88000042f8f8  EFLAGS: 00010296
>>  RAX: ffff88000042ffd8 RBX: 0000000000000000 RCX: 0000000000000000
>>  RDX: 0000000000000000 RSI: ffff880007eef660 RDI: 0000000000000001
>>  RBP: ffff88000042f918 R08: 0000000000000000 R09: 0000000000000000
>>  R10: 0000000000000001 R11: ffffffff81158b0a R12: ffff88000042f928
>>  R13: 00000000fffffff4 R14: 0000000000000000 R15: ffff88000042f9a0
>>  FS:  00007fe93905a950(0000) GS:ffff880008600000(0000) knlGS:0000000000000000
>>  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>  CR2: 0000000000000038 CR3: 00000000077c9000 CR4: 00000000000006e0
>>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>  Process osspd (pid: 4737, threadinfo ffff88000042e000, task ffff880007eef040)
>>  Stack:
>>   ffff880005da10e8 0000000011cc8d6e ffff88000042f928 ffff880003d28a28
>>  <0> ffff88000042f988 ffffffff811592d7 0000000000000000 0000000000000000
>>  <0> 0000000000000000 0000000000000000 ffff88000042f958 0000000011cc8d6e
>>  Call Trace:
>>   [<ffffffff811592d7>] create_dir+0x67/0xe0
>>   [<ffffffff811593a8>] sysfs_create_dir+0x58/0xb0
>>   [<ffffffff8128ca7c>] ? kobject_add_internal+0xcc/0x220
>>   [<ffffffff812942e1>] ? vsnprintf+0x3c1/0xb90
>>   [<ffffffff8128cab7>] kobject_add_internal+0x107/0x220
>>   [<ffffffff8128cd37>] kobject_add_varg+0x47/0x80
>>   [<ffffffff8128ce53>] kobject_add+0x53/0x90
>>   [<ffffffff81357d84>] device_add+0xd4/0x690
>>   [<ffffffff81356c2b>] ? dev_set_name+0x4b/0x70
>>   [<ffffffffa001a884>] cuse_process_init_reply+0x2b4/0x420 [cuse]
>>   ...
>>
>> The problem is that kobject_add_internal() first adds a kobject to the
>> kset and then try to create sysfs directory for it.  If the creation
>> fails,
> 
> Why would the creation fail?  How are you triggering this?

The above was description of the code in kobject_add_internal() not
the actual failure case.  I'll explain in detail below.

>> it remove the kobject from the kset.  get_device_parent()
>> accesses class_dirs kset while only holding class_dirs.list_lock to
>> see whether the cuse class dir exists.  But when it exists, it may not
>> have finished initialization yet or may fail and get removed soon.  In
>> the above case, the former happened so the second one ends up trying
>> to create subdirectory under null sysfs_dirent.
> 
> What kobjects are you using here?  Shouldn't you be using a 'struct
> device' instead?
> 
> But I don't see what the patch is solving here, how is this triggered?

The culprit is get_device_parent() with !CONFIG_SYSFS_DEPRECATED.
When two virtual device creations race, get_device_parent() can be
entered by two threads and the following can happen.

* thread0:
	device_add(): setup_parent() which calls get_device_parent().

	get_device_parent(): Search the class kset list and and find
	out that class_dir doesn't exist yet.  Proceed to
	kobject_create() and then to kobject_add().

	kobject_add_internal(): The kobj has kset specified.  Add the
	kobj to the kset and then proceed to create_dir().  kobj->sd
	isn't set yet.

* thread1:
	device_add(): setup_parent() which calls get_device_parent().

	get_device_parent(): Search the class kset list.  Voila!
	There's the kobject created by thread0.  Return the kobj.

	device_add(): call kobjct_add() to add the kobj for this
	device to the parent kobj returned by get_device_parent().

	kobject_add_internal(): call create_dir() to create the
	directory for this kobj.

        But, at this point, the parent kobj doesn't have ->sd
        initialized yet because thread0 hasn't finished, so
        sysfs_create_dir() tries to create a directory under NULL
        parent and BOOM.

The problem is that creation of parent isn't atomic against lookup.
It's first added to the kset and then proceeds to create_dir().
Another possible race in get_device_parent() is one thread looking up
the parent and proceeding to parent creation when the other thread
already is trying to create parent but hasn't had the chance to add it
to the kset list.  The function simply doesn't have proper
synchronization.

Thanks.

-- 
tejun
