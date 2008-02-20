Return-Path: <linux-kernel-owner+w=401wt.eu-S935187AbYBTQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187AbYBTQdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbYBTQQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:16:35 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:53616 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765870AbYBTQQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:16:33 -0500
Date: Wed, 20 Feb 2008 19:14:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu
Subject: [PATCH] (for -mm only) put_pid: make sure we don't free the live pid
Message-ID: <20080220161439.GA146@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org> <20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru> <m1skzq9a59.fsf@ebiederm.dsl.xmission.com> <23492.1203464394@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23492.1203464394@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] (for -mm only) put_pid: make sure we don't free the live pid

Add the temporary (for -mm only) debugging code to catch the unbalanced
put_pid()'s. At least those which can free the "live" pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/pid.c~	2008-02-20 18:29:40.000000000 +0300
+++ MM/kernel/pid.c	2008-02-20 18:35:15.000000000 +0300
@@ -208,6 +208,10 @@ void put_pid(struct pid *pid)
 	ns = pid->numbers[pid->level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
+		int type = PIDTYPE_MAX;
+		while (--type >= 0)
+			if (WARN_ON(!hlist_empty(&pid->tasks[type])))
+				return;
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
 	}

