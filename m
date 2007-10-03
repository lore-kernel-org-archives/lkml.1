Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXJCONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXJCONT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXJCONK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:13:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58000 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbXJCONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:13:08 -0400
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kaigai@kaigai.gr.jp, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
In-Reply-To: <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
References: <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	 <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	 <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	 <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	 <470395B3.2020904@kaigai.gr.jp>
	 <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 16:07:22 +0200
Message-Id: <1191420442.5599.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-03 at 22:59 +0900, Tetsuo Handa wrote:
> Hello.
> 
> KaiGai Kohei wrote:
> > If so, you can apply RCU instead to avoid read lock
> > when scanning the list, like:
> > 
> > rcu_read_lock();
> > list_for_each_entry(...) {
> >      ....
> > }
> > rcu_read_unlock();
> 
> Can I sleep between rcu_read_lock() and rcu_read_unlock() ?
> As far as I saw, rcu_read_lock() makes in_atomic() true, so I think I can't sleep.
> 
> If I use RCU, I have to give up " [TOMOYO 13/15] Conditional permission support"
> because tmy_check_condition() can sleep.

You can indeed not sleep in an rcu_read_lock() section. However, you
could grab a reference on an item, stop the iteration, drop
rcu_read_lock. Do you thing, re-acquire rcu_read_lock(), drop the ref,
and continue the iteration.

Also, how do you avoid referencing dead data with your sll? I haven't
actually looked at your patches, but the simple scheme you outlined
didn't handle the iteration + concurrent removal scenario:

thread 1             thread 2

 foo = ptr->next

 < schedule >

                     killme = ptr->next (same item)
                     ptr->next = ptr->next->next;
                     kfree(killme)

                     < schedule >

 foo->bar <-- *BANG*

