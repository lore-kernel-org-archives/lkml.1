Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYJMVP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYJMVP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbYJMVPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:15:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbYJMVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:15:09 -0400
Message-ID: <48F3BA28.2010605@zytor.com>
Date: Mon, 13 Oct 2008 14:14:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, jbarnes@virtuousgeek.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>	 <20080904190457.GB24990@elte.hu>	 <20080904121627.bc182da7.akpm@linux-foundation.org>	 <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com> <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
In-Reply-To: <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060904060105010205010101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060904060105010205010101
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Tony Luck wrote:
> On Thu, Sep 4, 2008 at 12:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Thu, Sep 4, 2008 at 12:16 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Thu, 4 Sep 2008 21:04:57 +0200
>>> Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>> +             printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
>>>> +                      conflict->name, conflict->start, conflict->end,
>>>> +                      name, start, end);
>>> start and end have type resource_size_t.  Such types CANNOT be printed
>>> unless cast to a known type.
>>>
>>> Because there is a %s following an incorrect %lld, the above code will
>>> crash the machine.
>> should just remove those lines.
> 
> This didn't happen.  These lines are still in the version that went into
> Linus' tree over the weekend for 2.6.28.  On the ia64 build they spit
> out a bunch of warnings:
> 
> kernel/resource.c:554: warning: format '%llx' expects type 'long long
> unsigned int', but argument 3 has type 'resource_size_t'
> 
> Ditto for args 4, 6 and 7 on the same line.
> 

Here is a fix... currently running standard tests on it.

	-hpa


--------------060904060105010205010101
Content-Type: text/x-patch;
 name="0001-resource-fix-printk-of-resource_size_t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-resource-fix-printk-of-resource_size_t.patch"

>From 2d7c0377c3c98d2605704e67e64d1d19aa30ced3 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Mon, 13 Oct 2008 14:11:03 -0700
Subject: [PATCH] resource: fix printk() of resource_size_t

Impact: crash on 32-bit platforms, warnings on 64-bit platforms

When printk'ing resource_size_t, we have to explicitly cast them to
unsigned long long in order to be safe on all platforms.  We must not use
%z since that applies to size_t, which is frequently not the same type
as resource_size_t.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/resource.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..f747fb6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -550,8 +550,12 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 	if (!res) {
 		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-			 conflict->name, conflict->start, conflict->end,
-			 name, start, end);
+		       conflict->name,
+		       (unsigned long long)conflict->start,
+		       (unsigned long long)conflict->end,
+		       name,
+		       (unsigned long long)start,
+		       (unsigned long long)end);
 
 		/* failed, split and try again */
 
-- 
1.6.0.2


--------------060904060105010205010101--
