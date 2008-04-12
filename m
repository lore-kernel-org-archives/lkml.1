Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbYDLKsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbYDLKsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbYDLKrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:47:52 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46618 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbYDLKrv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:47:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm2 - ftraced chews 100% of a CPU
In-Reply-To: Your message of "Thu, 10 Apr 2008 20:33:54 PDT."
             <20080410203354.f0a6f464.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207997255_3652P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Apr 2008 06:47:35 -0400
Message-ID: <10757.1207997255@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207997255_3652P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 Apr 2008 20:33:54 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/

(Man, everything I look at tonight falls over.. I'm jinxed :)

So I built a kernel with:

% zgrep FTRACE /proc/config.gz 
CONFIG_HAVE_FTRACE=y
CONFIG_FTRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y

It ran pretty much OK for about 12 minutes, and then gkrellm reported tons of
system time, and 'top' confirms it:

top - 06:27:28 up 25 min,  3 users,  load average: 1.21, 1.20, 1.02
Tasks: 132 total,   3 running, 128 sleeping,   0 stopped,   1 zombie
Cpu(s):  0.7%us, 50.7%sy,  0.0%ni, 48.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2054764k total,   773648k used,  1281116k free,    32008k buffers
Swap:  2031608k total,        0k used,  2031608k free,   425696k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                      
   17 root      15  -5     0    0    0 R 99.8  0.0  13:04.53 ftraced                                                       
 2717 root      20   0  169m  60m  11m S  2.0  3.0   1:14.71 X           

And the CPUs are sitting at around 58C, which is their usual temp when
running flat-out, so there's actual looping happening.

I see this in the dmesg from right around when it went belly-up:

[  725.345544] hm, dftrace overflow: 127 changes (0 total) in 273 usecs
[  725.345562] ------------[ cut here ]------------
[  725.345568] WARNING: at kernel/trace/ftrace.c:658 ftraced+0x138/0x1f0()

(no I have no idea what the system was doing at that instant)

and 'echo t > /proc/sysrq-trigger' tells us:

[ 2368.256762] ftraced       R  running task     5952    17      2
[ 2368.256769]  ffff81000101b940 000000010101f800 ffff81007f957d10 ffffffff802302c9
[ 2368.256777]  ffff81007f954480 0000000000000000 00000000ab636be3 ffffffff805e35ec
[ 2368.256784]  ffff81007f957d50 ffffffff80213b72 0000000000000246 ffffffff8022ea19
[ 2368.256791] Call Trace:
[ 2368.256796]  [<ffffffff805e0632>] ? schedule+0x3e/0x6a9
[ 2368.256801]  [<ffffffff80230be3>] ? pick_next_task_fair+0xa0/0xc2
[ 2368.256806]  [<ffffffff8028d690>] ? trace_preempt_on+0x1c/0x32
[ 2368.256811]  [<ffffffff805e6469>] ? sub_preempt_count+0x49/0x73
[ 2368.256817]  [<ffffffff805e35ec>] ? _spin_lock_irqsave+0x35/0x69
[ 2368.256826]  [<ffffffff8024afed>] ? __mod_timer+0xce/0xf4
[ 2368.256830]  [<ffffffff8024ad0a>] ? del_timer_sync+0x28/0x4d
[ 2368.256836]  [<ffffffff805e1152>] ? schedule_timeout+0xac/0xdc
[ 2368.256840]  [<ffffffff8024a74b>] ? process_timeout+0x0/0x37
[ 2368.256844]  [<ffffffff8024af4f>] ? __mod_timer+0x30/0xf4
[ 2368.256851]  [<ffffffff80286ef0>] ? ftraced+0x52/0x1f0
[ 2368.256855]  [<ffffffff80257bbf>] ? kthread+0x0/0xa4
[ 2368.256859]  [<ffffffff80286e9e>] ? ftraced+0x0/0x1f0
[ 2368.256863]  [<ffffffff80257c20>] ? kthread+0x61/0xa4
[ 2368.256868]  [<ffffffff8020d7f8>] ? child_rip+0xa/0x12
[ 2368.256873]  [<ffffffff8020cee0>] ? restore_args+0x0/0x30
[ 2368.256878]  [<ffffffff80257bbf>] ? kthread+0x0/0xa4
[ 2368.256882]  [<ffffffff8020d7ee>] ? child_rip+0x0/0x12

Hopefully this tells you something?

--==_Exmh_1207997255_3652P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIAJNHcC3lWbTT17ARAgbJAKDZ9dRHhDBh2Qv+xTtzllIeGn/1MwCfcgKq
wvCcxyt5f1U8S1pVnDK3HNE=
=T/1h
-----END PGP SIGNATURE-----

--==_Exmh_1207997255_3652P--
