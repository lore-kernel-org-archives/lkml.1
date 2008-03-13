Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYCMSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYCMSGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYCMSGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:06:43 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:56702 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYCMSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=jyYLjpsM4LIHgw8ULKo6JJqJsjj8zSd2nKiTAMn3GSahREXU5z0NLZmmp2i6oUrcap36i6IfJNsCImbN3sequaTpG2a8CR/KMUzDUFXl0LLydUE4DitL761Zpat20fbVNGEKioHgWew3P7aCGl6xejaPRrxgEbqnj2ywEnV35gg=
Date: Thu, 13 Mar 2008 15:07:25 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Swap scheduling?
Message-ID: <20080313180725.GA4586@localhost.ift.unesp.br>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just want to provide some latencytop numbers which I
collected during the experience described in another thread
( http://lkml.org/lkml/2008/3/13/134 ).

The behaviour is not completely reproducible. I've just repeated
the test of opening the 380MB file with xjed and it turned out
ok, just like I dream it to be. 

This is what I had before opening the file a few moments ago:
(Window Maker + firefox + thunderbird + mrxvt + xterm)

[mafra@localhost:~]$ free
             total       used       free     shared    buffers     cached
Mem:        513872     403316     110556          0      49076     214084
-/+ buffers/cache:     140156     373716
Swap:      2144636          0    2144636

Then I tryed to open the 380MB file, which took like 30 seconds but
meanwhile I could switch desktops, type in the terminal and I could have
closed the xjed window if I wanted (ie the mouse was responsive and I
could "aim" it very well)

So far so good! I was also running latencytop and this is what I got
in a random moment (I don't know if latencytop has a record of the
worst latencies. Arjan?):

Cause                                                Maximum     Percentage
sync_page __lock_page handle_mm_fault do_page_faul442.7 msec         36.0 %
Scheduler: waiting for cpu                        365.8 msec         54.5 %
sync_buffer __wait_on_buffer __bread ext3_get_bran335.5 msec          2.3 %
sync_buffer __wait_on_buffer ext3_find_entry ext3_252.5 msec          0.3 %
sync_page __lock_page find_lock_page filemap_fault235.3 msec          4.4 %
sync_page __lock_page handle_mm_fault do_page_faul208.4 msec          0.3 %
sync_page __lock_page handle_mm_fault do_page_faul104.7 msec          0.1 %
sync_page wait_on_page_bit shmem_getpage shmem_fau 99.0 msec          0.2 %
sync_page __lock_page handle_mm_fault do_page_faul 72.9 msec          0.1 %
o_read do_sync_read vfs_read sys_read



Process wmaker (3406)
sync_page __lock_page handle_mm_fault do_page_faul442.7 msec         32.0 %
sync_page __lock_page find_lock_page filemap_fault188.0 msec         20.1 %lt do_page_fault error_code
Scheduler: waiting for cpu                         77.0 msec         47.6 %
do_select core_sys_select sys_select sysenter_past  2.1 msec          0.2 %


However, I also happen to have another latencytop log which I could
gather while the desktop was misbehaving a few days ago during
this same test. It looks like this:

Cause                                                Maximum     Percentage
get_request_wait __make_request generic_make_reque1423.6 msec          9.4 %
get_request_wait __make_request generic_make_reque1328.4 msec          5.7 %
sync_page __lock_page handle_mm_fault do_page_faul902.1 msec          0.5 %
sync_page __lock_page find_lock_page filemap_fault885.0 msec         23.8 %
sync_page __lock_page handle_mm_fault do_page_faul831.1 msec         32.2 %
sync_page __lock_page handle_mm_fault do_page_faul588.8 msec          0.3 %
get_request_wait __make_request generic_make_reque565.2 msec          0.3 %
get_request_wait __make_request generic_make_reque549.5 msec          0.3 %
sync_buffer __wait_on_buffer __bread ext3_get_bran423.0 msec          2.1 %
dahead do_page_cache_readahead filemap_fault


Process wmaker (3518)                                                                                                                                          
get_request_wait __make_request generic_make_reque1377.7 msec         25.5 %ge shrink_page_list shrink_inactive_list shrink_zone try_to_free_pages __alloc_page
sync_page __lock_page handle_mm_fault do_page_faul570.5 msec         19.3 %
sync_buffer __wait_on_buffer __bread ext3_get_bran349.4 msec          8.6 % ext3_get_block do_mpage_readpage mpage_readpages ext3_readpages __do_page_cache_rea
Scheduler: waiting for cpuhead filemap_fault      242.3 msec         39.5 %
get_request_wait __make_request generic_make_reque149.2 msec          2.8 %age shrink_page_list shrink_inactive_list shrink_zone try_to_free_pages __alloc_page
sync_page __lock_page find_lock_page filemap_fault127.3 msec          3.4 %lt do_page_fault error_code

I could take this from latencytop while xjed was almost finishing
to load the file. I see some ~1 second figures there, but I must
say that it was taking much longer (like 10 seconds) to get any
reaction to a typed letter in the terminal. It was difficult to
aim the mouse pointer etc (because it disapeared for seconds).

Well, these are some numbers. People who know things better 
can judge them better than me! :-)
