Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbXHVRUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbXHVRUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbXHVRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:20:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341AbXHVRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:20:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc3-mm1: WARNING: during resume from suspend on x86_64
Date: Wed, 22 Aug 2007 19:30:01 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221930.01620.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 22 August 2007 11:06, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/

I get this during resume from suspend to RAM and during hibernation:

WARNING: at /home/rafael/src/mm/linux-2.6.23-rc3-mm1/arch/x86_64/kernel/smp.c:380 smp_call_function_single()

Call Trace:
 [<ffffffff8021a97d>] smp_call_function_single+0x52/0xff
 [<ffffffff8022e703>] task_rq_lock+0x3d/0x6f
 [<ffffffff80230fc0>] set_cpus_allowed+0xbf/0xcc
 [<ffffffff802141ab>] sc_freq_event+0x5f/0x63
 [<ffffffff80431c38>] notifier_call_chain+0x33/0x65
 [<ffffffff8024c11f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024c14c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff803bcfa4>] cpufreq_resume+0x131/0x157
 [<ffffffff8038151c>] __sysdev_resume+0x34/0x73
 [<ffffffff80381b76>] sysdev_resume+0x1f/0x61
 [<ffffffff803865e8>] device_power_up+0x9/0x10
 [<ffffffff80256620>] suspend_devices_and_enter+0xbf/0xf7
 [<ffffffff802567bb>] enter_state+0x163/0x1e5
 [<ffffffff802568e1>] state_store+0xa4/0xc2
 [<ffffffff802d7bc5>] subsys_attr_store+0x31/0x33
 [<ffffffff802d7e8d>] sysfs_write_file+0xe0/0x11c
 [<ffffffff80293b77>] vfs_write+0xc7/0x150
 [<ffffffff802940f8>] sys_write+0x47/0x70
 [<ffffffff8020bdce>] system_call+0x7e/0x83

Apparently, smp_call_function_single() is unhappy, because it's called with
interrupts disabled by sc_freq_event() executed (as a notifier) by
cpufreq_resume().  However, cpufreq_resume() is always run with one CPU on
line, so all this stuff should be handled differently.  Oh, dear.
