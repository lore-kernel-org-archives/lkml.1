Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbXJGKiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbXJGKiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 06:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXJGKik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 06:38:40 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:54919 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbXJGKij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 06:38:39 -0400
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Sleeping in RCU list traversal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	<200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	<470395B3.2020904@kaigai.gr.jp>
	<200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
	<1191420442.5599.12.camel@lappy>
In-Reply-To: <1191420442.5599.12.camel@lappy>
Message-Id: <200710071938.BJE12993.LQSVOJFHFOOtFM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 7 Oct 2007 19:38:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Peter Zijlstra wrote:
> > Can I sleep between rcu_read_lock() and rcu_read_unlock() ?
> > As far as I saw, rcu_read_lock() makes in_atomic() true, so I think I can't sleep.
> You can indeed not sleep in an rcu_read_lock() section. However, you
> could grab a reference on an item, stop the iteration, drop
> rcu_read_lock. Do you thing, re-acquire rcu_read_lock(), drop the ref,
> and continue the iteration.

Something like this?

  rcu_read_lock();
  list_for_each_rcu(p, ...) {
    ptr = list_entry(p, struct ..., list);
    /* Grab a reference to "ptr". */
    rcu_read_unlock();
    my_task_that_may_sleep(ptr);
    rcu_read_lock();
    /* Drop a reference to "ptr". */
  }
  rcu_read_unlock();

Regarding my case, memory region pointed by "ptr" never be removed.
Do I need to grab a reference to "ptr" ?

Regards.

