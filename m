Return-Path: <linux-kernel-owner+w=401wt.eu-S966757AbXFGWHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757AbXFGWHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966569AbXFGWFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:05:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966443AbXFGWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:05:14 -0400
Date: Thu, 7 Jun 2007 15:04:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-Id: <20070607150455.719f9ec0.akpm@linux-foundation.org>
In-Reply-To: <46687AEE.6030005@rtr.ca>
References: <46680BB8.50404@rtr.ca>
	<20070607084142.42583639.akpm@linux-foundation.org>
	<46682E4E.1070303@redhat.com>
	<20070607124507.79d8da54.akpm@linux-foundation.org>
	<46687AEE.6030005@rtr.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 17:38:54 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Andrew Morton wrote:
> > On Thu, 07 Jun 2007 12:11:58 -0400
> > Chuck Ebbert <cebbert@redhat.com> wrote:
> > 
> >> On 06/07/2007 11:41 AM, Andrew Morton wrote:
> >>>>    mount /var/lib/mythtv -oremount,ro
> >>>>    sync
> >>>>    umount /var/lib/mythtv
> >>> Did this succeed?  If the application is still truncating that file, the
> >>> umount should have failed.
> >> Shouldn't sync should wait for truncate to finish?
> > 
> > I can't think of anything in there at present which would cause that to
> > happen, and it's not immediately obvious how we _could_ make it happen - we
> > have an inode which potentially has no dirty pages and which is itself
> > clean.  The truncate can span multiple journal commits, so forcing a
> > journal commit in sync() won't necessarily block behind the truncate.
> > 
> > I guess we could ask sync to speculatively take and release every inode's
> > i_mutex or something.  But even that would involve quite some hoop-jumping
> > due to those infuriating spinlock-protected list_heads on the superblock.
> > 
> > hmm.
> 
> Yeah, I really don't know what to do with this either.
> We have to have a bounds on how long we wait at shutdown,
> but there doesn't seem to be an easy way to get notified
> once a filesystem becomes idle (?).
> 
> I suppose I could have the script loop on /proc/interrupts until
> it sees the disk activity has tapered off..
> 

I don't recall clarity on this question: did the umount fail?

Because it should have, in which case your script can poll that.

