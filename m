Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZCWE5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZCWE5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZCWE47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:56:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39187 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZCWE47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:56:59 -0400
Date: Mon, 23 Mar 2009 13:55:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-Id: <20090323135528.ddf795f6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090323043538.GB3306@in.ibm.com>
References: <20090323043538.GB3306@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 10:05:38 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> Here is the v4 of the cpuacct statistics patch to obtain per-cgroup
> system and user times  with appropriate tags and complete changelog.
> This applies against the latest -tip plus the cpuacct hierarchy fix v2
> which I posted just now. Could you please include this in -tip ?
> 
> Changelog:
> 
> v4
> - Remove comments in cpuacct_update_stats() which explained why rcu_read_lock()
>   was needed (as per Peter Zijlstra's review comments).
> - Don't say that percpu_counter_read() is broken in Documentation/cpuacct.txt
>   as per KAMEZAWA Hiroyuki's review comments.
> 
Broken -> isn't safe ? no difference ;)
Can't this help you ?


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Mar21/include/linux/percpu_counter.h
===================================================================
--- mmotm-2.6.29-Mar21.orig/include/linux/percpu_counter.h
+++ mmotm-2.6.29-Mar21/include/linux/percpu_counter.h
@@ -62,6 +62,16 @@ static inline s64 percpu_counter_read(st
 	return fbc->count;
 }
 
+static inline s64 percpu_counter_read_safe(struct percpu_counter *fbc)
+{
+	s64 ret;
+
+	spin_lock(&fbc->lock);
+	ret = fbc->count;
+	spin_unlock(&fbc->lock);
+	return ret;
+}
+
 /*
  * It is possible for the percpu_counter_read() to return a small negative
  * number for some counter which should never be negative.
@@ -114,6 +124,11 @@ static inline s64 percpu_counter_read(st
 	return fbc->count;
 }
 
+static inline s64 percpu_counter_read_safe(struct percpu_counter *fbc)
+{
+	return fbc->count;
+}
+
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
 	return fbc->count;

