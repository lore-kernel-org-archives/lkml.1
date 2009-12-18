Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZLROay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZLROay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZLROax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:30:53 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3170 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbZLROaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:30:52 -0500
Date: Fri, 18 Dec 2009 15:30:35 +0100
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, miquels@cistron.nl
Subject: spinlock which can morph into a mutex
Message-ID: <20091218143032.GA16595@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-NCC-RegID: nl.xs4all
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to implement a dynamically resizable hashtable, and
I have found that after resizing the table I need to call
synchronize_rcu() and finish up before letting other writers
(inserts, deletes) access the table.

Ofcourse during the hashtable update a spinlock is held to
exclude the other writers. But I cannot hold this spinlock over
synchronize_rcu(), yet the other writers still need to be excluded.

So I probably need a mutex instead of a spinlock, but I want to
keep minimal overhead for the common case (when no resizing is in
progress).  I think I need a spinlock that can morph into a mutex ..

I was thinking about using something like the code below.
It is sortof like a spinlock, but it's ofcourse less fair
than actual ticketed spinlocks.

I'm working off 2.6.27 at the moment, but I noticed that in
2.6.28 adaptive spinning was introduced for mutexes. Is the
approach below still worth it with adaptive spinning or could
I just convert the spinlocks to mutexes with minimal extra overhead ?

Example code:

int real_mutex_lock = 0; // can use int since mutex ops are barriers
struct mutex mutex;

// 1. used instead of spinlock() [common case]
while (mutex_trylock(&mutex) == 0) {
	if (real_mutex_lock) {
		mutex_lock(&mutex);
		break;
	}
}
.. have lock, do work
mutex_unlock(&mutex);


// 2. When we want to lock and be able to sleep [seldomly used]
mutex_lock(&mutex);
real_mutex_lock = 1;
smp_wmb();

.. do work ..
real_mutex_lock = 0;
mutex_unlock(&mutex);

Mike.
