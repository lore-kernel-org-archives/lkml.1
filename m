Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbXEAAs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbXEAAs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXEAAs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:48:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbXEAAs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:48:27 -0400
From: Neil Brown <neilb@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 1 May 2007 10:47:24 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17974.36380.681276.553949@notabene.brown>
Cc: "<Andrew Morton" <akpm@osdl.org>, <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: Remove broken SIGKILL support
In-Reply-To: message from Eric W. Biederman on Thursday April 19
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969641308-git-send-email-ebiederm@xmission.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 19, ebiederm@xmission.com wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Currently md_thread calls allow_signal so it can receive a
> SIGKILL but then does nothing with it except flush the
> sigkill so that it not can use an interruptible sleep.
> 
> This whole dance is silly so remove the unnecessary
> and broken signal handling logic.

(sorry of the delay in replying)

You missed some related code which should help you see that it is -
maybe - not completely 'silly' (though I confess it might be slightly
broken).
In md_check_recovery:

	if (signal_pending(current)) {
		if (mddev->pers->sync_request) {
			printk(KERN_INFO "md: %s in immediate safe mode\n",
			       mdname(mddev));
			mddev->safemode = 2;
		}
		flush_signals(current);
	}

The idea is that alt-sysrq-K will send SIGKILL to all processes
including the md support threads, which will cause them to enter
"immediate safe mode" so that the metadata will be marked clean
immediately at every opportunity.  That way you can use alt-sysrq:
  sync,unmount,kill,reboot
and be fairly sure that you md array will be shut down cleanly.

I'd be just as happy to link this into Unmount (aka
do_emergency_remount), but that doesn't seem at all straight forward,
and in any case should be done before the current code is ripped out.

While we do have a reboot_notifier which tries to stop all arrays,
I've never been comfortable with that.  A reboot really should just
reboot... 

What I would REALLY like is for the block device to know whether it is
open read-only or read-write.  Then I could mark it clean when it
becomes read-only as would happen when do_emergency_remount remounts
it read-only.

I might see how hard that would be...

NeilBrown
