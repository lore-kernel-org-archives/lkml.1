Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYJGWZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYJGWZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYJGWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:24:56 -0400
Received: from sjc-gw1.datadomain.com ([208.84.140.10]:19145 "EHLO
	sjciron01.datadomain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYJGWY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:24:56 -0400
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="4076909"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Re: mlock() return value issue in kernel 2.6.23.17
Date: Tue, 7 Oct 2008 15:24:54 -0700
Message-ID: <7FF8E1C68090A144B921AFD6A6736A7303FC3879@sjcex01.DataDomain.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: mlock() return value issue in kernel 2.6.23.17
Thread-Index: Ackoy4X7WIYnXiOMTcO6kx/PSkbd5g==
From: "Yanping Du" <Yanping.Du@datadomain.com>
To: <linux-kernel@vger.kernel.org>
Cc: <yanping.du@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,

  Seems SUSv3 has more requirements beyond errno return code. Upon
failure (EAGAIN, etc), it requires .no change is made to any locks in
the address space of the process., but Linux mlock(2) will set vma flag
as VM_LOCKED even if make_pages_present() fails for some pages in the
vma. Any comment on this ?

SUSv3: http://www.unix.org/single_unix_specification/

"Upon successful completion, the mlock() and munlock() functions shall
return a value of zero. Otherwise, no change is made to any locks in the
address space of the process, and the function shall return a value of
-1 and set errno to indicate the error."


Thanks!

-Yanping


Re: mlock() return value issue in kernel 2.6.23.17

From: KOSAKI Motohiro
Date: Thu Jul 31 2008 - 08:50:41 EST

Next message: w.landgraf: "ref: my kernel bug report of July 29 ref
2.6.27-rc1 -- addition: kernel config"
Previous message: Alistair John Strachan: "Re: Oops in microcode sysfs
registration,"
In reply to: Halesh: "mlock() return value issue in kernel 2.6.23.17"
Next in thread: Andrew Morton: "Re: mlock() return value issue in kernel
2.6.23.17"
Messages sorted by: [ date ] [ thread ] [ subject ] [ author ]
size=2 width="100%" noshade color="#aca899" align=center>
>
> This testcase results with mlock failure with errno 14 that is EFAULT,

> but this has been no where reported that mlock will give EFAULT, When 
> i tested the same on older kernel like 2.6.18, I got the correct
result i.e errno 12 (ENOMEM).
>
>
> I think in source code mlock(2), setting errno ENOMEM has been missed 
> in
> do_mlock() , on mlock_fixup() failure.
>
> Let me know if my understanding is wrong!

Hi Halesh,

Could you try to following patch?

-----------------------------------------------------
SUSv3 require following behavior to mlock(2).

[ENOMEM]
Some or all of the address range specified by the addr and len arguments
does not correspond to valid mapped pages in the address space of the
process.

[EAGAIN]
Some or all of the memory identified by the operation could not be
locked when the call was made.


This rule isn't so nice and slighly strange.
but many people think POSIX/SUS compliance is important.


---
mm/memory.c | 16 +++++++++++++---
mm/mlock.c | 2 --
2 files changed, 13 insertions(+), 5 deletions(-)

Index: b/mm/memory.c
===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2736,16 +2736,26 @@ int make_pages_present(unsigned long add

vma = find_vma(current->mm, addr);
if (!vma)
- return -1;
+ return -ENOMEM;
write = (vma->vm_flags & VM_WRITE) != 0; BUG_ON(addr >= end); BUG_ON(end
> vma->vm_end); len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE; ret
= get_user_pages(current, current->mm, addr, len, write, 0, NULL, NULL);
- if (ret < 0)
+ if (ret < 0) {
+ /*
+ SUS require strange return value to mlock
+ - invalid addr generate to ENOMEM.
+ - out of memory should generate EAGAIN.
+ */
+ if (ret == -EFAULT)
+ ret = -ENOMEM;
+ else if (ret == -ENOMEM)
+ ret = -EAGAIN;
return ret;
- return ret == len ? 0 : -1;
+ }
+ return ret == len ? 0 : -ENOMEM;
}

#if !defined(__HAVE_ARCH_GATE_AREA)
Index: b/mm/mlock.c
===================================================================
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -78,8 +78,6 @@ success:

mm->locked_vm -= pages;
out:
- if (ret == -ENOMEM)
- ret = -EAGAIN;
return ret;
}

