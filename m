Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbXIUQSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbXIUQSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbXIUQSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:18:08 -0400
Received: from web52010.mail.re2.yahoo.com ([206.190.48.26]:38992 "HELO
	web52010.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755538AbXIUQSH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:18:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=i3BCzI0RrwK3jM1rO0VXdujW6rKO9aXm0Z863mRZp8ob35SVwyef9icQN94KtaXvjXksSDey5mx2Y+6EcmDxryWuwzfS7xnCcyp+NQ7C9lnmlqgPG2a+9eN3bnSFWGgcaaIhIDwuNZFi8qckF9u6jKthZTckkkSavPK07Uk+WOQ=;
X-YMail-OSG: MxNZmv4VM1lLWvMbfmJekIwkiKEEp2XQupPPMwoyXg2UL7w7Sdcimu1qemT89zbcJAYuljNLEdmzdlxUFIqT4mP8EcUHDc0vN_xd18zVi5TcPkr_byY-
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Fri, 21 Sep 2007 09:18:04 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] atomic_ops.txt has incorrect, misleading and insufficient information [Bug 9020]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <664379.20271.qm@web52010.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

atomic_ops.txt has incorrect, misleading and insufficient
information about semantics of initializer, atomic_set, atomic_read and
atomic_xchg. 
It also incorrectly implies that operations mentioned above are not actual
atomic operations.
Included is most of the patch Document non-semantics of atomic_read() and
atomic_set() by Chris Snook, 
except the word "assignment".

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

--- linux-2.6.23-rc6/Documentation-atomic_ops.txt    2007-09-14
23:49:20.126251500 +0300
+++ linux-2.6.23/Documentation-atomic_ops.txt    2007-09-15 09:56:16.136312500
+0300
@@ -12,7 +12,11 @@ Also, it should be made opaque such that
 C integer type will fail.  Something like the following should
 suffice:

-    typedef struct { volatile int counter; } atomic_t;
+    typedef struct { int counter; } atomic_t;
+
+    Historically, counter has been declared volatile.  This is now
+discouraged.  See Documentation/volatile-considered-harmful.txt for the
+complete rationale.

     The first operations to implement for atomic_t's are the
 initializers and plain reads.
@@ -24,6 +28,13 @@ The first macro is used in definitions, 

 static atomic_t my_counter = ATOMIC_INIT(1);

+The initializer is atomic in that the return values of the atomic
+operations are guaranteed to be correct reflecting the initialized
+value if the initializer is used before runtime. If the initializer
+is used at runtime, a proper implicit or explicit read memory barrier
+is needed before reading the value with atomic_read from another
+thread.
+
 The second interface can be used at runtime, as in:

     struct foo { atomic_t counter; };
@@ -36,13 +47,45 @@ The second interface can be used at runt
         return -ENOMEM;
     atomic_set(&k->counter, 0);

+The setting is atomic in that the return values of the atomic
+operations by all threads are guaranteed to be correct reflecting
+either the value that has been set with this operation or set with
+another operation. A proper implicit or explicit memory barrier is
+needed before the value set with the operation is guaranteed to be
+readable with atomic_read from another thread.
+
 Next, we have:

     #define atomic_read(v)    ((v)->counter)

-which simply reads the current value of the counter.
+which simply reads the counter value currently visible to the calling
+thread. The read is atomic in that the return value is guaranteed to
+be one of the values initialized or modified with the interface
+operations if a proper implicit or explicit memory barrier is used
+after possible runtime initialization by any other thread and the
+value is modified only with the interface operations. atomic_read
+does not guarantee that the runtime initialization by any other
+thread is visible yet, so the user of the interface must take care of
+that with a proper implicit or explicit memory barrier.
+
+*** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***
+
+Some architectures may choose to use the volatile keyword, barriers, or
+inline assembly to guarantee some degree of immediacy for atomic_read()
+and atomic_set().  This is not uniformly guaranteed, and may change in
+the future, so all users of atomic_t should treat atomic_read() and
+atomic_set() as simple C statements that may be reordered or
+optimized away entirely by the compiler or processor, and explicitly
+invoke the appropriate compiler and/or memory barrier for each use case.
+Failure to do so will result in code that may suddenly break when used with
+different architectures or compiler optimizations, or even changes in
+unrelated code which changes how the compiler optimizes the section
+accessing atomic_t variables.

-Now, we move onto the actual atomic operation interfaces.
+*** YOU HAVE BEEN WARNED! ***
+
+Now, we move onto the atomic operation interfaces typically
+implemented with the help of assembly code.

     void atomic_add(int i, atomic_t *v);
     void atomic_sub(int i, atomic_t *v);
@@ -117,6 +160,12 @@ operation.

 Then:

+      int atomic_xchg(atomic_t *v, int new);
+
+This performs an atomic exchange operation on the atomic variable v,
+setting the given new value. It returns the old value that the atomic
+variable v had just before the operation.
+
     int atomic_cmpxchg(atomic_t *v, int old, int new);

 This performs an atomic compare exchange operation on the atomic value v,



      Wissenswertes zum Thema PC, Zubehör oder Programme. BE A BETTER INTERNET-GURU!  www.yahoo.de/clever
