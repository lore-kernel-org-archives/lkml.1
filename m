Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbZGHVkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbZGHVkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZGHVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:40:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40438 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbZGHVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=wbWtdMN/oKz0kFElMWLjhAzVBB9z93bMZ2SfiLOhqMzho5xQQhGJIjQRf9DxKvSbAw
         gYi5q8zBbUeT+jaKly9i1w/wzPmEe6JGY6eDhWkoiBwe/D3+4esK8hoob5jjro3AEYI4
         qLj82VDnj91/MFpAl8Ems84LN8gFJv9RpDQPA=
MIME-Version: 1.0
Date: Wed, 8 Jul 2009 22:33:31 +0100
X-Google-Sender-Auth: 19196195c0230848
Message-ID: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
Subject: Possible memory leak via alloc_pid()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a kmemleak report of a struct pid allocation in alloc_pid()
which somehow gets lost:

unreferenced object 0xc307aa00 (size 44):
  comm "gdm", pid 2734, jiffies 4294902040
  backtrace:
    [<c01e721a>] create_object+0xfa/0x250
    [<c01e73cd>] kmemleak_alloc+0x5d/0x70
    [<c01e0ad6>] kmem_cache_alloc+0x156/0x1a0
    [<c01552f9>] alloc_pid+0x19/0x350
    [<c013e6e0>] copy_process+0x800/0x1230
    [<c013f17f>] do_fork+0x6f/0x370
    [<c0101986>] sys_clone+0x36/0x40
    [<c010319c>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

This is the gdm fork for starting Xorg (with pid 2739). It first
logged me in automatically, after which I logged out and gdm started
another Xorg. The pid structure for the first Xorg is reported as a
leak. The Xorg with pid 2739 is no longer present on my system.

Using gdb vmlinux /proc/kcore shows that the pid->count is 2, so
that's why it probably wasn't freed by put_pid():

(gdb) print ({struct pid}0xc307aa00)
$20 = {count = {counter = 2}, level = 0, tasks = {{first = 0x0}, {
      first = 0x0}, {first = 0x0}}, rcu = {next = 0xc24bfd64,
    func = 0xc0154e90 <delayed_put_pid>}, numbers = {{nr = 2739,
      ns = 0xc0737540, pid_chain = {next = 0x0, pprev = 0x200200}}}}

Note that kmemleak is aware of and scans pid_hash (which was recorded
in kmemleak as a 16KB object).

Regards.

-- 
Catalin
