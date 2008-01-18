Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYARHhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYARHhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYARHh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:37:29 -0500
Received: from smtp-out.google.com ([216.239.33.17]:40833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYARHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:37:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:
	newsgroups:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=tRw3ZM6iaWkvOessRrmYjJT8TqGuWjJr5VtF61fWngAyB9zFY6rPnT7oCKbnSMgAP
	eSQPXay9GNz0IxaylayGA==
Message-ID: <4790570E.80709@google.com>
Date: Thu, 17 Jan 2008 23:36:46 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data
 structure
References: <20080115080921.70E3810653@localhost> <1200386774.15103.20.camel@twins> <532480950801150953g5a25f041ge1ad4eeb1b9bc04b@mail.gmail.com> <400452490.28636@ustc.edu.cn> <20080115194415.64ba95f2.akpm@linux-foundation.org> <400457571.32162@ustc.edu.cn> <20080115204236.6349ac48.akpm@linux-foundation.org> <400459376.04290@ustc.edu.cn> <20080115215149.a881efff.akpm@linux-foundation.org> <400474447.19383@ustc.edu.cn>
In-Reply-To: <400474447.19383@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu wrote:
> On Tue, Jan 15, 2008 at 09:51:49PM -0800, Andrew Morton wrote:
>> On Wed, 16 Jan 2008 12:55:07 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
>>
>>> On Tue, Jan 15, 2008 at 08:42:36PM -0800, Andrew Morton wrote:
>>>> On Wed, 16 Jan 2008 12:25:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
>>>>
>>>>> list_heads are OK if we use them for one and only function.
>>>> Not really.  They're inappropriate when you wish to remember your
>>>> position in the list while you dropped the lock (as we must do in
>>>> writeback).
>>>>
>>>> A data structure which permits us to interate across the search key rather
>>>> than across the actual storage locations is more appropriate.
>>> I totally agree with you. What I mean is to first do the split of
>>> functions - into three: ordering, starvation prevention, and blockade
>>> waiting.
>> Does "ordering" here refer to ordering bt time-of-first-dirty?
> 
> Ordering by dirtied_when or i_ino, either is OK.
> 
>> What is "blockade waiting"?
> 
> Some inodes/pages cannot be synced now for some reason and should be
> retried after a while.
> 
>>> Then to do better ordering by adopting radix tree(or rbtree
>>> if radix tree is not enough),
>> ordering of what?
> 
> Switch from time to location.
> 

Given the way LBAs are located on disk and the fact that rotational 
latency is a large factor in changing locations of a drive head, any 
attempts to do a C-SCAN pass are pretty much useless.  Further 
complicating this is any volume management that sits between the fs and 
the actual storage.

A nice feature to have longer term is to have the write_inodes paths for 
background flushing understand storage congestion _through_ any volume 
management. This would allow us to back off background flushing on a per 
spindle basis (when using drives of course) and avoid write congestion 
in both the io scheduler and in the drive's writecaches, which I 
believe, but don't have hard evidence, get congested today, knocking the 
drive into a fifo fashion in firmware.

A data structure that allows us to keep a dirtied_when values consistent 
across back-offs and blocking allows us to further develop the 
background writeout paths to get to this point (though exposing this 
congestion information will require more work deeper in the stack).

>>> and lastly get rid of the list_heads to
>>> avoid locking. Does it sound like a good path?
>> I'd have thaought that replacing list_heads with another data structure
>> would be a simgle commit.
> 
> That would be easy. s_more_io and s_more_io_wait can all be converted
> to radix trees.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

