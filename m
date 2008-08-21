Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYHURYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYHURYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYHURYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:24:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47958 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYHURX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:23:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080727012212.GW28946@ZenIV.linux.org.uk>
	<m1d4k2zui4.fsf@frodo.ebiederm.org>
Date: Thu, 21 Aug 2008 10:14:53 -0700
In-Reply-To: <m1d4k2zui4.fsf@frodo.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 21 Aug 2008 00:40:03 -0700")
Message-ID: <m1od3mthma.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [git pull] VFS patches, the first series
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Al Viro <viro@ZenIV.linux.org.uk> writes:
>
>> The first part of huge pile.  Mostly it's untangling nameidata handling,
>> digging towards the pieces that kill intents and cleaning pathname
>> resolution in general.  ->permission() sanitizing and sysctl procfs
>> treatment rewrite needed for it.  A bunch of descriptor handling fixes.
>> Plus part of assorted patched from the last cycle sent by other folks.
>> A _lot_ more is still pending; this is what I'd managed to pull into
>> a series by this point.  Please, pull from
>> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
>
> Al a quick heads up.  In testing movement of network devices between
> namespaces  I hit the recently added WARN_ON in unregister_sysctl_table.

It seems to be some new oddness when destroying a network namespace.

If I don't have network devices to push out of the network namespace
when I clean it up nothing happens.  When I do I get this nice beautiful
backtrace.

I will dig into the sysctl code in a bit and see if I can understand
why this is happening.

------------[ cut here ]------------
WARNING: at /home/eric/projects/linux/linux-2.6-arastra-ns/kernel/sysctl.c:1929 unregister_sysctl_table+0xb5/0x
e5()
Modules linked in:
Pid: 22, comm: netns Tainted: G        W 2.6.27-rc3x86_64 #48

Call Trace:
 [<ffffffff802361da>] warn_on_slowpath+0x51/0x77
 [<ffffffff8023c631>] unregister_sysctl_table+0x34/0xe5
 [<ffffffff8023c6b2>] unregister_sysctl_table+0xb5/0xe5
 [<ffffffff80523f8c>] neigh_sysctl_unregister+0x1a/0x31
 [<ffffffff80559635>] inetdev_event+0x2b4/0x3d1
 [<ffffffff8024b850>] notifier_call_chain+0x29/0x56
 [<ffffffff8051fa2a>] dev_change_net_namespace+0x1bb/0x1da
 [<ffffffff8051fa9d>] default_device_exit+0x54/0xa2
 [<ffffffff8052105e>] netdev_run_todo+0x1fd/0x206
 [<ffffffff8051ce0b>] cleanup_net+0x0/0x95
 [<ffffffff8051ce6f>] cleanup_net+0x64/0x95
 [<ffffffff80244e58>] run_workqueue+0xf1/0x1ee
 [<ffffffff80244e02>] run_workqueue+0x9b/0x1ee
 [<ffffffff802459ee>] worker_thread+0xd8/0xe3
 [<ffffffff80248426>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80245916>] worker_thread+0x0/0xe3
 [<ffffffff80248311>] kthread+0x47/0x76
 [<ffffffff805c7529>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020cdc9>] child_rip+0xa/0x11
 [<ffffffff8020c3ff>] restore_args+0x0/0x30
 [<ffffffff80230bcd>] finish_task_switch+0x0/0xc4
 [<ffffffff802482ca>] kthread+0x0/0x76
 [<ffffffff8020cdbf>] child_rip+0x0/0x11

---[ end trace f9cc56de378eb3ce ]---

