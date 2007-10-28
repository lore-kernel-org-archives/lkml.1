Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbXJ1KJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbXJ1KJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXJ1KJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:09:24 -0400
Received: from ns.ariel-networks.com ([124.39.57.10]:55830 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbXJ1KJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:09:23 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Can you omit a part of processing of initialization in __pdflush. kernel<2.6.23>.
Message-Id: <20071028100921.DBE3D948007@ns.ariel-networks.com>
Date: Sun, 28 Oct 2007 19:09:21 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- hiroyasu ohyama

I think it doesn't have to initialize function callback function which is member of pdflush_work discripter twice and It should do that in head of in infinity loop before calling schedule(). Because the latter initialization which is executed at the 143th line of the mm/pdflush.c has done in order to be reused. And I think if it initialize that in the head of loop, the former which is initialized at the 96th line can omit doing that.

---

*** mm/pdflush_bck.c  2007-10-28 15:51:08.000000000 +0900
--- mm/pdflush.c  2007-10-28 15:51:28.000000000 +0900
***************
*** 93,99 ****
  {
    current->flags |= PF_FLUSHER | PF_SWAPWRITE;
    set_freezable();
-   my_work->fn = NULL;
    my_work->who = current;
    INIT_LIST_HEAD(&my_work->list);

--- 93,98 ----
***************
*** 102,107 ****
--- 101,107 ----
    for ( ; ; ) {
      struct pdflush_work *pdf;

+     my_work->fn = NULL;
      set_current_state(TASK_INTERRUPTIBLE);
      list_move(&my_work->list, &pdflush_list);
      my_work->when_i_went_to_sleep = jiffies;
***************
*** 140,146 ****
      }

      spin_lock_irq(&pdflush_lock);
-     my_work->fn = NULL;

      /*
       * Thread destruction: For how long has the sleepiest
--- 140,145 ----

