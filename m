Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbXFGTpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbXFGTpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765887AbXFGTpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:45:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765675AbXFGTpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:45:25 -0400
Date: Thu, 7 Jun 2007 12:45:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Mark Lord <lkml@rtr.ca>, Stephen Tweedie <sct@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-Id: <20070607124507.79d8da54.akpm@linux-foundation.org>
In-Reply-To: <46682E4E.1070303@redhat.com>
References: <46680BB8.50404@rtr.ca>
	<20070607084142.42583639.akpm@linux-foundation.org>
	<46682E4E.1070303@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 12:11:58 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> On 06/07/2007 11:41 AM, Andrew Morton wrote:
> >>    mount /var/lib/mythtv -oremount,ro
> >>    sync
> >>    umount /var/lib/mythtv
> > 
> > Did this succeed?  If the application is still truncating that file, the
> > umount should have failed.
> 
> Shouldn't sync should wait for truncate to finish?

I can't think of anything in there at present which would cause that to
happen, and it's not immediately obvious how we _could_ make it happen - we
have an inode which potentially has no dirty pages and which is itself
clean.  The truncate can span multiple journal commits, so forcing a
journal commit in sync() won't necessarily block behind the truncate.

I guess we could ask sync to speculatively take and release every inode's
i_mutex or something.  But even that would involve quite some hoop-jumping
due to those infuriating spinlock-protected list_heads on the superblock.

hmm.
