Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbXAWPLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbXAWPLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932581AbXAWPLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:11:52 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:24179 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932584AbXAWPLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:11:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=04vhuYvhhID7CKC0EY6ml/kVeGP5ysB7mCUDYS4VPlgfqnVV9Hz6YAu+Qw1hFzDVhCLv1hA9tvzrQBjcHnQq1edLcAwNEiyGoQjAUvTUPOCutqi5QokxDL2RX9Tbb/XZCvRgLNqEzB+x/AWsyzXifz9W1MF98WhkuH3N1/ey2iI=  ;
X-YMail-OSG: HoyyF_MVM1lVDlf9g5Nqbk2QZBXl5qFcU5VspVltjnRDAqp75YRIOaapMr27tGILCCxrKghKnXGhW9J98pi23tk3rOhLmDjbjjukpRaHjwoIJTUO_p8-
Message-ID: <45B6258E.2060402@yahoo.com.au>
Date: Wed, 24 Jan 2007 02:11:10 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] notifiers: fix blocking_notifier_call_chain()	scalability
References: <20070123094550.GA21105@elte.hu> <1169551494.6197.209.camel@twins>
In-Reply-To: <1169551494.6197.209.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2007-01-23 at 10:45 +0100, Ingo Molnar wrote:

>>The fix is to enhance blocking_notifier_call_chain() to only take the 
>>lock if there appears to be work on the call-chain.
>>
>>With this patch applied i get nicely saturated system, and much higher 
>>munmap performance, on SMP systems.
>>
>>And as a bonus this also fixes a similar scalability bottleneck in the 
>>thread-exit codepath: profile_task_exit() ...
>>
>>Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
>>---
>> kernel/sys.c |   15 +++++++++++----
>> 1 file changed, 11 insertions(+), 4 deletions(-)
>>
>>Index: linux/kernel/sys.c
>>===================================================================
>>--- linux.orig/kernel/sys.c
>>+++ linux/kernel/sys.c
>>@@ -325,11 +325,18 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
>> int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
>> 		unsigned long val, void *v)
>> {
>>-	int ret;
>>+	int ret = NOTIFY_DONE;
>> 
>>-	down_read(&nh->rwsem);
>>-	ret = notifier_call_chain(&nh->head, val, v);
>>-	up_read(&nh->rwsem);
>>+	/*
>>+	 * We check the head outside the lock, but if this access is
>>+	 * racy then it does not matter what the result of the test
>>+	 * is, we re-check the list after having taken the lock anyway:
>>+	 */

Great idea!

>>+	if (rcu_dereference(nh->head)) {

Except rcu_dereference() is not needed.

>>+		down_read(&nh->rwsem);
>>+		ret = notifier_call_chain(&nh->head, val, v);
>>+		up_read(&nh->rwsem);
>>+	}
>> 	return ret;
>> }

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
