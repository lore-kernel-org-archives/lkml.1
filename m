Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYLKBGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYLKBGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYLKBGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:06:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49285 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLKBF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:05:59 -0500
Date: Thu, 11 Dec 2008 10:05:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory 
 controller
Message-Id: <20081211100501.bf538f0c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com>
References: <20081210233654.563182000@menage.corp.google.com>
	<20081210234432.236302000@menage.corp.google.com>
	<20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 16:52:57 -0800
Paul Menage <menage@google.com> wrote:

> On Wed, Dec 10, 2008 at 4:49 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> >        an operation like rmdir() in somewhere.
> >                hierarchy_lock for A (acquired)
> >                hierarchy_lock for B (waiting)
> >
> >        in subsys A.
> >                mmap_sem (acquired)
> >                hierarchy_lock for A (waiting)
> >        in subsys B.
> >                hierarchy_lock for B (aquired)
> >                mmap_sem             (waiting)
> >
> 
> That's a valid deadlock - you'd need to require the mmap_sem nests
> either inside all hierarchy_mutexes or else outside all of them.
> 
This was a found dead lock between memcg and cpuset.

another one was 

	an operation like rmdir() in somewhere.
		hierarchy_lock for memcg (acquired)
		hierarchy_lock for B (waiting)

	in subsys B.
		hierarchy_lock for B (aquired)
		have to do some memory reclaim -> hierarchy_lock for memcg (waiting)

I have no objections to hierarchy_lock itself but calling context to memcg is very
complicated and simple replace of these locks will be just a small help.

-Kame

