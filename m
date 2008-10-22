Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYJVQTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYJVQTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbYJVQSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:18:49 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:37347 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbYJVQSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:18:48 -0400
From: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Bug in sysctl table code?
Date: Wed, 22 Oct 2008 17:18:44 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <31060_1224692340_48FF5274_31060_53418_1_200810221718.45030.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 22/10/2008 17:18:45,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 22/10/2008 17:18:46,
	Serialize complete at 22/10/2008 17:18:46
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello to all and Al specifically,

Al, you were the last to touch kernel/sysctl.c and put in a WARN_ON(1) check on line 1930 which I seem to be hitting. Commit in question: http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commitdiff;h=ae7edecc9b8810770a8e5cb9a466ea4bdcfa8401

I thought I was not doing anything special, which also implies nothing wrong, but feel free to tell me correct me if not so. I have a test module which registers some sysctl tables to create this layout:

/proc/sys/test/
/proc/sys/test/a
/proc/sys/test/a/1
/proc/sys/test/a/1/item
/proc/sys/test/b
/proc/sys/test/b/1
/proc/sys/test/b/1/item
/proc/sys/test/b/2
/proc/sys/test/b/2/item
/proc/sys/test/b/3
/proc/sys/test/b/3/item
/proc/sys/test/b/4
/proc/sys/test/b/4/item
/proc/sys/test/b/5
/proc/sys/test/b/5/item

Unregistering is done in a different order and that seems to trigger this (ignore tainted status please since it is caused by my test module):

Oct 22 16:10:59 vm-kernel-32 kernel: [   63.064657] ------------[ cut here ]------------
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.064717] WARNING: at kernel/sysctl.c:1930 unregister_sysctl_table+0x9a/0xc5()
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.064760] Modules linked in: sysctlunreg(P-) psmouse af_packet serio_raw pcspkr i2c_piix4 container ac button evdev ext3 jbd mbcache ide_cd_mod cdrom floppy pcnet32 mii thermal processor
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065416] Pid: 2799, comm: rmmod Tainted: P        W 2.6.27-rc6 #3
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065685]  [<c0117078>] warn_on_slowpath+0x41/0x65
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065839]  [<c015853b>] ? check_bytes_and_report+0x21/0x8f
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065881]  [<c0158897>] ? check_object+0x111/0x1a4
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065891]  [<c011c5c0>] unregister_sysctl_table+0x9a/0xc5
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065898]  [<c0131f39>] ? trace_hardirqs_on+0xb/0xd
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.065959]  [<e089600b>] unreg_one+0xb/0x15 [sysctlunreg]
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066371]  [<e08960e3>] test_exit+0x53/0x65 [sysctlunreg]
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066381]  [<c013a186>] sys_delete_module+0x163/0x1c1
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066389]  [<c012951d>] ? up_read+0x16/0x29
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066397]  [<c0262e09>] ? do_page_fault+0x300/0x5c1
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066407]  [<c0102b1d>] sysenter_do_call+0x12/0x35
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066476]  =======================
Oct 22 16:10:59 vm-kernel-32 kernel: [   63.066612] ---[ end trace 4eaa2a86a8e2da22 ]---

Finally, code looks like this:

-----------------<CUT HERE>--------------------------------------------------------
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/sysctl.h>

static struct ctl_table_header *header[10];
static unsigned int d[10];
static ctl_table *tree[10];

static struct ctl_table_header *reg_one(ctl_table *tree, char *first, char *second, unsigned int *data)
{
	const unsigned int items = 8;

	tree = kzalloc(items*sizeof(ctl_table), GFP_KERNEL);

	tree[0].procname = "test";
	tree[0].mode = 0555;
	tree[0].child = &tree[2];

	tree[2].procname = first;
	tree[2].mode = 0555;
	tree[2].child = &tree[4];

	tree[4].procname = second;
	tree[4].mode = 0555;
	tree[4].child = &tree[6];

	tree[6].procname = "item";
	tree[6].mode = 0555;
	tree[6].data = data;
	tree[6].maxlen = sizeof(unsigned int);
	tree[6].proc_handler = proc_dointvec;

	return register_sysctl_table(tree);
}

static void unreg_one(struct ctl_table_header *h, ctl_table *t)
{
	unregister_sysctl_table(h);
	kfree(t);
}

static int __init test_init(void)
{
	header[0] = reg_one(tree[0], "a", "1", &d[0]);
	header[1] = reg_one(tree[1], "b", "1", &d[1]);
	header[2] = reg_one(tree[2], "b", "2", &d[2]);
	header[3] = reg_one(tree[3], "b", "3", &d[3]);
	header[4] = reg_one(tree[4], "b", "4", &d[4]);
	header[5] = reg_one(tree[5], "b", "5", &d[5]);
	
	return 0;
}

static void __exit test_exit(void)
{
	unreg_one(header[1], tree[1]);
	unreg_one(header[2], tree[2]);
	unreg_one(header[5], tree[5]);
	unreg_one(header[3], tree[3]);
	unreg_one(header[4], tree[4]);
	unreg_one(header[0], tree[0]);
}

module_init(test_init);
module_exit(test_exit);
-----------------<CUT HERE>--------------------------------------------------------

I would never expect unregistering having to be done in the same order, but a) I may be wrong, or b) there may be another bug in my test code. Hopefully you will know something about this.

Regards,

Tvrtko

P.S. Sorry for the dupe, I blame it on Notes!


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

