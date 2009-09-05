Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZIEMjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZIEMjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 08:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZIEMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 08:39:47 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39784 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZIEMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 08:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OoyMOcctIPJNVxBNdsgvgP3R7o7uOEDp8JOS7k9RjIf9YxmyHhZQAVbm3vtEVOXP4b
         0QJJC4zRmUooBYGK9BMFjM9x6cbohYtq+kknS41c90Fc2Dwq/uXWqePZXW+TSzh8y830
         uRfHaNOwocFNZGq4Y+rgDDCQUKcvLerk480QQ=
Message-ID: <4AA25C11.9050209@gmail.com>
Date: Sat, 05 Sep 2009 14:39:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [-mm] warning during suspend [was: suspend race -mm regression]
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com> <4A81E073.5080703@gmail.com> <4A9B9C1C.9020506@gmail.com> <200908312132.10904.rjw@sisk.pl> <4AA0FEBF.7040104@gmail.com> <4AA19520.3070708@gmail.com> <4AA19668.5080909@gmail.com>
In-Reply-To: <4AA19668.5080909@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2009 12:36 AM, Jiri Slaby wrote:
> On 09/05/2009 12:30 AM, Jiri Slaby wrote:
>> WARNING: at kernel/smp.c:124
>> __generic_smp_call_function_interrupt+0xfd/0x110()
>> Hardware name: To Be Filled By O.E.M.
>> Modules linked in: nfs lockd auth_rpcgss sunrpc ath5k ath
>> Pid: 3423, comm: pm-suspend Not tainted 2.6.31-rc8-mm1_64 #762
>> Call Trace:
>>  [<ffffffff8103fc48>] warn_slowpath_common+0x78/0xb0
>>  [<ffffffff8103fc8f>] warn_slowpath_null+0xf/0x20
>>  [<ffffffff8106950d>] __generic_smp_call_function_interrupt+0xfd/0x110
>>  [<ffffffff8106956a>] hotplug_cfd+0x4a/0xa0
>>  [<ffffffff81434e47>] notifier_call_chain+0x47/0x90
>>  [<ffffffff8105b311>] raw_notifier_call_chain+0x11/0x20
>>  [<ffffffff8141ece0>] _cpu_down+0x150/0x2d0
> 
> It's the CPU_DEAD notifier:
> ffffffff8141ecd0:       48 83 ce 07             or     $0x7,%rsi
> ffffffff8141ecd4:       48 c7 c7 08 ff 5d 81    mov
> $0xffffffff815dff08,%rdi
> ffffffff8141ecdb:       e8 20 c6 c3 ff          callq  ffffffff8105b300
> <raw_notifier_call_chain>
> ffffffff8141ece0:       3d 02 80 00 00          cmp    $0x8002,%eax

And it's due to:
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch

Should the WARN_ONs now warn only when run_callbacks is true?
