Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXDJTBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXDJTBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXDJTBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:01:17 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:58797 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXDJTBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:01:17 -0400
Message-ID: <461BDED4.8060606@us.ibm.com>
Date: Tue, 10 Apr 2007 15:00:36 -0400
From: Reiner Sailer <sailer@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Joseph Fannin <jhf@columbus.rr.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sailer@watson.ibm.com, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com
Subject: Re: 2.6.21-rc6-mm1 ima "BUG: held lock freed!"
References: <461B8A0F.2060007@us.ibm.com>
In-Reply-To: <461B8A0F.2060007@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------090000090807030105020500"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090000090807030105020500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Joseph,

we cannot reproduce the BUG you report. We have identified a potential 
source (spinlock around mutex_init). I have attached a small patch that 
removes this lock from the initialization of the hash table. I have 
tested the patch but I cannot verify if this resolves the problem you 
are seeing.

If you can reproduce the problem, would you mind to apply this patch and 
let us know if this solves the problem?

Thanks
Reiner

Reiner Sailer wrote:
>
> We are looking into this.
> Thanks!
> Reiner
>
> --forwarded by Reiner Sailer:
> On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
> >
> > 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/ 
>
> >
>    I'm seeing this while booting:
>
> ima (ima_init): No TPM chip found(rc = -19), activating TPM-bypass!
>
> =========================
> [ BUG: held lock freed! ]
> -------------------------
> swapper/1 is freeing memory c04c7660-c04c76a3, with a lock still held 
> there!
> (ima_queue_lock){--..}, at: [<c0202710>] ima_create_htable+0x10/0x90
> 1 lock held by swapper/1:
> #0:  (ima_queue_lock){--..}, at: [<c0202710>] ima_create_htable+0x10/0x90
>
> stack backtrace:
> [<c0105959>] dump_trace+0x1d9/0x210
> [<c01059aa>] show_trace_log_lvl+0x1a/0x30
> [<c0106612>] show_trace+0x12/0x20
> [<c01066d6>] dump_stack+0x16/0x20
> [<c014fd3a>] debug_check_no_locks_freed+0x17a/0x180
> [<c014cdbf>] debug_mutex_init+0x1f/0x50
> [<c0145451>] __mutex_init+0x41/0x50
> [<c020277d>] ima_create_htable+0x7d/0x90
> [<c020286f>] ima_init+0x3f/0x270
> [<c051b765>] init_evm+0x1f5/0x250
> [<c05015d2>] kernel_init+0x132/0x320
> [<c010532f>] kernel_thread_helper+0x7/0x18
> =======================
>
>    I saw this in -rc5-mm4 also.
>
>    I couldn't find a contact address in MAINTAINERS, so I've CC'd the
> two authors listed on top of ima_create_htable.c , as well as the
> first submitter of the IMA stuff I found in my LKML archive.
>
>    As an aside, this computer does have (some sort of) TPM chip, but
> the driver is built as a module, and not loaded at this point (not a
> worry for me, I don't intend to use it).
>
> -- 
> Joseph Fannin
> jfannin@gmail.com || jhf@columbus.rr.com
>



--------------090000090807030105020500
Content-Type: text/plain;
 name="ima-init-lock-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ima-init-lock-fix.patch"

---
 security/evm/ima/ima_queue.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.21-rc6/security/evm/ima/ima_queue.c
===================================================================
--- linux-2.6.21-rc6.orig/security/evm/ima/ima_queue.c
+++ linux-2.6.21-rc6/security/evm/ima/ima_queue.c
@@ -38,7 +38,6 @@ void ima_create_htable(void)
 {
 	int i;
 
-	spin_lock(&ima_queue_lock);
 	INIT_LIST_HEAD(&ima_measurements);
 	atomic_set(&ima_htable.len, 0);
 	atomic_set(&ima_htable.violations, 0);
@@ -50,7 +49,6 @@ void ima_create_htable(void)
 	}
 
 	mutex_init(&ima_extend_list_mutex);
-	spin_unlock(&ima_queue_lock);
 }
 
 struct ima_queue_entry *ima_lookup_digest_entry(u8 * digest_value)

--------------090000090807030105020500--

