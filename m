Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYC1JC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYC1JC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYC1JCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:02:43 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35080 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYC1JCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:02:42 -0400
To: David Chinner <dgc@sgi.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] freeze feature ver 1.0
Message-Id: <20080328180145t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 28 Mar 2008 18:01:45 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Chinner wrote:
> Can you please split this into two patches - one which introduces the
> generic functionality *without* the timeout stuff, and a second patch
> that introduces the timeouts.

OK.
I will send the split patches in subsequent mails. 
 
> I think this timeout stuff is dangerous - it adds significant
> complexity and really does not protect against anything that can't
> be done in userspace.  i.e. If your system is running well enough
> for the timer to fire and unfreeze the filesystem, it's running well
> enough for you to do "freeze X; sleep Y; unfreeze X".  

If the process is terminated at "sleep Y" by an unexpected
accident (e.g. signals),  the filesystem will be left frozen.
So, I think the timeout is needed to unfreeze more definitely.

> FWIW, there is nothing to guarantee that the filesystem has finished
> freezing when the timeout fires (it's not uncommon to see
> freeze_bdev() taking *minutes*) and unfreezing in the middle of a
> freeze operation will cause problems - either for the filesystem
> in the middle of a freeze operation, or for whatever is freezing the
> filesystem to get a consistent image.....

Do you mention the freeze_bdev()'s hang?
The salvage target of my timeout is freeze process's accident as below.
- It is killed before calling the unfreeze ioctl
- It causes a deadlock by accessing the frozen filesystem
So the delayed work for the timeout is set after all of freeze operations
in freeze_bdev() in my patches.
I think the filesystem dependent code (write_super_lockfs operation)
should be implemented not to cause a hang.

Cheers, Takashi
