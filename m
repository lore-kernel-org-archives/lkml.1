Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYKKSHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYKKSHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYKKSHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:07:25 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:43418 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYKKSHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:07:25 -0500
Date: Tue, 11 Nov 2008 13:07:15 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH -next] Hibernate: Take overlapping zones into account
In-reply-to: <200811081356.13060.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811111300580.4480@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200811081356.13060.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Nov 2008, Rafael J. Wysocki wrote:

> Hi Len,
> 
> Please add this patch to the suspend branch.

Please re-send a checkpatch clean version.

Also, the comments on this patch (and the next) are mal-formed.
The commit message must be before the first "---" and the throw-away
comments must be after it, rather thant the reverse.

I ask others to get this right, so it seems most fair that I do the
same for you -- otherwise your next patch will have the same problems
and others will follow your example of not sending the "perfect patch"

thanks,
-Len


> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Hibernate: Take overlapping zones into account
> 
> It has been requested to make hibernation work with memory
> hotplugging enabled and for this purpose the hibernation code has to
> be reworked to take the possible overlapping of zones into account.
> Thus, rework the hibernation memory bitmaps code to prevent
> duplication of PFNs from occuring and add checks to make sure that
> one page frame will not be marked as saveable many times.
> 
> Additionally, use list.h lists instead of open-coded lists to
> implement the memory bitmaps.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Andy Whitcroft <apw@shadowen.org>
> ---
>  kernel/power/snapshot.c |  331 ++++++++++++++++++++++++------------------------
>  1 file changed, 169 insertions(+), 162 deletions(-)
> 
> Index: linux-2.6/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/snapshot.c
> +++ linux-2.6/kernel/power/snapshot.c
> @@ -25,6 +25,7 @@
