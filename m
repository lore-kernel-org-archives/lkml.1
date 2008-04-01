Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbYDAVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbYDAVNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762231AbYDAVIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:08:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:8107 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762223AbYDAVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gNuLqYEeh6jrV/lgh4y26OhkbMB9LVe+MEdIdCXUH2K+yN+0s+5JIWtQgyah0z9eQml2JO4B6ZrA2W3WL8gTuGWAa48EHC/1+n4wN+cQaxyzZ3UQUSbpMW+AO3qPGFAHO0D+3oaIAfCh4vRzUTqG8qp2AKLsntJeFbVUTFGOXcY=
Message-ID: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
Date: Tue, 1 Apr 2008 23:08:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jens Axboe" <axboe@kernel.dk>
Subject: kmemcheck caught read from freed memory (cfq_free_io_context)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This appeared in my logs:

 kmemcheck: Caught 32-bit read from freed memory (f7042348)

 Pid: 1374, comm: bash Not tainted (2.6.25-rc7 #92)
 EIP: 0060:[<c0502f0d>] EFLAGS: 00210202 CPU: 0
 EIP is at call_for_each_cic+0x2d/0x44
 EAX: 00200286 EBX: 00000001 ECX: c200e908 EDX: f7042348
 ESI: f6c26c60 EDI: c0503310 EBP: f70fff38 ESP: c082ec88
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 CR0: 8005003b CR2: f7826904 CR3: 36cd7000 CR4: 000006c0
 DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
 DR6: ffff4ff0 DR7: 00000400
  [<c041cff8>] kmemcheck_read+0xa8/0xe0
  [<c041d1d5>] kmemcheck_access+0x1a5/0x244
  [<c0668252>] do_page_fault+0x622/0x6fc
  [<c06666aa>] error_code+0x72/0x78
  [<c050323f>] cfq_free_io_context+0xf/0x70
  [<c04fc4d7>] put_io_context+0x4f/0x58
  [<c04fc568>] exit_io_context+0x60/0x6c
  [<c042f871>] do_exit+0x4d9/0x6f0
  [<c042fab1>] do_group_exit+0x29/0x88
  [<c042fb1f>] sys_exit_group+0xf/0x14
  [<c0406105>] sysenter_past_esp+0x6d/0xa4
  [<ffffffff>] 0xffffffff

The error occurs in cfq_free_io_context()'s call to
call_for_each_cic() which looks like this:

        rcu_read_lock();
        hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list) {
                func(ioc, cic);
                called++;
        }
        rcu_read_unlock();

The function that is called is cic_free_func(). It is postulated that
hlist_for_each_entry_rcu() will dereference the previously freed list
element to get the ->next pointer.

After a short discussion with Pekka Enberg and Peter Zijlstra, it
seemed evident that this list traversal should use
hlist_for_each_entry_safe_rcu() instead, which would buffer the next
pointer before the object is freed.

Does this report seem to be valid?

The kernel is 2.6.25-rc7.


Kind regards,
Vegard Nossum
