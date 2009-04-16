Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZDPBse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZDPBse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZDPBsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:48:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53475 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZDPBsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:48:24 -0400
Message-ID: <49E68E63.6080202@garzik.org>
Date: Wed, 15 Apr 2009 21:48:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Re: How to completely disable async fastboot?
References: <49E679D0.7050600@garzik.org> <20090415183137.4d19a7c8@infradead.org>
In-Reply-To: <20090415183137.4d19a7c8@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------080901070108020207070803"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080901070108020207070803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> On Wed, 15 Apr 2009 20:20:32 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> The following commit
>>
>>> commit 9710794383ee5008d67f1a6613a4717bf6de47bc
>>> Author: Arjan van de Ven <arjan@linux.intel.com>
>>> Date:   Sun Mar 15 11:11:44 2009 -0700
>>>
>>>     async: remove the temporary (2.6.29) "async is off by default"
>>> code
>> not only changes a default, it completely removes the ability to turn 
>> off async AFAICS.
> 
> this is on the request of Andrew and others who want to be able to use
> these API's (soon) in an "forced offload" scenario. 
> 
>> At present, I need to turn this off to debug boot-time operation.
> 
> can you give some details? Maybe I can help suggest things...

Too much shit is occurring in parallel, which completely obscures the 
operation of the driver I am currently debugging.  A new and unwelcome 
behavior, as it is directly impacting workflow.

Commit 9710794383ee5008d67f1a6613a4717bf6de47bc was fine for the normal 
case, but please have pity on developers!  Just like many multi-threaded 
userland programs have an option to run single-threaded (usually for 
debug purposes), the kernel should have this too.

I need a slowboot option, like the attached patch.

The patch is basically the reverse of your 
9710794383ee5008d67f1a6613a4717bf6de47bc in a different way.

	Jeff




--------------080901070108020207070803
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/kernel/async.c b/kernel/async.c
index 968ef94..8c553ce 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -68,6 +68,7 @@ static LIST_HEAD(async_running);
 static DEFINE_SPINLOCK(async_lock);
 
 static int async_enabled = 0;
+static int async_disabled;
 
 struct async_entry {
 	struct list_head list;
@@ -388,6 +389,11 @@ static int async_manager_thread(void *unused)
 
 static int __init async_init(void)
 {
+	if (async_disabled) {
+		async_enabled = 0;
+		return 0;
+	}
+
 	async_enabled =
 		!IS_ERR(kthread_run(async_manager_thread, NULL, "async/mgr"));
 
@@ -395,4 +401,12 @@ static int __init async_init(void)
 	return 0;
 }
 
+static int __init setup_async(char *str)
+{
+	async_disabled = 1;
+	return 1;
+}
+
+__setup("slowboot", setup_async);
+
 core_initcall(async_init);

--------------080901070108020207070803--
