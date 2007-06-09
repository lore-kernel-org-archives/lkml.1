Return-Path: <linux-kernel-owner+w=401wt.eu-S1030901AbXFIC6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901AbXFIC6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 22:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968797AbXFIC6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 22:58:39 -0400
Received: from rtr.ca ([64.26.128.89]:4340 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968793AbXFIC6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 22:58:38 -0400
Message-ID: <466A175C.1000906@rtr.ca>
Date: Fri, 08 Jun 2007 22:58:36 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
References: <46680BB8.50404@rtr.ca>	<20070607084142.42583639.akpm@linux-foundation.org>	<46682E4E.1070303@redhat.com> <20070607124507.79d8da54.akpm@linux-foundation.org>
In-Reply-To: <20070607124507.79d8da54.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 07 Jun 2007 12:11:58 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>> On 06/07/2007 11:41 AM, Andrew Morton wrote:
>>>>    mount /var/lib/mythtv -oremount,ro
>>>>    sync
>>>>    umount /var/lib/mythtv
>>> Did this succeed?  If the application is still truncating that file, the
>>> umount should have failed.
>> Shouldn't sync should wait for truncate to finish?
> 
> I can't think of anything in there at present which would cause that to
> happen, and it's not immediately obvious how we _could_ make it happen - we
> have an inode which potentially has no dirty pages and which is itself
> clean.  The truncate can span multiple journal commits, so forcing a
> journal commit in sync() won't necessarily block behind the truncate.
> 
> I guess we could ask sync to speculatively take and release every inode's
> i_mutex or something.  But even that would involve quite some hoop-jumping
> due to those infuriating spinlock-protected list_heads on the superblock.
> 
> hmm.

Okay, I added more instrumentation and retested today.

Good and Bad.
The umount does indeed fail while the massive unlink is happening,
so I can just loop on that a few times before giving up.

But.. the earlier "remount,ro".. well.. I don't know what it does.
I did get it to lock up solid, though.. hung on the "remount,ro"
when issued during an unlink of a 15GB file.  The disk I/O eventually
completes, and drives go idle, but the system remains hung inside
the remount,ro call.

Alt-sysrq-T was functioning, so I have some screen shots (.jpg) here:

  http://rtr.ca/remount_ro/

That's definitely a bug.
For now, I'll just not attempt the remount,ro on this system,
and have it loop for a minute attempting umount instead.

Cheers
