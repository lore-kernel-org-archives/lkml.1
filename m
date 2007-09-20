Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbXITACB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbXITACB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXITABy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:01:54 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:57634 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXITABx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:01:53 -0400
Message-ID: <46F1B872.1050307@ct.jp.nec.com>
Date: Wed, 19 Sep 2007 17:01:54 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix to use invalid sched_class
References: <1190239539.19576.5.camel@earth>
In-Reply-To: <1190239539.19576.5.camel@earth>
Content-Type: multipart/mixed;
 boundary="------------070508060703040505020102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070508060703040505020102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dmitry Adamushko wrote:
>>> Hi Ingo,
>>>
>>> I found an issue about the scheduler.
>>> If you need a test case, please let me know.
>>> Here is a patch.
>>> [ ... ]
>>> The new thread should be valid scheduler class before queuing.
>>> This patch fixes to set the suitable scheduler class.
>> Nice fix! It's a 2.6.23 must-have fix - i'll push it out into the 
>> scheduler tree. Thanks!
> 
> I think, the following approach would be a bit more appropriate
> (the missing addition to the already existing "don't leak PI boosting prio"):
> 
> (not tested)
> 
Thank you for reviewing my patch.
Yes, your approach looks better than mine.
I've tested it and it looks working fine in my test case.
I attached the test case.

Will you write a patch to replace mine?

Thanks,
Hiroshi Shimamoto

--------------070508060703040505020102
Content-Type: image/x-xbitmap;
 name="mutexprio.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mutexprio.c"

#define _GNU_SOURCE
#include <pthread.h>

pthread_mutex_t mtx;

void* th(void* p)
{
  pthread_mutex_lock(&mtx);
  pthread_mutex_unlock(&mtx);
  return NULL;
}

int main(int argc, char** argv)
{
  pthread_t tid1, tid2;
  pthread_attr_t attr;
  pthread_mutexattr_t mtxattr;
  struct sched_param sp;

  pthread_mutexattr_init(&mtxattr);
  pthread_mutexattr_setprotocol(&mtxattr, PTHREAD_PRIO_INHERIT);

  pthread_mutex_init(&mtx, &mtxattr);

  pthread_attr_init(&attr);
  pthread_attr_setschedpolicy(&attr, SCHED_RR);
  sp.sched_priority = 10;
  pthread_attr_setschedparam(&attr, &sp);
  pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);

  pthread_mutex_lock(&mtx);

  pthread_create(&tid1, &attr, th, NULL);
  pthread_create(&tid2, &attr, th, NULL);

  /* GO threads */
  pthread_mutex_unlock(&mtx);

  pthread_join(tid1, NULL);
  pthread_join(tid2, NULL);

  return 0;
}

--------------070508060703040505020102--
