Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbXAWDpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbXAWDpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXAWDpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:45:52 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:65275 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbXAWDpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:45:51 -0500
Message-ID: <45B584E7.30407@in.ibm.com>
Date: Tue, 23 Jan 2007 09:15:43 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com> <45B57E73.3000307@in.ibm.com> <Pine.LNX.4.64.0701221923300.30667@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701221923300.30667@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 23 Jan 2007, Balbir Singh wrote:
> 
>> When you unmap or map, you need to touch the pte entries and know the
>> pages involved, so shouldn't be equivalent to a list_del and list_add
>> for each page impacted by the map/unmap operation?
> 
> When you unmap and map you must currently get exclusive access to the
> cachelines of the pte and the cacheline of the page struct. If we use a
> list_move on page->lru then we have would have to update pointers in up
> to 4 other page structs. Thus we need exclusive access to 4 additional
> cachelines. This triples the number of cachelines touched. Instead of 2
> cachelines we need 6.
> 
> 

Yes, good point, I see what you mean in terms of impact. But the trade
off could come from shrink_active_list() which does

list_del(&page->lru)
if (!reclaim_mapped && other_conditions)
	list_add(&page->lru, &l_active);
...

In the case mentioned above, we would triple the cachlines when an area
is mapped/unmapped (which might be acceptable since it is a state change
for the page ;) ). In the trade-off I mentioned, it would happen
everytime reclaim is invoked and it has nothing to do with a page changing
state.

Did I miss something?

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
