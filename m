Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZFAGtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZFAGtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZFAGtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:49:08 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:54662 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZFAGtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eOVMqfQHrRoGWnRL2HSUBk/C7eGxQdU9kzcYXTj0Hi/Rpskl5+VVEsZ4WO6TAseTII
         Ny2WDtyYuxY66eQUYVpEJgHk6cQN4qWddPFiNoropYgHSoHqGBt/Wf2fm0nlGFP3eMhb
         SP8BC89hl05JxdLBzouEqzPFn33SWuDN6u6UI=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 14:49:09 +0800
Message-ID: <d364733c0905312349m6b5c8664h6cc7701a576c6b7d@mail.gmail.com>
Subject: new implementation of mutex
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is new implementaion in newer kernel (my kernel version is
2.6.27). Compared to the old implementaion which uses binary
semaphore, there are some new features:
 - 'struct mutex' semantics are well-defined and are enforced if
   CONFIG_DEBUG_MUTEXES is turned on. Semaphores on the other hand have
   virtually no debugging code or instrumentation. The mutex subsystem
   checks and enforces the following rules:

   * - only one task can hold the mutex at a time
   * - only the owner can unlock the mutex
   * - multiple unlocks are not permitted
   * - recursive locking is not permitted
   * - a mutex object must be initialized via the API
   * - a mutex object must not be initialized via memset or copying
   * - task may not exit with mutex held
   * - memory areas where held locks reside must not be freed
   * - held mutexes must not be reinitialized
   * - mutexes may not be used in hardware or software interrupt
   *   contexts such as tasklets and timers

But in my test, I try to lock mutex in one thread, and unlock it in
the other thread. There is nothing wrong happens. It works just like
semaphore. I have had CONFIG_DEBUG_MUTEXES turned on.
The two threads are mostly like this:
struct mutex mutex;

static int mysthread1(void * data){
  int i;
  i= 5;
  while(i -- > 0){
                mutex_lock(&mutex);
    printk("this is thread1\n");
    msleep(5000);
  }
        return 0;
}

static int mysthread2(void * data){
  int i;
  i= 5;
  while(i -- > 0){
    printk("this is thread2\n");
    msleep(5000);
                mutex_lock(&mutex);
  }
        return 0;
}

I debug it and find the debug_locks = 0.  Is this why there is no
warning message and how turn it on? (I also had CONFIG_LOCKDEP_SUPPORT
on.)


-- 
Xie Gang
