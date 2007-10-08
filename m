Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXJHXDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXJHXDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXJHXDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:03:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33455 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXJHXDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:03:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470AB73A.9020503@s5r6.in-berlin.de>
Date: Tue, 09 Oct 2007 01:03:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jay Fenlason <fenlason@redhat.com>
Subject: possible recursive locking detected... in __wake_up
References: <b3998a500710080618t46eddf7ah7e64b3d297ff8218@mail.gmail.com> <20071008210029.GA19900@redhat.com>
In-Reply-To: <20071008210029.GA19900@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

how could this ever happen?

>>   =============================================
>>   [ INFO: possible recursive locking detected ]
>>   2.6.23-0.222.rc9.git4.fc8 #1
>>   ---------------------------------------------
>>   X/2522 is trying to acquire lock:
>>    (&q->lock){++..}, at: [<c042671c>] __wake_up+0x15/0x42
>>
>>   but task is already holding lock:
>>    (&q->lock){++..}, at: [<c042671c>] __wake_up+0x15/0x42
>>
>>   other info that might help us debug this:
>>   2 locks held by X/2522:
>>    #0:  (&client->lock){.+..}, at: [<e0993f51>] queue_event+0x2b/0x68 [firewire_core]
>>    #1:  (&q->lock){++..}, at: [<c042671c>] __wake_up+0x15/0x42
>>
>>   stack backtrace:
>>    [<c0406463>] show_trace_log_lvl+0x1a/0x2f
>>    [<c0406e4d>] show_trace+0x12/0x14
>>    [<c0406e65>] dump_stack+0x16/0x18
>>    [<c0449c56>] __lock_acquire+0x189/0xc67
>>    [<c044abae>] lock_acquire+0x7b/0x9e
>>    [<c0634712>] _spin_lock_irqsave+0x4a/0x77
>>    [<c042671c>] __wake_up+0x15/0x42
>>    [<c04aed7e>] ep_poll_safewake+0x86/0xa8
>>    [<c04afa05>] ep_poll_callback+0x9f/0xaa
>>    [<c042483e>] __wake_up_common+0x32/0x55
>>    [<c0426738>] __wake_up+0x31/0x42
>>    [<e0993f7d>] queue_event+0x57/0x68 [firewire_core]
>>    [<e0994a5a>] handle_request+0xd8/0xe0 [firewire_core]
>>    [<e099269a>] fw_core_handle_request+0x215/0x23c [firewire_core]
>>    [<e0961c42>] handle_ar_packet+0xd7/0xeb [firewire_ohci]
>>    [<e0962bac>] ar_context_tasklet+0xb6/0xc4 [firewire_ohci]
>>    [<c0432b5b>] tasklet_action+0x68/0xd3
>>    [<c0432a39>] __do_softirq+0x78/0xff
>>    [<c04075d4>] do_softirq+0x74/0xf7
>>    =======================
(from https://bugzilla.redhat.com/show_bug.cgi?id=323411)

We wake up the queue from a workqueue context (rarely) and from tasklet
context (frequently).  However, since __wake_up disables local IRQs, it
should be entirely impossible for __wake_up to take q->lock twice before
releasing it.  What's the deal?
-- 
Stefan Richter
-=====-=-=== =-=- -=--=
http://arcgraph.de/sr/
