Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYHTI0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYHTI0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYHTI0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:26:25 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:37819 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYHTI0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wiJ8rlgVWAW/j9j4qevWIKfDrTfCqjxeNk0QPaAntCBwOlxSRb9ySlb68USmvOPeux
         Pvdt6BxiBdeasEbaEecJ1lhN8cpIs13Bv1Y7i1ciTYKUtO/LsPO+Hfn38DYXbjGf23zB
         p86twbFcs/ThCojawgskglKfhx9lb7i6ICgUU=
Message-ID: <9c5ac5e90808200126m7b3c4db1h99e58cceaf167081@mail.gmail.com>
Date: Wed, 20 Aug 2008 16:26:22 +0800
From: "Trotski Liu" <trotski.liu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: how to maintain the coherence between PG_Dirty and BH_Dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my rash mail, but I really have some questions which have
bothered me for a long time.

1)   Since clear_page_dirty_for_io move the dirty bit from pte to page
structure,  and dirty all the buffer_head associated with the page
structure, what is the purpose of set_page_dirty in do_wp_page /
do_linear_fault ?
     The dirty state is recorded in the pte, and even if we do not
call the set_page_dirty, each clear_page_dirty_for_io will  set
PG_Dirty correctly according to the pte.
    We only need to call set_page_dirty when the dirty pte will be
unmapped, and as long as the pte is not unmapped, the _PAGE_DIRTY in
pte will reflect the lastest dirty state of the page, isn't it?


2) in some circumstance(e.g. do_wp_page,do_linear_fault), we call
set_page_dirty without holding PG_Lock. is it possible that the page
isn't associated with any buffer_head, and set_page_dirty works like
this:
  CPU 1 : spin_lock ( private_lock )
  CPU 1 : nothing to do because none buffer_head is attached
  CPU 1 : spin_unlock ( private_lock )
  CPU 2 ( or preempt ) : create_empty_buffers {
                                  : lock_page
                                  : spin_lock ( private_lock )
                                  : attached clean buffers to the page
because CPU 1 is not set PG_Dirty yet
                                  : spin_unlock ( private_lock )
                                  : unlock_page }
  CPU 1 : Set_Bit ( PG_Dirty )
  the result is dirty page with clean buffer_head, and data will lost.
  then try_to_free_buffers maybe  call cancel_dirty_page since all the
buffer_heads attached is clean. thus,the set_page_dirty have none
effect on the dirty state, and all PG_dirty and BH_Dirty are cleaned.
   is this concurrency possible?  is it better to implement
set_page_dirty like this:
   >  spin_lock ( private_lock)
   >  mark buffer_head as BH_Dirty
   >  ret = test_and_set (PG_Dirty)
   >  spin_unlock ( private_lock )
   >  if (!ret)
   >     mark page as TAG_DIRTY in Radix Tree


  3) why create_empty_buffers will  set BH_Dirty if PG_Dirty, but
grow_buffers will not ?
      if a block device page is mapped to user space, and is marked
dirty, we attach clean buffer_heads to it will guarantee the file
system will not be corrupted, but it also imply that  the dirty data
in the blocks will be lost.
