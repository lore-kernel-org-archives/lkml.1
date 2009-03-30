Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZC3VbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZC3VbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbZC3Va6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:30:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756983AbZC3Va5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:30:57 -0400
Date: Mon, 30 Mar 2009 14:26:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       balbir@linux.vnet.ibm.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, aviro@redhat.com
Subject: Re: [PATCH] make inotify event handles use GFP_NOFS
Message-Id: <20090330142610.4b94935d.akpm@linux-foundation.org>
In-Reply-To: <1237400852.26799.16.camel@localhost.localdomain>
References: <1237400852.26799.16.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 14:27:32 -0400
Eric Paris <eparis@redhat.com> wrote:

> I think this is a bandaide to shut up lockdep.  I could either figure
> out lockdep classes and figure out how to reclassify inotify locks since
> I believe Nick is correct when he says inotify watches pin the inode in
> core so memory pressure can't evict it.

It's pretty sad to degrading the strength of the memory allocation just
to squish a lockdep report.

>  I don't want to do that as I
> think the real fix is my next generation fsnotify which does zero
> allocations under locks and so everything can be GFP_KERNEL.

I assume that's the 13-patch series further down in my todo pile.

Perhaps this workaround is suitable for 2.6.29.x, or 2.6.30 if the
13-patch-series was too late.  But do we care enough?


>  I'm
> posting this as it is clearly safe and should fix the issue.
> 
> http://marc.info/?l=linux-kernel&m=123617147432377&w=2
> 
> includes a lockdep warning that shows while we are reclaiming FS memory
> and inode may get evicted which generates an IN_IGNORED message.  Half
> of that code path already used GFP_NOFS but a second allocation to store
> the filename was using GFP_KERNEL.  As a precaution I also moved the
> audit handle_event code path to use GFP_NOFS.
> 
> This is much the same as the precaution in f04b30de3c82528 which did
> something similar.
> 

