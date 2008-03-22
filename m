Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYCVWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYCVWI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYCVWIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:08:51 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:29542 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYCVWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sA27eRYOsCXwORbfN9XajPSPpcxfcOPSXCa32Wz5EQ6XIXEvXyT4MSwLj8y5lyYp41s6ygHJS9YoroNUV2QKNtj5Dr1tyu8Dzup39lG0TY4hQCPJDI/qLcDF3RcpHPugmE++FFuXb/pGBXfD7sYRmKWJYca2ZpezA6JwM3eOFN0=
Date: Sat, 22 Mar 2008 19:09:14 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arjan@linux.intel.com
Subject: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?)
Message-ID: <20080322220914.GA4916@localhost.ift.unesp.br>
Mail-Followup-To: linux-kernel@vger.kernel.org, arjan@linux.intel.com
References: <20080322220134.GA4559@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322220134.GA4559@localhost.ift.unesp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I've repeated the experience described in
http://lkml.org/lkml/2008/3/15/111 and I got these
latencytop numbers(!)

Cause                                                Maximum     Percentage
sync_page __lock_page handle_mm_fault do_page_faul103659.0 msec         59.8 %
get_request_wait __make_request generic_make_reque1992.0 msec         10.2 %
get_request_wait __make_request generic_make_reque1620.7 msec          4.6 %
sync_page __lock_page find_lock_page filemap_fault399.3 msec          3.4 %
sync_buffer __wait_on_buffer __bread ext3_get_bran292.9 msec          1.3 %
sync_page __lock_page handle_mm_fault do_page_faul200.5 msec          0.3 %
Scheduler: waiting for cpu                        155.9 msec         18.9 %
sync_page __lock_page handle_mm_fault do_page_faul117.5 msec          0.1 %
congestion_wait try_to_free_pages __alloc_pages re103.5 msec          0.2 %
r_code


Process X (2910)
sync_page __lock_page handle_mm_fault do_page_faul103659.0 msec         98.5 %
Scheduler: waiting for cpu                         64.6 msec          1.3 %
sync_page __lock_page find_lock_page filemap_fault 51.4 msec          0.2 %lt do_page_fault error_code
sync_buffer __wait_on_buffer __bread ext3_get_bran 17.8 msec          0.0 % ext3_get_block do_mpage_readpage mpage_readpa
sync_page __lock_page handle_mm_fault do_page_faul  9.1 msec          0.0 %ig ault

The experience goes like this:

1) Boot with 2.6.25-rc6-00243-g028011e
2) Log into X 
3) Open a 380MB file with xjed

It takes more than 6 minutes to load the file, and meanwhile
I experience very bad desktop interactivity (like 1 minute to
the result of pressing F12 in Window Maker to appear in the
screen).

If, after step 2), I start using firefox, thunderbird, play some
music etc and then close all these apps and go to step 3),
the loading finishes in about 2 minutes (and I have very
good interactivity meanwhile).

So I noticed that when xjed is opening the file it is in
'D' state (reported by ps), and while greping the kernel
source code for 'sync_page' I've found this comment 
in mm/filemap.c:

/**
 * __lock_page - get a lock on the page, assuming we need to sleep to get it
 * @page: the page to lock
 *
 * Ugly. Running sync_page() in state TASK_UNINTERRUPTIBLE is scary.  If some
 * random driver's requestfn sets TASK_RUNNING, we could busywait.  However
 * chances are that on the second loop, the block layer's plug list is empty,
 * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
 */

"Ugly. Running sync_page() in state TASK_UNINTERRUPTIBLE is scary."

It appears that my problem with xjed in 'D' state while loading,
and sync_page() appearing in latencytop with 103 secs of latency
may be related through the "ugliness" described above.

So I was wondering if there is a way to fix this. Note that 
this issue does not happen if I load the file after using the
computer for a while, so it is not impossible to have good
interactivity while loading that big file.

I am sorry that I am scattering reports about this issue all
over the place.
