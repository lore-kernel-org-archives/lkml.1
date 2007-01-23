Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbXAWEga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbXAWEga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXAWEga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:36:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270AbXAWEga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:36:30 -0500
Message-ID: <45B59053.1060007@redhat.com>
Date: Mon, 22 Jan 2007 23:34:27 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: balbir@in.ibm.com, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <45B58C5C.8010900@yahoo.com.au>
In-Reply-To: <45B58C5C.8010900@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> The other nice thing about it was that it didn't have a hard
> cutoff that the current reclaim_mapped toggle does -- you could
> opt to scan the mapped list at a lower ratio than the unmapped
> one. Of course, it also has some downsides too, and would
> require retuning...

Here's a simple idea for tuning.

For each list we keep track of:
1) the size of the list
2) the rate at which we scan the list
3) the fraction of (non new) pages that get
    referenced

That way we can determine which list has the largest
fraction of "idle" pages sitting around and consequently
which list should be scanned more aggressively.

For each list we can calculate how frequently the pages
in the list are being used:

pressure = referenced percentage * scan rate / list size

The VM can equalize the pressure by scanning the list with
lower usage less than the other list.  This way the VM can
give the right amount of memory to each type.

Of course, each list needs to be divided into inactive and
active like the current VM, in order to make sure that the
pages which are used once cannot push the real working set
of that list out of memory.

There is a more subtle problem when the list's working set
is larger than the amount of memory the list has.  In that
situation the VM will be faulting pages back in just after
they got evicted.  Something like my /proc/refaults code
can detect that and adjust the size of the undersized list
accordingly.

Of course, once we properly distinguish between the more
frequently and less frequently accessed pages within each
of the page sets (mapped/anonymous vs. unmapped) and have
the pressure between the lists equalized, why do we need
to keep them separate again?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
