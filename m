Return-Path: <linux-kernel-owner+w=401wt.eu-S964983AbXCKTWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbXCKTWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXCKTWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:22:46 -0400
Received: from delta.idt.cz ([81.0.223.58]:4405 "EHLO delta.idt.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXCKTWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:22:45 -0400
Date: Sat, 10 Mar 2007 22:16:31 +0100
From: Michal Hocko <mstsxfx@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: mm: migrate_pages using
Message-ID: <20070310211631.GA29295@curandero.idtnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have some problems with migrate_pages understanding. Here is my
situation:
I need to change virtual page mapping (all stuff referring to the page) 
to new physical location. Page is present for the process and new page is 
already allocated (and not mapped anywhere). I thought that direct migration 
code should help me, but there are some issues. Maybe I am missing something.

Here is my simple wrapper for migrate_pages (and related) function:

struct page * return_target(struct page * page, unsigned long private,
        int ** result)
{
        return (struct page *)private;
}

/* I am keeping non exclusive mmap_sem when entering and leaving */
int migrate_pfn_page(struct page *original, struct page *target)
{
        LIST_HEAD(pagelist);
        int ret;

        if((ret = migrate_prep()))
                goto done;
        get_page(original);
        ret = isolate_lru_page(original, &page_list);
        put_page(original);
        if(ret)
                goto done;
        ret = migrate_pages(&page_list, return_target, (unsigned long)target);
done:
        return ret;
}

I think that I am loosing pages this way (reference count is not
decreased properly and so original page doesn't get to the free list).
As a example (from printk output):
* before function starts.
original: flags:0x00000060 mapping:dece8fa1 mapcount:1 count:1
target: flags:0x00000000 mapping:00000000 mapcount:0 count:1
* before migrate_pages is called
original flags:0x00000040 mapping:dece8fa1 mapcount:1 count:2
target flags:0x00000000 mapping:00000000 mapcount:0 count:1
* migrate_pages returns with 0 and
original flags:0x00000000 mapping:00000000 mapcount:0 count:1
target flags:0x00000010 mapping:dece8fa1 mapcount:1 count:2

When I try to put_page(original) (because I don't want it for this
moment) I get to bad_page path and need to reboot...

What am I missing? Am I using migrate_pages correctly?

Thanks for any suggestions.

(please add me to cc: because I am not list member)

P.S.
I am using vanilla 2.6.18 source tree.

Best regards
-- 
Michal Hocko

