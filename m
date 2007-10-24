Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXJXUkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXJXUkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXJXUkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:40:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:37752 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbXJXUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bJmU4s5Ukxaukl7Dqve8AiFLsJfvsCDO7Qp87NpYVJcvnc+hEK9s5qgFZU66wLrIdosLsxvefJNlfhGv67DWqBmOVI5qSwO9MtLHw5PLINEfjNI/z45uO4OJ1KtmR76lZYVw676Ye46P2RwNPFw23UG/ThlZ24dR7KOY0S458A4=
Message-ID: <6844644e0710241339i4d9ee450s98f9941f43a8cd6@mail.gmail.com>
Date: Wed, 24 Oct 2007 16:39:57 -0400
From: "Doug Reiland" <dreiland@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.xxx race condition in x86_64's global_flush_tlb???
Cc: dreiland@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen some hangs in 2.6-x86_64 in flush_kernel_map(). The tests
cause alot of ioremap/iounmap to occur concurrently across many
processor threads.

Looking at the hung processor hangs, they are looping in
flush_kernel_map() and the list they get from the smp_call_function()
appears to be corrupt. In fact, I see deferred_pages as an entry and
that isn't supposed to happen.

I am questioning the locking in global_flush_tlb() listed below. The
down_read/up_read protection doesn't seen safe. If several threads are
rushing thru here, deferred_pages could be getting changed as they
look at it. I don't think there any protection when
list_replace_init() calls INIT_LIST_HEAD().

I changed the down_read()/up_read() around list_replace_init() to
down_write()/up_write() and my test runs fine.


void global_flush_tlb(void)
{
        struct page *pg, *next;
        struct list_head l;

        down_read(&init_mm.mmap_sem); // XXX should be down_write()???
        list_replace_init(&deferred_pages, &l);
        up_read(&init_mm.mmap_sem); // XXX should be up_write()????
        flush_map(&l);

        list_for_each_entry_safe(pg, next, &l, lru) {
                ClearPagePrivate(pg);
                __free_page(pg);
        }
}
