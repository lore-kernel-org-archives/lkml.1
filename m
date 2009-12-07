Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZLGHpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZLGHpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758791AbZLGHpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:45:08 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:40897 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbZLGHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:45:07 -0500
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: When it is save to kfree() hrtimer object?
Date: Mon, 7 Dec 2009 10:45:08 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912071045.09827@blacky.localdomain>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm writing a device driver that processes it's requests.

Each request is described by a request structure. There may be arbitary 
number of requests pending, so I have a kmem_cache for those objects.

Request processing may include "retry after N usecs" on some conditions, so 
I have a struct htrimer embedded into my request structure, and use it to 
implement the delay.

When request processing is complete, I deallocate request structure with 
kmem_cache_free().

I faced an issue when request processing is complete when running inside 
hrtimer callback. I have nothing in my request processing that can't be 
done in atomic context - just several device register accesses and 
wake_up_interruptible() call. So I thought that I may do everything inside 
hrtimer callback. Including kmem_cache_free() the request structure.

But looks like I can't. Hrtimer code does access hrtimer object after 
return from callback, even if HRTIMER_NORESTART is returned. So if request 
object (that is container of hrtimer object in my case) is deallocated, 
slab corruption happens.

Looks like I will have to implement some ugly workaround for that ...  like 
a "garbage-collector" thread that will do nothing but deallocate requests 
from some sort of free list.

I'd like to ask several questions.

- Isn't it a bug that timer object is accessed after it's callback was 
called and returned HRTIMER_NORESTART?

- If that is not a bug, then when it is "officially safe" to deallocate 
struct hrtimer object?

- Are there any recommendations on how to implement "single-shot" timers 
like in my case?

Nikita
