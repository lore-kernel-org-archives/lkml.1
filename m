Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbZLBFJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbZLBFJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZLBFJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:09:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZLBFJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:09:07 -0500
Message-ID: <4B15F642.1080308@redhat.com>
Date: Wed, 02 Dec 2009 00:08:18 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
References: <20091201181633.5C31.A69D9226@jp.fujitsu.com> <20091201093738.GL30235@random.random> <20091201184535.5C37.A69D9226@jp.fujitsu.com> <20091201095947.GM30235@random.random>
In-Reply-To: <20091201095947.GM30235@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 04:59 AM, Andrea Arcangeli wrote:
> On Tue, Dec 01, 2009 at 06:46:06PM +0900, KOSAKI Motohiro wrote:
>    
>> Ah, well. please wait a bit. I'm under reviewing Larry's patch. I don't
>> dislike your idea. last mail only pointed out implementation thing.
>>      
> Yep thanks for pointing it out. It's an implementation thing I don't
> like. The VM should not ever touch ptes when there's light VM pressure
> and plenty of unmapped clean cache available, but I'm ok if others
> disagree and want to keep it that way.
>    
The VM needs to touch a few (but only a few) PTEs in
that situation, to make sure that anonymous pages get
moved to the inactive anon list and get to a real chance
at being referenced before we try to evict anonymous
pages.

Without a small amount of pre-aging, we would end up
essentially doing FIFO replacement of anonymous memory,
which has been known to be disastrous to performance
for over 40 years now.

A two-handed clock mechanism needs to put some distance
between the front and the back hands of the clock.

Having said that - it may be beneficial to keep very heavily
shared pages on the active list, without ever trying to scan
the ptes associated with them.
