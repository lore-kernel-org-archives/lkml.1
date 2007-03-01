Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbXCAMUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbXCAMUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXCAMUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:20:40 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:50898 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089AbXCAMUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:20:39 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 07:20:39 EST
From: Frank Seidel <linux@f-seidel.de>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2 and 2.6.20)
Date: Thu, 1 Mar 2007 13:08:27 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com>
In-Reply-To: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011308.28266.linux@f-seidel.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 28. Februar 2007 19:02 schrieb Dan Williams:
> I can reliably reproduce a null pointer dereference on 2.6.20 and
> 2.6.21-rc2.  I will keep digging to find the kernel version where
> this last worked, but wanted to see if there were any immediate
> experiments I should try.
> ...
> Kernel 2.6.21-rc2 on an i686
> ...
> [  431.709022] BUG: unable to handle kernel NULL pointer dereference
> at virtual address 0000005c [  431.717993]  printing eip:
> ...
> [  431.825386] EIP is at cfq_dispatch_insert+0xb/0x53
> ...
> [  431.887396]  [<c01e1fc9>] cfq_dispatch_requests+0x138/0x3f0
Hi,
unfortunately i yet don't really have much/enough knowledge of cfq and 
the kernels inwards at the moment...
but looking at cfq_dispatch_insert+0xb it seems the struct request 
pointer given (as second parameter by cfq_dispatch_request) was NULL 
and dereferencing it in the RQ_CFQQ macro leads to this oops.

The "break"-out patch below for __cfq_dispatch_request might be at least 
a possible workaround for this, but it could also be total bullsh.. 
Perhaps someone smarter might pick this up.. and give a real fix.

Have fun,
Frank
---

 block/cfq-iosched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -962,7 +962,8 @@ __cfq_dispatch_requests(struct cfq_data
                 * follow expired path, else get first next available
                 */
                if ((rq = cfq_check_fifo(cfqq)) == NULL)
-                       rq = cfqq->next_rq;
+                       if ((rq = cfqq->next_rq) == NULL)
+                               break;

                /*
                 * finally, insert request into driver dispatch list
