Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZEGUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZEGUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZEGUZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:25:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43864 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZEGUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:25:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uR72zBd00vZ+bc/g+HXmUOermRGEfD8mhsI6HEXtSKAcIZMWHKLhgR3FdwrbtyzeP
	lfYuoC6K9B0vZZKG3BfAA==
Date: Thu, 7 May 2009 13:25:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905072218.50782.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072133.48917.rjw@sisk.pl> <20090507130202.34cbe37a.akpm@linux-foundation.org> <200905072218.50782.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Rafael J. Wysocki wrote:

> OK, let's try with __GFP_NO_OOM_KILL first.  If there's too much disagreement,
> I'll use the freezer-based approach instead.
> 

Third time I'm going to suggest this, and I'd like a response on why it's 
not possible instead of being ignored.

All of your tasks are in D state other than kthreads, right?  That means 
they won't be in the oom killer (thus no zones are oom locked), so you can 
easily do this

	struct zone *z;
	for_each_populated_zone(z)
		zone_set_flag(z, ZONE_OOM_LOCKED);

and then

	for_each_populated_zone(z)
		zone_clear_flag(z, ZONE_OOM_LOCKED);

The serialization is done with trylocks so this will never invoke the oom 
killer because all zones in the allocator's zonelist will be oom locked.

Why does this not work for you?
