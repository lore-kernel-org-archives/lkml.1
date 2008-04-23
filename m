Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYDWLMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYDWLMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYDWLMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:12:32 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54618 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYDWLMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:12:31 -0400
Message-ID: <480F1957.2070609@ah.jp.nec.com>
Date: Wed, 23 Apr 2008 20:11:19 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
CC: kdb@oss.sgi.com, vgoyal@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       Keith Owens <kaos@ocs.com.au>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com, bwalle@suse.de,
       k-miyoshi@cb.jp.nec.com
Subject: [PATCH 0/3] add new notifier function ,take4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

changelog take3 -> take4

- Rebased 2.6.25-mm1
- Add a document
- Add kdump on panic_notifier

These patches add new notifier function and implement it to panic_notifier_list.
We used the hardcoded notifier chain so far, but it was not flexible. New
notifier is very flexible, because user can change a list of order by control files.

And, third patch moves crash_kexec() to panic_notifier. It helps us to do
something before taking a crash dump. It's useful for some RAS tools developer.
If you want to use it, you have to set config option DUMP_ON_PANIC_NOTIFIER to
Y. Default value of DUMP_ON_PANIC_NOTIFIER is N.
If you set DUMP_ON_PANIC_NOTIFIER to N, kdump has no difference before.

------
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




