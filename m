Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYHOC4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYHOC4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYHOC4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:56:25 -0400
Received: from mga07.intel.com ([143.182.124.22]:34489 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYHOC4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,213,1217833200"; 
   d="scan'208";a="33945556"
Message-ID: <48A4F05B.9050309@linux.intel.com>
Date: Fri, 15 Aug 2008 04:56:27 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <20080814083828.d10e126d.randy.dunlap@oracle.com> <20080814154456.GA26388@kroah.com>
In-Reply-To: <20080814154456.GA26388@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 14, 2008 at 08:38:28AM -0700, Randy Dunlap wrote:
>> calling  param_sysfs_init+0x0/0x1e7
>> ------------[ cut here ]------------
>> WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
>> sysfs: duplicate filename 'acpi' can not be created
> 
> Why would this be a sysfs error, it's acpi doing something foolish,
> that's why the sysfs layer is warning about it :)

The NULL pointer reference further down actually looks like something
foolish in the sysfs layer. But actually ACPI is not doing
anything wrong here I think. According to the backtrace it happens
when a kernel param (aka module_param) is set. And creating multiple
params in the same acpi space is completely legal.

It looks more like the high level code that sets up these parameters
broke somehow and starts registering these twice and now ACPI is the
first one to hit it (maybe because it starts with 'a' :-). Or perhaps
sysfs checking just got more anal and the params code relied on
being able to register duplicate directories?

Putting rusty into cc.

-Andi

calling  param_sysfs_init+0x0/0x1e7
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc3-next-20080814 #1

Call Trace:
  [<ffffffff802358cb>] warn_slowpath+0xae/0xdd
  [<ffffffff8036a6be>] ? number+0x115/0x21f
  [<ffffffff8036574d>] ? __next_cpu+0x19/0x26
  [<ffffffff8022d575>] ? find_busiest_group+0x25b/0x6ee
  [<ffffffff8036aefc>] ? string+0x3d/0xa2
  [<ffffffff80365e02>] ? idr_get_empty_slot+0x161/0x24e
  [<ffffffff8036b2ea>] ? vsnprintf+0x389/0x678
  [<ffffffff802def96>] ? sysfs_ilookup_test+0x0/0x14
  [<ffffffff802aa5bf>] ? ifind+0x3d/0xac
  [<ffffffff802df1bd>] ? sysfs_find_dirent+0x1c/0x31
  [<ffffffff802df1f1>] ? __sysfs_add_one+0x1f/0x7c
  [<ffffffff802df283>] sysfs_add_one+0x35/0x3d
  [<ffffffff802df7d2>] create_dir+0x58/0x93
  [<ffffffff802df845>] sysfs_create_dir+0x38/0x4f
  [<ffffffff80366b8a>] kobject_add_internal+0xce/0x18f
  [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
  [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
  [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
  [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
  [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
  [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
  [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
  [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
  [<ffffffff80209047>] _stext+0x47/0x13f
  [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
  [<ffffffff807508e5>] kernel_init+0x11b/0x171
  [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
  [<ffffffff8020ce49>] child_rip+0xa/0x11
  [<ffffffff807507ca>] ? kernel_init+0x0/0x171
  [<ffffffff8020ce3f>] ? child_rip+0x0/0x11
