Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbZAWKGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbZAWKGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZAWKGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:06:11 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:58706 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbZAWKGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:06:09 -0500
Message-ID: <49799691.3070701@ribosome.natur.cuni.cz>
Date: Fri, 23 Jan 2009 11:06:09 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081227 SeaMonkey/1.1.14
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG #12515] 2.6.29-rc2-git1: possible circular locking #0: (sk_lock-AF_PACKET){--..},
 at: [<c1279838>] sock_setsockopt+0x12b/0x4a4
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I haven't received any answer on this bug report so I am re-trying
over the email list. Running tcpdump under heavy load/io I got this
stacktrace. Snippet from dmesg output follows:


device eth0 entered promiscuous mode

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc2-git1 #1
-------------------------------------------------------
tcpdump/3734 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<c1053294>] might_fault+0x30/0x6b

but task is already holding lock:
 (sk_lock-AF_PACKET){--..}, at: [<c12798c8>] sock_setsockopt+0x12b/0x4a4

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (sk_lock-AF_PACKET){--..}:
       [<c1033a0d>] add_lock_to_list+0x5e/0x8b
       [<c10365ae>] __lock_acquire+0xfb8/0x12e5
       [<c12cc63c>] packet_mmap+0x2e/0xf4
       [<c12cc63c>] packet_mmap+0x2e/0xf4
       [<c1036922>] lock_acquire+0x47/0x5e
       [<c12cc63c>] packet_mmap+0x2e/0xf4
       [<c1278548>] lock_sock_nested+0xac/0xb9
       [<c12cc63c>] packet_mmap+0x2e/0xf4
       [<c12cc63c>] packet_mmap+0x2e/0xf4
       [<c1034e94>] trace_hardirqs_on_caller+0x104/0x124
       [<c12759fa>] sock_mmap+0xc/0xe
       [<c10588f9>] mmap_region+0x27e/0x4b4
       [<c1058d1e>] do_mmap_pgoff+0x1ef/0x239
       [<c10057cf>] sys_mmap2+0x58/0x76
       [<c1002cd5>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c103507d>] print_circular_bug_entry+0x36/0x3d
       [<c10362d1>] __lock_acquire+0xcdb/0x12e5
       [<c1034cf3>] mark_held_locks+0x50/0x66
       [<c101ff01>] local_bh_enable+0x97/0x9a
       [<c1036922>] lock_acquire+0x47/0x5e
       [<c1053294>] might_fault+0x30/0x6b
       [<c10532b1>] might_fault+0x4d/0x6b
       [<c1053294>] might_fault+0x30/0x6b
       [<c1137907>] copy_from_user+0x27/0x10e
       [<c1279bcb>] sock_setsockopt+0x42e/0x4a4
       [<c10532b4>] might_fault+0x50/0x6b
       [<c127636a>] sys_setsockopt+0x4c/0x7d
       [<c1277957>] sys_socketcall+0x135/0x18c
       [<c1002cd5>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by tcpdump/3734:
 #0:  (sk_lock-AF_PACKET){--..}, at: [<c12798c8>] sock_setsockopt+0x12b/0x4a4

stack backtrace:
Pid: 3734, comm: tcpdump Not tainted 2.6.29-rc2-git1 #1
Call Trace:
 [<c10352c1>] print_circular_bug_tail+0xa5/0xaf
 [<c103507d>] print_circular_bug_entry+0x36/0x3d
 [<c10362d1>] __lock_acquire+0xcdb/0x12e5
 [<c1034cf3>] mark_held_locks+0x50/0x66
 [<c101ff01>] local_bh_enable+0x97/0x9a
 [<c1036922>] lock_acquire+0x47/0x5e
 [<c1053294>] might_fault+0x30/0x6b
 [<c10532b1>] might_fault+0x4d/0x6b
 [<c1053294>] might_fault+0x30/0x6b
 [<c1137907>] copy_from_user+0x27/0x10e
 [<c1279bcb>] sock_setsockopt+0x42e/0x4a4
 [<c10532b4>] might_fault+0x50/0x6b
 [<c127636a>] sys_setsockopt+0x4c/0x7d
 [<c1277957>] sys_socketcall+0x135/0x18c
 [<c1002cd5>] sysenter_do_call+0x12/0x35
device eth0 left promiscuous mode


More details are at http://bugzilla.kernel.org/show_bug.cgi?id=12515
Please Cc: me in replies. Thanks.
Martin
