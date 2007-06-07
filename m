Return-Path: <linux-kernel-owner+w=401wt.eu-S936764AbXFGVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936764AbXFGVjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764124AbXFGVi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:38:57 -0400
Received: from rtr.ca ([64.26.128.89]:1552 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbXFGVi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:38:56 -0400
Message-ID: <46687AEE.6030005@rtr.ca>
Date: Thu, 07 Jun 2007 17:38:54 -0400
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

Yeah, I really don't know what to do with this either.
We have to have a bounds on how long we wait at shutdown,
but there doesn't seem to be an easy way to get notified
once a filesystem becomes idle (?).

I suppose I could have the script loop on /proc/interrupts until
it sees the disk activity has tapered off..

Cheers
