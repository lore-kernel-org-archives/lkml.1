Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbZBXVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbZBXVD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZBXVDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:03:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:55583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZBXVDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:03:50 -0500
Message-ID: <49A46081.9080008@kernel.org>
Date: Tue, 24 Feb 2009 13:02:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu>
In-Reply-To: <20090224205105.GA19460@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git 
>>>   tj-percpu
>> ok, i pulled it into tip:core/percpu (one conflict resolution 
>> done - please double check it), and exposed it to -tip testing 
>> briefly.
>>
>> Six x86 test-systems failed ;-) One of them had this panic:
>>
>> Scan SMP from ffff880000000000 for 1024 bytes.
>> Scan SMP from ffff88000009fc00 for 1024 bytes.
>> Scan SMP from ffff8800000f0000 for 65536 bytes.
>> found SMP MP-table at [ffff8800000fe680] fe680
>> PANIC: early exception 0  rip   :                 error   cr2       
>> PANIC: early exception 0  rip   :                 error   cr2   
> 
> Ah, spoke too soon. Bisection gave this commit from Yinghai:
> 
> dc07da5: x86: check range in reserve_early()
> 

arh...

should be

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index e858268..b114499 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -858,6 +858,9 @@ void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
  */
 void __init reserve_early(u64 start, u64 end, char *name)
 {
+	if (start >= end)
+		return;
+
 	drop_overlaps_that_are_ok(start, end);
 	__reserve_early(start, end, name, 0);
 }




