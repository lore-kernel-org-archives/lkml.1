Return-Path: <linux-kernel-owner+w=401wt.eu-S2992685AbXDRUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992685AbXDRUxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992688AbXDRUxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:53:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992685AbXDRUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:53:35 -0400
Message-ID: <46268519.7080702@redhat.com>
Date: Wed, 18 Apr 2007 16:52:41 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: =?UTF-8?B?IuCkheCkreCkv+CknOCkv+CkpCDgpK3gpYvgpKrgpJ/gpJXgpLAgKEFiaGlq?=
	 =?UTF-8?B?aXQgQmhvcGF0a2FyKSI=?= <bainonline@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, akpm@osdl.org, jgarzik@pobox.com
Subject: Re: [PATCH] [RFC] Throttle swappiness for interactive tasks
References: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>
In-Reply-To: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

अभिजित भोपटकर (Abhijit Bhopatkar) wrote:
> The mm structures of interactive tasks are marked and
> the pages belonging to them are never shifted to inactive
> list in lru algorithm. Thus keeping interactive tasks in
> memory as long as possible.
> The interactivity is already determined by schedular so
> we reuse that knowledge to mark the mm structures.

Aside from the obvious question of whether the idea is good,
there are some practical problems with your patch:

1) the mm->interactive flag is never cleared, even if the
    task stops being interactive

2) what if the interactive tasks use up more memory than
    the system has?  Will you OOM kill instead of swapping
    out part of an interactive task?

3) the scheduler can change its idea about which task is
    interactive and which task isn't very rapidly, while
    disk IO is very slow - the scheduler's classification
    may not be useful on swap timescales

4) a currently completely idle task can still be marked
    interactive in the scheduler, even if it has been
    idle for days.  Such a task is an obvious good
    candidate for swapout, isn't it?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
