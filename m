Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbYDKHzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbYDKHzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYDKHyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:54:51 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62345 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbYDKHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:54:49 -0400
Message-ID: <47FF190B.6030406@ah.jp.nec.com>
Date: Fri, 11 Apr 2008 16:53:47 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
CC: kdb@oss.sgi.com, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, nickpiggin@yahoo.com.au,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com
Subject: [PATCH 0/2] add new notifier function ,take3
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A big thanks to everybody who read and replied to previous version.

changelog take2 -> take3

- Rebased 2.6.25-rc8-mm1
- comment updated
- renamed the notifiner name "tunable_notifier" to "tunable_atomic_notifier"
- fixed typo
- move control files debugfs to /sys/kernel

These patches add new notifier function and implement it to panic_notifier_list.
We used the hardcoded notifier chain so far, but it was not flexible. New
notifier is very flexible, because user can change a list of order by control files.

Example)

# cd /sys/kernel/notifiers/
# ls
panic_notifier_list
# cd panic_notifier_list/
# ls
ipmi_msghandler  ipmi_wdog
# insmod notifier_test.ko
# ls
ipmi_msghandler  ipmi_wdog  notifier_test1  notifier_test2
# cat */priority
200
150
500
1000
Kernel panic - not syncing: Panic by panic_module.
__tunable_atomic_notifier_call_chain enter
notifier_test: notifier_test_panic2() is called.
notifier_test: notifier_test_panic() is called.
msg_handler:panic_event was called.
ipmi_wdog:wdog_panic_handler was called.

.....(reboot)

# cd /sys/kernel/notifiers/panic_notifier_list/
# ls
ipmi_msghandler  ipmi_wdog  notifier_test1  notifier_test2
# cat */priority
200
150
500
1000
# echo 10000 > ipmi_msghandler/priority
# echo 5000 > ipmi_wdog/priority
# echo 3000 > notifier_test1/priority
# echo 1500 > notifier_test2/priority
# cat */priority
10000
5000
3000
1500
Kernel panic - not syncing: Panic by panic_module.
__tunable_atomic_notifier_call_chain enter
msg_handler:panic_event was called.
ipmi_wdog:wdog_panic_handler was called.
notifier_test: notifier_test_panic() is called.
notifier_test: notifier_test_panic2() is called.

--
Takenori Nagano <t-nagano@ah.jp.nec.com>

