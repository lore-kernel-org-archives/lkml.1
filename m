Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbZEGSua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbZEGSua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZEGSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:50:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZEGSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:50:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MmZnR6BDJ8oNZQ0ByWZlQ27VDhTtyNwIDrdB1kap/4FmBlhpWZSXcyr5cJN3AXshn
	Gy/OJlstMZiGLXfo4hdcA==
Date: Thu, 7 May 2009 11:50:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905072009.53406.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905071147260.26631@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905060120.35698.rjw@sisk.pl> <20090505164028.e9d807a1.akpm@linux-foundation.org> <200905072009.53406.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Rafael J. Wysocki wrote:

> Unfortunately it fails too quickly with the combination as well, so it looks
> like we can't use __GFP_NORETRY during hibernation.
> 

If you know that no other tasks are in the oom killer at suspend time, you 
can do what I mentioned earlier:

	struct zone *z;
	for_each_populated_zone(z)
		zone_set_flag(z, ZONE_OOM_LOCKED);

and then later

	for_each_populated_zone(z)
		zone_clear_flag(z, ZONE_OOM_LOCKED);

The only race there is if a task is currently in the oom killer and will 
subsequently clear ZONE_OOM_LOCKED for its zonelist.
