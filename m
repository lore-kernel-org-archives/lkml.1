Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0BDDuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:50:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:48722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab0BDDuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:50:21 -0500
Message-ID: <4B6A4576.5050401@kernel.org>
Date: Thu, 04 Feb 2010 12:56:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: patch idr-fix-a-critical-misallocation-bug.patch added to 2.6.32-stable
 tree
References: <12651725962428@site> <1265203299.2919.1.camel@localhost> <20100203233720.GA28271@suse.de> <201002040446.05068.s.L-H@gmx.de>
In-Reply-To: <201002040446.05068.s.L-H@gmx.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 03:49:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 12:46 PM, Stefan Lippers-Hollmann wrote:
> Hi
> 
> [ Sorry for not reporting this earlier today, while 
>   idr-fix-a-critical-misallocation-bug was still part of queue-2.6.32, but 
>   bisecting this (and previously net-restore-ip-source-validation.patch) 
>   took its time. ]
> 
> On Thursday 04 February 2010, Greg KH wrote:
>> On Wed, Feb 03, 2010 at 08:21:39AM -0500, Eric Paris wrote:
>>> On Wed, 2010-02-03 at 14:21 +0900, Tejun Heo wrote:
>>>
>>>>> Eric Paris located a bug in idr.  With IDR_BITS of 6, it grows to three
>>>>> layers when id 4096 is first allocated.  When that happens, idr wraps
>>>>> incorrectly and searches the idr array ignoring the high bits.  The
>>>>> following test code from Eric demonstrates the bug nicely.
>>>> ...
>>>>> Based-on-patch-from: Eric Paris <eparis@redhat.com>
>>>>> Reported-by: Eric Paris <eparis@redhat.com>
>>>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>>
>>>> Greg, can this wait a bit more, maybe until the next -stable release?
>>>> The code there is very fragile and this has been broken forever so I
>>>> think it would be better if we wait a bit more while it gets testing
>>>> mainline.
> 
> Just as a side note, this patch as part of the 2.6.32 stable queue (before 
> this patch was removed again) seems to break logging into KDE 4.3.4 through
> kdm on several different systems with Intel chipsets/ graphics (kvm 
> active). X and kdm start normally, logging in shows the ksplash, which 
> quickly terminates the xsession and dumps back to kdm. Removing just this 
> patch from 2.6.32 + (previous) stable queue fixes the problem for me; 
> however 2.6.33-rc6-git3 seems to be affected as well, but freezes X, 
> instead of "just" terminating the current X session and reverting to kdm.
> 
> While I have reports from several different intel chipsets, I can 
> personally reproduce it on an Intel D945GCLF2 mainboard:

Does this patch make any difference?

diff --git a/lib/idr.c b/lib/idr.c
index ba7d37c..a96c604 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 	id = *starting_id;
  restart:
 	p = idp->top;
-	l = p->layer;
+	l = idp->layers;
+	pa[l--] = NULL;
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...


-- 
tejun
