Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZKRGRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZKRGRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 01:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZKRGRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 01:17:52 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35309 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZKRGRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 01:17:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com
Subject: Re: [PATCH 1/7] dm: use __GFP_HIGH instead PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20091117131527.GB6644@agk-dp.fab.redhat.com>
References: <20091117161616.3DD7.A69D9226@jp.fujitsu.com> <20091117131527.GB6644@agk-dp.fab.redhat.com>
Message-Id: <20091118145621.3E1A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 18 Nov 2009 15:17:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for give me comment.

> On Tue, Nov 17, 2009 at 04:17:07PM +0900, KOSAKI Motohiro wrote:
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> > memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
>  
> This code is also on the critical path, for example, if you are swapping
> onto a dm device.  (There are ways we could reduce its use further as
> not every dm ioctl needs to be on the critical path and the buffer size
> could be limited for the ioctls that do.)

May I ask one additional question?
Original code is here.

	-------------------------------------------------------
        /*
         * Trying to avoid low memory issues when a device is
         * suspended.
         */
        current->flags |= PF_MEMALLOC;

        /*
         * Copy the parameters into kernel space.
         */
        r = copy_params(user, &param);

        current->flags &= ~PF_MEMALLOC;
	-------------------------------------------------------

but PF_MEMALLOC doesn't gurantee allocation successfull. In your case,
mempoll seems better to me. copy_params seems enough small function 
and we can rewrite it. Why didn't you use mempool?

Am I missing something?


> But what situations have been causing you trouble?  The OOM killer must
> generally avoid killing userspace processes that suspend & resume dm
> devices, and there are tight restrictions on what those processes
> can do safely between suspending and resuming.

No. This is theorical issue. but I really want to avoid stress weakness
kernel.





