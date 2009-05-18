Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZERRdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZERRdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZERRdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:33:38 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:45544 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZERRdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:33:37 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
       Corey Minyard <minyard@acm.org>, dann frazier <dannf@hp.com>
Subject: Re: modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
	<20090516170959.8057c9e4.akpm@linux-foundation.org>
Date: Mon, 18 May 2009 19:33:23 +0200
In-Reply-To: <20090516170959.8057c9e4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 16 May 2009 17:09:59 -0700")
Message-ID: <877i0eqpss.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 12 May 2009 23:28:59 +0200 Ferenc Wagner <wferi@niif.hu> wrote:
>
>> On a Dell PowerEdge 2650 2.6.30-rc5 can't load the ipmi_si module.
>> 2.6.29 has no such problems:
>> 
>> [   46.292160] IPMI System Interface driver.
>> [   46.300321] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
>> [   46.408212] ipmi: Found new BMC (man_id: 0x0002a2,  prod_id: 0x0000, dev_id: 0x00)
>> [   46.423454] IPMI smic interface initialized
>> 
>> But under 2.6.30-rc5:
>> 
>> # modprobe ipmi_si bt_debug=7 smic_debug=7 kcs_debug=7
>> 
>> [  867.851694] IPMI System Interface driver.
>> [  867.859771] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
>> [  867.880250] start_smic_transaction - 18 01
>> [  867.880263] smic_event - smic->smic_timeout = 2000000, time = 0
>> ...
>>
>> [  867.996243] smic_event - smic->smic_timeout = 2000000, time = 0
>> [  867.996250] smic_event - smic->smic_timeout = 2000000, time = 0
>> [  867.996256] smic_event - smic->smic_timeout = 2000000, time = 0
>> [...]
>> 
>> 
>> This goes on through megabytes.  The modprobe process didn't terminate
>> for 10 minutes, and there was some output like this (cleaned from
>> smic_events all around the place by hand):
>> 
>> INFO: task modprobe:6414 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> modprobe      D f6805780 0  6414   4077
>>  f48dfe68 00000082 00000000 f6805780
>>  f48dfe48 f90271cf c046acc0 f64f6a0c
>>  2002132c f6da1300 f6da14b4 c182acc0
>>  00000002 f64f6a0c 186f5ef2 000000ca
>>  f48dfe30 c0123c40 00000000 f64f69e0
>>  f48dfe30 00000282 00000001 c032456c
>> Call Trace:
>>  [<f90271cf>] ? i_ipmi_request+0x8f5/0x916 [ipmi_msghandler]
>>  [<c0123c40>] ? check_preempt_wakeup+0x146/0x180
>>  [<c01292c3>] ? try_to_wake_up+0x1f3/0x1fd
>>  [<c011c70a>] ? default_spin_lock_flags+0x8/0xe
>>  [<c031b81a>] schedule+0x8/0x17
>>  [<f9028745>] ipmi_register_smi+0x3ca/0xba1 [ipmi_msghandler]
>>  [<c028681c>] ? put_device+0xf/0x11
>>  [<c028782a>] ? device_add+0x497/0x516
>>  [<c013f2e7>] ? autoremove_wake_function+0x0/0x33
>>  [<fc2d939c>] try_smi_init+0x58f/0x726 [ipmi_si]
>>  [<fc2dc3e5>] init_ipmi_si+0x3e2/0x748 [ipmi_si]
>>  [<c010304f>] do_one_initcall+0x4a/0x115
>>  [<fc2dc003>] ? init_ipmi_si+0x0/0x748 [ipmi_si]
>>  [<c0142c0b>] ? __blocking_notifier_call_chain+0x40/0x4c
>>  [<c014ff97>] sys_init_module+0x87/0x18b
>>  [<c0107c94>] sysenter_do_call+0x12/0x28
>> 
>
> Well there have only been a handful of changes to ipmi since 2.6.29. 
> Could you try a mini-bisection?
>
> Apply revert-1.patch, test
> Apply revert-2.patch, test
> Apply revert-3.patch, test
> Apply revert-4.patch, test

After applying revert-1.patch, modprobe runs OK:

[   86.968156] IPMI System Interface driver.
[   86.976276] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
[   87.117630] ipmi: Found new BMC (man_id: 0x0002a2,  prod_id: 0x0000, dev_id: 0x00)
[   87.133078] IPMI smic interface initialized

I guess there's no point in trying the rest.

When loading with debug options, it still produces insane amount of
debug messages continuously (first 671 lines of it attached).
-- 
Regards,
Feri.


--=-=-=
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=revert1.log.gz
Content-Transfer-Encoding: base64

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
--=-=-=--
