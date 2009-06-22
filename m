Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbZFVMcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbZFVMcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFVMc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:32:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54051 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZFVMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:32:27 -0400
Message-ID: <f9931fe09c239cd30222bf8532e62b65.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090622122615.GA28503@elte.hu>
References: <20090622183707.dd9e665b.kamezawa.hiroyu@jp.fujitsu.com>
    <20090622105231.GA17242@elte.hu>
    <18e69edd004ec13730246bd40600448c.squirrel@webmail-b.css.fujitsu.com>
    <ec48fff1916d3e82c3c4fc610245f0b6.squirrel@webmail-b.css.fujitsu.com>
    <20090622122615.GA28503@elte.hu>
Date: Mon, 22 Jun 2009 21:32:26 +0900 (JST)
Subject: Re: [RFC][PATCH] cgroup: fix permanent wait in rmdir
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Ah, while I test 2.6.30-git18 (includes above patch), I don't see
>> above stack dump (with LIST_DEBUG=y) under quick memory pressure
>> test...
>
> Note, it still occurs even with latest -git (f234012).
>
Could you try this ? (Sorry, I can't send a patch right now)
== vmscan.c
865 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
866                 struct list_head *src, struct list_head *dst,
867                 unsigned long *scanned, int order, int mode, int file)
868 {
869         unsigned long nr_taken = 0;
870         unsigned long scan;
871
<snip>
 930                         /* Check that we have not crossed a zone
boundary. */
931                         if (unlikely(page_zone_id(cursor_page) !=
zone_id))
932                                 continue;
933                         if (__isolate_lru_page(cursor_page, mode,
file) == 0) {
934                                 list_move(&cursor_page->lru, dst);
935                                 mem_cgroup_del_lru(page);
936                                 nr_taken++;
937                                 scan++;
938                         }


change line 935
from
  mem_cgroup_del_lru(page);
to
  mem_cgroup_del_lru(cursor_page);


Thanks,
-Kame




