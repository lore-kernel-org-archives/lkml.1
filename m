Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZISFsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZISFsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 01:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZISFsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 01:48:36 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:49915 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZISFsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 01:48:35 -0400
Message-ID: <4AB47077.9060402@vflare.org>
Date: Sat, 19 Sep 2009 11:17:35 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>  <1253227412-24342-3-git-send-email-ngupta@vflare.org> <1253256805.4959.8.camel@penberg-laptop> <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 12:47 PM, Hugh Dickins wrote:
> On Fri, 18 Sep 2009, Pekka Enberg wrote:
>> On Fri, 2009-09-18 at 04:13 +0530, Nitin Gupta wrote:
>>> +EXPORT_SYMBOL_GPL(set_swap_free_notify);
>>> +
>>>  static int swap_entry_free(struct swap_info_struct *p,
>>>  			   swp_entry_t ent, int cache)
>>>  {
>>> @@ -585,6 +617,8 @@ static int swap_entry_free(struct swap_info_struct *p,
>>>  			swap_list.next = p - swap_info;
>>>  		nr_swap_pages++;
>>>  		p->inuse_pages--;
>>> +		if (p->swap_free_notify_fn)
>>> +			p->swap_free_notify_fn(p->bdev, offset);
>>>  	}
>>>  	if (!swap_count(count))
>>>  		mem_cgroup_uncharge_swap(ent);
>>
>> OK, this hits core kernel code so we need to CC some more mm/swapfile.c
>> people. The set_swap_free_notify() API looks strange to me. Hugh, I
>> think you mentioned that you're okay with an explicit hook. Any
>> suggestions how to do this cleanly?
> 
> No, no better suggestion.  I quite see Nitin's point that ramzswap
> would benefit significantly from a callback here, though it's not a
> place (holding swap_lock) where we'd like to offer a callback at all.
> 
> I think I would prefer the naming to make it absolutely clear that
> it's a special for ramzswap or compcache, rather than dressing it
> up in the grand generality of a swap_free_notify_fn: giving our
> hacks fancy names doesn't really make them better.
> 

One more thing. If this renaming is done, then I think this notify
callback should no longer be unconditionally compiled. It should depend
on some ramzswap specific symbol.

Do you think you will be able to Ack this swap notify patch if above things
are done (rest of the driver is aimed at staging)? For your reference, below
is the patch to do this. I think I will have to send "v4" patches that will
include this one and related changes in ramzswap driver code.


(patch to make ramzswap notify callback conditional)
---
diff --git a/drivers/staging/ramzswap/Kconfig b/drivers/staging/ramzswap/Kconfig
index 24e2569..e9c0900 100644
--- a/drivers/staging/ramzswap/Kconfig
+++ b/drivers/staging/ramzswap/Kconfig
@@ -19,3 +19,8 @@ config RAMZSWAP_STATS
 	help
 	  Enable statistics collection for ramzswap. This adds only a minimal
 	  overhead. In unsure, say Y.
+
+config RAMZSWAP_NOTIFY
+	bool
+	depends on RAMZSWAP
+	default y
diff --git a/include/linux/swap.h b/include/linux/swap.h
index ace7900..8755b1e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -299,8 +299,15 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
+#ifdef CONFIG_RAMZSWAP_NOTIFY
 extern void set_ramzswap_free_notify(struct block_device *,
 				ramzswap_free_notify_fn *);
+#else
+void set_ramzswap_free_notify(struct block_device *bdev,
+			ramzswap_free_notify_fn *notify_fn)
+{
+}
+#endif
 struct backing_dev_info;

 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0cc9c9c..d4459e4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -554,6 +554,7 @@ out:
 	return NULL;
 }

+#ifdef CONFIG_RAMZSWAP_NOTIFY
 /*
  * Sets callback for event when swap_map[offset] == 0
  * i.e. page at this swap offset is no longer used.
@@ -585,6 +586,7 @@ void set_ramzswap_free_notify(struct block_device *bdev,
 	return;
 }
 EXPORT_SYMBOL_GPL(set_ramzswap_free_notify);
+#endif

 static int swap_entry_free(struct swap_info_struct *p,
 			   swp_entry_t ent, int cache)
