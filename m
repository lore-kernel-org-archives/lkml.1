Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbXEYPAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbXEYPAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXEYPAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:00:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbXEYPAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:00:30 -0400
Message-ID: <4656FA04.5000403@redhat.com>
Date: Fri, 25 May 2007 11:00:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Multiple free during oprofile unload
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After applying:

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6c977aad03a18019015035958c65b6729cd0574c

    i386: Fix K8/core2 oprofile on multiple CPUs

We are seeing multiple free of the same object during oprofile shutdown.

May 25 07:02:56 vt kernel: oprofile: using NMI interrupt.
May 25 07:06:41 vt kernel: slab error in verify_redzone_free(): cache `size-32':
double free detected
May 25 07:06:41 vt kernel: 
May 25 07:06:41 vt kernel: Call Trace:
May 25 07:06:41 vt kernel:  [<ffffffff802d93e9>] __slab_error+0x24/0x26
May 25 07:06:41 vt kernel:  [<ffffffff80231fcc>] cache_free_debugcheck+0x110/0x222
May 25 07:06:41 vt kernel:  [<ffffffff8845dbd5>] :oprofile:free_msrs+0x28/0x66
May 25 07:06:41 vt kernel:  [<ffffffff8020b28d>] kfree+0xd7/0x27e
May 25 07:06:41 vt kernel:  [<ffffffff8845dbd5>] :oprofile:free_msrs+0x28/0x66
May 25 07:06:41 vt kernel:  [<ffffffff8845dc47>] :oprofile:nmi_shutdown+0x34/0x36
May 25 07:06:41 vt kernel:  [<ffffffff8845c070>]
:oprofile:oprofile_shutdown+0x23/0x46
May 25 07:06:41 vt kernel:  [<ffffffff8845cdf6>]
:oprofile:event_buffer_release+0x16/0x46
May 25 07:06:41 vt kernel:  [<ffffffff8021237d>] __fput+0xca/0x190
May 25 07:06:41 vt kernel:  [<ffffffff8022d9a7>] fput+0x14/0x16
May 25 07:06:41 vt kernel:  [<ffffffff80224656>] filp_close+0x66/0x71
May 25 07:06:41 vt kernel:  [<ffffffff80239632>] put_files_struct+0x6d/0xc0
May 25 07:06:41 vt kernel:  [<ffffffff80215126>] do_exit+0x296/0x80d
May 25 07:06:41 vt kernel:  [<ffffffff80248600>] debug_mutex_init+0x0/0x45
May 25 07:06:41 vt kernel:  [<ffffffff8024c115>] sys_exit_group+0x12/0x14
May 25 07:06:41 vt kernel:  [<ffffffff8025c11e>] system_call+0x7e/0x83

        for_each_possible_cpu(i) {
                kfree(cpu_msrs[i].counters);
                cpu_msrs[i].counters = NULL;
                kfree(cpu_msrs[i].controls);
                cpu_msrs[i].controls = NULL;
        }

Seems the patch makes all the cpu_msrs[] point to the same area?
