Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZHQLUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZHQLUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZHQLUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:20:50 -0400
Received: from gon.proformatique.com ([91.194.178.5]:57132 "EHLO
	mx1.corp.proformatique.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757415AbZHQLUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:20:49 -0400
Message-ID: <ff6e70f67e2cc619513f8b61828c8dba.squirrel@mail.corp.proformatique.com>
In-Reply-To: <20090817091116.GD5868@cr0.nay.redhat.com>
References: <20090816222921.26c92ccd@xilun.lan.proformatique.com>
    <20090817091116.GD5868@cr0.nay.redhat.com>
Date: Mon, 17 Aug 2009 13:20:50 +0200 (CEST)
Subject: Re: [PATCH] poll/select: avoid arithmetic overflow in 
     __estimate_accuracy()
From: "Guillaume Knispel" <gknispel@proformatique.com>
To: "Amerigo Wang" <xiyou.wangcong@gmail.com>
Cc: "Guillaume Knispel" <gknispel@proformatique.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tejun Heo" <tj@kernel.org>
Reply-To: gknispel@proformatique.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Aug 16, 2009 at 10:29:21PM +0200, Guillaume Knispel wrote:
>>__estimate_accuracy() was prone to integer overflow, for example
>>if *tv == {2147, 483648000} on a 32 bit computer (or even for delays
>>as small as {429, 500000000} if the task is niced).
>>
>>Because the result was already forced between 0 and 100ms, the effect
>>of the overflow was not too problematic, but the use of the hrtimer
>>range feature was not optimal in overflow cases.
>>
>>This patch ensures that there can not be an integer overflow in this
>>function.
>>
>>Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
>>---
>> fs/select.c |   14 ++++++++++----
>> 1 files changed, 10 insertions(+), 4 deletions(-)
>>
>>diff --git a/fs/select.c b/fs/select.c
>>index 8084834..a201fc3 100644
>>--- a/fs/select.c
>>+++ b/fs/select.c
>>@@ -41,22 +41,28 @@
>>  * better solutions..
>>  */
>>
>>+#define MAX_SLACK	(100 * NSEC_PER_MSEC)
>>+
>> static long __estimate_accuracy(struct timespec *tv)
>> {
>> 	long slack;
>> 	int divfactor = 1000;
>>
>>+	if (tv->tv_sec < 0)
>>+		return 0;
>>+
>> 	if (task_nice(current) > 0)
>> 		divfactor = divfactor / 5;
>>
>>+	if (tv->tv_sec > MAX_SLACK / (NSEC_PER_SEC/divfactor))
>>+		return MAX_SLACK;
>>+
>
>
> Yes? Isn't MAX_SLACK also too big for 'long' on 32bit machine?
>
> Try:
>
> % printf "%d\n" "100*1000000000 > 0x7fffffff"
> 1
>
> Am I missing something here?

100 * NSEC_PER_MSEC  =>  100 * 1000000
               -

The exact same multiplication was already in the existing code,
and this is not the one that can overflow.


Cheers,
Guillaume Knispel

