Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbYDVQoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbYDVQoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYDVQoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:44:14 -0400
Received: from sandeen.net ([209.173.210.139]:31023 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYDVQoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:44:13 -0400
Message-ID: <480E15DC.5040301@sandeen.net>
Date: Tue, 22 Apr 2008 11:44:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Sandeen <sandeen@redhat.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] use canary at end of stack to indicate overruns at	oops
 time
References: <480D5F27.1030101@redhat.com> <20080422084404.GA2388@elte.hu>
In-Reply-To: <20080422084404.GA2388@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Eric Sandeen <sandeen@redhat.com> wrote:

>> With the code in place, an intentionally-bloated stack oops does:
>>
>> BUG: unable to handle kernel paging request at ffff8103f84cc680
>> IP: [<ffffffff810253df>] update_curr+0x9a/0xa8
>> PGD 8063 PUD 0 
>> Thread overran stack or stack corrupted
>> Oops: 0000 [1] SMP 
>> CPU 0 
>> ...
> 
> excellent. I've queued this up, it's definitely an improvement in 
> debuggability.

Crud, just realized this probably doesn't play well with
CONFIG_DEBUG_STACK_USAGE.  I think it will need something like:

Index: linux-2.6.25-rc7/kernel/exit.c
===================================================================
--- linux-2.6.25-rc7.orig/kernel/exit.c	2008-04-20 22:34:16.000000000 -0500
+++ linux-2.6.25-rc7/kernel/exit.c	2008-04-22 11:38:05.769412824 -0500
@@ -826,6 +826,8 @@ static void check_stack_usage(void)
 	unsigned long *n = end_of_stack(current);
 	unsigned long free;

+	n++;	/* skip over canary at end */
+
 	while (*n == 0)
 		n++;
 	free = (unsigned long)n - (unsigned long)end_of_stack(current);


Testing now... want me to resend the whole patch, Ingo, or you want to
just fix it up?  (I'll follow up with the testing results)

Thanks,
-Eric
