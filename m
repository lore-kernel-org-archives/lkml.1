Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZFWHJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZFWHJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZFWHJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:09:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57743 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZFWHJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:09:01 -0400
Date: Tue, 23 Jun 2009 16:07:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/2] memcg: cgroup fix rmdir hang
Message-Id: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

previous discussion was this => http://marc.info/?t=124478543600001&r=1&w=2

This patch tries to fix problem as
  - rmdir can sleep very very long if swap entry is shared between multiple
    cgroups

Now, cgroup's rmdir path does following

==
again:
	check there are no tasks and children group.
	call pre_destroy()
	check css's refcnt
	if (refcnt > 0) {
		sleep until css's refcnt goes down to 0.
		goto again
	}
==

Unfortunately, memory cgroup does following at charge.

	css_get(&memcg->css)
	....
	charge(memcg) (increase USAGE)
	...
And this "memcg" is not necessary to include the caller, task.

pre_destroy() tries to reduce memory usage until USAGE goes down to 0.
Then, there is a race that
	- css's refcnt > 0 (and memcg's usage > 0)
	- rmdir() caller sleeps until css->refcnt goes down 0.
	- But to make css->refcnt be 0, pre_destroy() should be called again.

This patch tries to fix this in asyhcnrounos way (i.e. without big lock.)
Any comments are welcome.

Thanks,
-Kame

