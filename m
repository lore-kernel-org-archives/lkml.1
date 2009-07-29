Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZG2DeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZG2DeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 23:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZG2DeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 23:34:02 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36978 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbZG2DeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 23:34:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Jul 2009 12:32:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mike Smith <scgtrp@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 13850] New: reading /proc/kcore causes oops
Message-Id: <20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 22:46:56 -0400
Mike Smith <scgtrp@gmail.com> wrote:

> > What's layout of memory does your server have ?
> The log I gave was from my desktop, so I'll assume you wanted that
> instead of the server:
> [mike: mike in ~]$ grep "System RAM" /proc/iomem
> 00010000-0009efff : System RAM
> 00100000-1dedffff : System RAM
> 
>From this, your kernel's valid direct-map address range will be

c0010000-c009efff
c0100000-ddedffff

And, 
==
unable to handle kernel paging request at e07cf000
==
e07cf000 doesn't exist in direct map. It seems this is vmalloc() area.

At looking into mm/vmalloc.c, this area is unmapped under
- purge_lock
But proc/kcore just access this just under vmlist_lock.

No guards at all. This is _a_ problem. But it seems race is not
reproducable easily. I'll think more but is it guaranteed whether
vmalloc area(struct vm_struct) linked to vmlist has always valid pages ?
Considering get_vm_area(), it's not true I think.

I wonder fs/proc/kcore.c's vmalloc area access needs some fix. let me try.

Thanks,
-Kame





