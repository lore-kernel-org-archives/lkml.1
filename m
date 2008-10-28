Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYJ1AdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYJ1AdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYJ1Ac4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:32:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39774 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYJ1Acz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:32:55 -0400
Date: Tue, 28 Oct 2008 09:32:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       y-goto@jp.fujitsu.com
Subject: Re: [PATCH] memory hotplug: fix page_zone() calculation in
 test_pages_isolated()
Message-Id: <20081028093224.a0de9f64.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1225130369.20384.33.camel@localhost.localdomain>
References: <4905F114.3030406@de.ibm.com>
	<1225128359.12673.101.camel@nimitz>
	<1225130369.20384.33.camel@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 18:59:29 +0100
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> Instead of using pfn_to_page() you could also have just called
> > __first_valid_page() again.  But, that would have duplicated a bit of
> > work, even though not much in practice because the caches are still hot.
> > 
> > Technically, you wouldn't even need to check the return from
> > __first_valid_page() since you know it has a valid result because you
> > made the exact same call a moment before.
> > 
> > Anyway, can you remove the !page check, fix up the changelog and resend?
> 
> Calling __first_valid_page() again might be a good idea. Thinking about it
> now, I guess there is still a problem left with my patch, but for reasons
> other than what you said :) If the loop is completed with page == NULL,
> we will return -EBUSY with the new patch. But there may have been valid
> pages before, and only some memory hole at the end. In this case, returning
> -EBUSY would probably be wrong.
> 
> Kamezawa, this loop/function was added by you, what do you think?
> 

I think there is a bug, as you wrote.
But
 - "pfn" and "end_pfn" (and pfn in the middle of them) can be in different zone on strange machine.

Now: test_pages_isolated() is called in following sequence.
  
  check_page_isolated()
     walk_memory_resource()			# read resource range and get start/end of pfn
         -> chcek_page_isolated_cb()
		-> test_page_isolated().

I think all pages within [start, end) passed to test_pages_isolated() should be in the same zone.

please change this to
  check_page_isolated()
     walk_memory_resource()
         -> check_page_isolated_cb()
                 -> walk_page_range_in_same_zone()  # get page range in the same zone.
                        -> test_page_isolated().

Could you try ?

Thanks,
-Kame
 

