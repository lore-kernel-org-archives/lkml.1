Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbZFAFi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbZFAFi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZFAFiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:38:04 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63156 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZFAFiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MEdon5uH7X7HLBcrccz59JgBHln4JEK4xaO3JYKkbIW7qACRx2hvUebKItwpxeN6ds
         eBjixnJlDqsPEhx3z1VwKh2Q464WAYuzPw2ibBnk7AbcLAp3gpnNJIAGhR4kyczrMKvV
         WZWUiI+6x86T8ofKKRV7xX54JkL59lCCOWM+o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [RFC PATCH 0/2] tracing/stat: stat entries self handling mode
Date: Mon,  1 Jun 2009 07:37:57 +0200
Message-Id: <1243834679-19132-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset introduce a new mode in stat tracing which handles the
stat entries instead of the tracer.

It's a bit like the role of the ring buffer when used by the tracing
except that it deals with stat entries using a hashlist and it's
much less elaborate :)

I guess it could bring some possibilities to plug it in
TRACE_EVENT() or using something similar.

Also it should (I hope) reduce the workqueue tracing code and probably
other future stat tracers as well, if any.

I've tried to minimize the locking.
We have one lock on the fastpath: while a entry is updated by
the tracer. Only the entry is locked here and I fear there
are few other alternatives.

Another lock protects the free entry picking: when a stat entry
has not yet been touched, a free entry is picked up from a list
which is protected with a spinlock too. It also protects against
concurrent removals on the hash list: the entry in turn come
back to the free nodes on removal.
This one doesn't worries me much: the free entry picking happens
only once for each stat entry. And the removals are rare.

Concerning the hash list walking, it is done through rcu.

Another annoying thing, I use raw_spinlock because I'm locking
in the tracing fastpath (entry update), so in case it is used
to trace the locks once day, it's more safe against tracing
recursion.

Thanks,
Frederic.


Frederic Weisbecker (2):
  tracing/stat: introduce new hashlist mode
  tracing/stat: provide a sample example to use the hashlist based stat
    tracing

 kernel/trace/Makefile     |    1 +
 kernel/trace/trace_stat.c |  329 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_stat.h |   27 ++++-
 kernel/trace/trace_test.c |  108 +++++++++++++++
 4 files changed, 462 insertions(+), 3 deletions(-)
 create mode 100644 kernel/trace/trace_test.c

