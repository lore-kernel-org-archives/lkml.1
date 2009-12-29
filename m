Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZL2XWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZL2XWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 18:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZL2XWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 18:22:33 -0500
Received: from lo.gmane.org ([80.91.229.12]:59808 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZL2XWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 18:22:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: 2.6.33-rc1: WARNING: at kernel/mutex-debug.c:78 (geode hw rng?)
Date: Tue, 29 Dec 2009 18:22:01 -0500
Message-ID: <20091229182201.1df596b4@mycelium.queued.net>
References: <4B2D7388.9030002@nets.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <4B2D7388.9030002@nets.rwth-aachen.de>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Cc: linux-geode@bombadil.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009 01:44:56 +0100
Arnd Hannemann <hannemann@nets.rwth-aachen.de> wrote:

> Hi,
> 
> not so sure if it is geode related.
> While starting rngd on 2.6.33-rc1 on a geode machine, I got this
> warning:
> 
> [   19.545852] ------------[ cut here ]------------
> [   19.547554] WARNING: at kernel/mutex-debug.c:78
> debug_mutex_unlock+0x78/0xb8()
> [   19.547554] Modules linked in: ipt_LOG iptable_nat nf_nat
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 arc4 ecb ath5k ehci_hcd
> ohci_hcd mac80211 ath
> [   19.547554] Pid: 2509, comm: rngd Not tainted 2.6.33-rc1-ah0 #2
> [   19.547554] Call Trace:
> [   19.547554]  [<c102d86c>] ? debug_mutex_unlock+0x78/0xb8
> [   19.547554]  [<c10168bd>] warn_slowpath_common+0x60/0x77
> [   19.547554]  [<c10168e1>] warn_slowpath_null+0xd/0x10
> [   19.547554]  [<c102d86c>] debug_mutex_unlock+0x78/0xb8
> [   19.547554]  [<c1273314>] __mutex_unlock_slowpath+0x7b/0xa3
> [   19.547554]  [<c1273344>] mutex_unlock+0x8/0xa
> [   19.547554]  [<c116de8c>] rng_dev_read+0x13b/0x156
> [   19.547554]  [<c116dd51>] ? rng_dev_read+0x0/0x156
> [   19.547554]  [<c105ac23>] vfs_read+0x8a/0x11a
> [   19.547554]  [<c105af18>] sys_read+0x3b/0x60
> [   19.547554]  [<c127426d>] syscall_call+0x7/0xb
> [   19.547554] ---[ end trace cd1825d2e719f82e ]---
> 
> however, the system seems stable, and the hwrng seems to work fine...
> 
> Best regards,
> Arnd


Hm, I suspect that 9996508b is the culprit.  Does the following patch
help?



Subject: [PATCH] hw_random: don't attempt to unlock mutex twice

Commit 9996508b reworked rng_dev_read such that we unlock rng_mutex
after exiting the loop; however, we also unlock it inside the loop
before exiting.  The out_unlock label should only be reached manually.

This code is starting to reach goto-considered-harmful territory. :/

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/char/hw_random/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e989f67..29a5f6a 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -157,6 +157,9 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			err = -ERESTARTSYS;
 			goto out;
 		}
+
+		if (!size)
+			goto out;
 	}
 out_unlock:
 	mutex_unlock(&rng_mutex);
-- 
1.5.6.5



