Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYKUJ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYKUJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYKUJ7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:59:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49935 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYKUJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:59:14 -0500
Date: Fri, 21 Nov 2008 18:58:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: [PATCH 0/2] memcg: fix oom handling
Message-Id: <20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49261F87.50209@cn.fujitsu.com>
References: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
	<20081114191949.926bf99d.kamezawa.hiroyu@jp.fujitsu.com>
	<49261F87.50209@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Li Zefan reported

(a) This goes dead lock:
==
   #echo 0 >  (...)/01/memory.limit_in_bytes   #set memcg's limit to 0,
   #echo $$ > (...)/01/memory.tasks            #move task
   # do something...
==

(b) seems to be dead lock
==
   #echo 40k >  (...)/01/memory.limit_in_bytes   #set memcg's limit to 0,
   #echo $$ > (...)/01/memory.tasks            #move task
   # do something...
==


I think (a) is BUG. (b) is just slow down.
(you can see pgpgin/pgpgout count is increasing in (B).)

This patch set is for handling (a). Li-san, could you check ?
This works well in my environment.(means OOM-Killer is called in proper way.)

 [1/2].... current mmotm has pagefault_out_of_memory() but this doesn't consider
           memcg. When memcg hit limits in page_fault and panic_on_oom is set,
           the kernel panics.
           This tries to fix that.
           (See patches/mm-invoke-oom-killer-from-page-fault.patch)

 [2/2].... fixes wrong logic of check_under_limit.

Anyway, it seems hierarchy support is *not* enough in OOM handler.
Balbir, could you check it ? 
I think "a bad process in hierarchy rather than memcg" should be killed.

Thanks,
-Kame

