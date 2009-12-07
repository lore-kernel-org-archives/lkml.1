Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbZLGSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbZLGSUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZLGSUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbZLGSUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:20:41 -0500
Message-ID: <4B1D46C0.4040503@redhat.com>
Date: Mon, 07 Dec 2009 13:17:36 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Increased Buffers due to patch 56e49d (vmscan: evict use-once
 pages first), but why exactly?
References: <4B1D12E7.4070701@linux.vnet.ibm.com>
In-Reply-To: <4B1D12E7.4070701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 09:36 AM, Christian Ehrhardt wrote:
> Hi,
> commit 56e49d - "vmscan: evict use-once pages first" changed behavior of
> memory management quite a bit which should be fine.
> But while tracking down a performance regression I was on the wrong path
> for a while suspecting this patch is causing the regression.
> Fortunately this was not the case, but I got some interesting data which
> I couldn't explain completely and I thought maybe its worth to get it
> clarified publicly in case someone else looks at similar data again :-)
>
> All is about the increased amount of "Buffers" accounted as active while
> loosing the same portion from "Cache" accounted as inactive in
> /proc/meminfo.
> I understand that with the patch applied there will be some more
> pressure to file pages until the balance of active/inactive file pages
> is reached.
> But I didn't get how this prefers buffers compared to cache pages (I
> assume dropping inactive before active was the case all the time so that
> can't be the only difference between buffers/cache).

Well, "Buffers" is the same kind of memory as "Cached", with
the only difference being that "Cached" is associated with
files, while "Buffers" is associated with a block device.

This means that "Buffers" is more likely to contain filesystem
metadata, while "Cached" is more likely to contain file data.

Not putting pressure on the active file list if there are a
large number of inactive file pages means that pages which were
accessed more than once get protected more from pages that were
only accessed once.

My guess is that "Buffers" is larger because the VM now caches
more (frequently used) filesystem metadata, at the expense of
caching less (used once) file data.

> The scenario I'm running is a low memory system (256M total), that does
> sequential I/O with parallel iozone processes.

This indeed sounds like the kind of workload that would only
access the file data very infrequently, while accessing the
filesystem metadata all the time.

> But I can't really see in the code where buffers are favored in
> comparison to cached pages - (it very probably makes sense to do so, as
> they might contain e.g. the inode data about the files in cache).

You are right that the code does not favor Buffers or Cache
over the other, but treats both kinds of pages the same.

I believe that you are just seeing the effect of code that
better protects the frequently accessed metadata from the
infrequently accessed data.

-- 
All rights reversed.
