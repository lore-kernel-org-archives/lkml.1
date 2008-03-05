Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbYCEVXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbYCEVXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYCEVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:23:04 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:58754 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYCEVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:23:03 -0500
Message-ID: <47CF0F1F.1080402@nortel.com>
Date: Wed, 05 Mar 2008 15:22:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Todd Tomaino <ttomaino@rivulet.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: E1000:   e1000_update_stats()
References: <67F3071335CB9945A6047FE06957E0240D6D94CE93@exchange.rivulet.com>
In-Reply-To: <67F3071335CB9945A6047FE06957E0240D6D94CE93@exchange.rivulet.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2008 21:22:42.0220 (UTC) FILETIME=[0BF58EC0:01C87F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Tomaino wrote:

> Reading the comments in the code it appeared that updating
> adapter->net_stats and adapter->stat required interrupts to be turned
> off to prevent the e1000_adjust_tbi_stats() function from modifying
> these structures from interrupt context.  In order to reduce the
> amount of time spent with interrupts disabled I separated the
> register reads from updating adapter->stat counters.  The register
> reads take up the bulk of the 57 usec and shouldn't require
> protection (I could be wrong).  The new operation looks like this and
> reduces the amount of time spent with interrupts turned off by 1/2:
> 
> 1. read registers 2. acquire spinlock 3. update adapter->stat
> counters 4. update OS adapter->net_stats statistics 5. update phy
> stats. 6. release spinlock.

One potential problem with this is that the stats can be further out of 
date.

Consider this case:

cpu0 reads some of the registers, then gets preempted/interrupted
cpu1 reads all the registers, updates the stats, then dumps the data


At this point cpu1 dumped information that doesn't include the registers 
that cpu0 was in the middle of updating.  Eventually cpu0 will run again 
and the stats will be accurate, but there is a window where the stats 
may be self-inconsistent and the various counts may not add up.

Chris

