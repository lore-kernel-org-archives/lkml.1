Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZJPEvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZJPEvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbZJPEvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:51:18 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:33637 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZJPEvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:51:18 -0400
Message-ID: <4AD7FB57.2030403@vflare.org>
Date: Fri, 16 Oct 2009 10:19:27 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hongshin@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] swap_info: swap count continuations
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils> <Pine.LNX.4.64.0910150153560.3291@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910150153560.3291@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 06:26 AM, Hugh Dickins wrote:
> Swap is duplicated (reference count incremented by one) whenever the same
> swap page is inserted into another mm (when forking finds a swap entry in
> place of a pte, or when reclaim unmaps a pte to insert the swap entry).
> 
> swap_info_struct's vmalloc'ed swap_map is the array of these reference
> counts: but what happens when the unsigned short (or unsigned char since
> the preceding patch) is full? (and its high bit is kept for a cache flag)
> 
> We then lose track of it, never freeing, leaving it in use until swapoff:
> at which point we _hope_ that a single pass will have found all instances,
> assume there are no more, and will lose user data if we're wrong.
> 
> Swapping of KSM pages has not yet been enabled; but it is implemented,
> and makes it very easy for a user to overflow the maximum swap count:
> possible with ordinary process pages, but unlikely, even when pid_max
> has been raised from PID_MAX_DEFAULT.
> 
> This patch implements swap count continuations: when the count overflows,
> a continuation page is allocated and linked to the original vmalloc'ed
> map page, and this used to hold the continuation counts for that entry
> and its neighbours.  These continuation pages are seldom referenced:
> the common paths all work on the original swap_map, only referring to
> a continuation page when the low "digit" of a count is incremented or
> decremented through SWAP_MAP_MAX.
> 


I think the patch can be simplified a lot if we have just 2 levels (hard-coded)
of swap_map, each level having 16-bit count -- combined 32-bit count should be
sufficient for about anything. Saving 1-byte for level-1 swap_map and then having
arbitrary levels of swap_map doesn't look like its worth the complexity.

Nitin

