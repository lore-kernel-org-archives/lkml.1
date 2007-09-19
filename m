Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbXISOFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbXISOFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbXISOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:05:24 -0400
Received: from mx2.go2.pl ([193.17.41.42]:42706 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754905AbXISOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:05:23 -0400
Date: Wed, 19 Sep 2007 16:07:26 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070919140726.GA4603@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EFE6D7.3070105@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-09-2007 16:55, Nadia Derbey wrote:
...
> 
> Well, reviewing the code I found another place where the 
> rcu_read_unlock() was missing.
> I'm so sorry for the inconvenience. It's true that I should have tested 
> with CONFIG_PREEMPT=y :-(
> Now, the ltp tests pass even with this option set...
> 
> In attachment you'll find a patch thhat
> 1) adds the missing rcu_read_unlock()
> 2) replaces Andrew's fix with a new one: the rcu_read_lock() is now 
> taken in ipc_lock() / ipc_lock_by_ptr() and released in ipc_unlock(), 
> exactly as it was done in the ref code.

BTW, probably I miss something, but I wonder, how this RCU is working
here. E.g. in msg.c do_msgsnd() there is:

msq = msg_lock_check(ns, msqid);
...

msg_unlock(msq);
schedule();

ipc_lock_by_ptr(&msq->q_perm);

Since msq_lock_check() gets msq with ipc_lock_check() under
rcu_read_lock(), and then goes msg_unlock(msq) (i.e. ipc_unlock())
with rcu_read_unlock(), is it valid to use this with
ipc_lock_by_ptr() yet?

Regards,
Jarek P.
