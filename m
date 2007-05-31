Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbXEaR7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbXEaR7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXEaR6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:58:55 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119AbXEaR6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:58:54 -0400
Date: Thu, 31 May 2007 10:58:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
Message-Id: <20070531105842.0728f577.akpm@linux-foundation.org>
In-Reply-To: <465EA4FF.1000904@openvz.org>
References: <465D9739.8070209@openvz.org>
	<465D9B62.5050507@openvz.org>
	<20070530144737.56456aaf.akpm@linux-foundation.org>
	<465EA4FF.1000904@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 14:35:43 +0400
Pavel Emelianov <xemul@openvz.org> wrote:

> > Would I be correct in guessing that pages which are on the
> > per-rss-container lists are also eligible for reclaim off the traditional
> > page LRUs?  If so, how does that work?  When a page gets freed off the
> 
> Yes. All the pages are accessible from booth - global and per-container
> LRU lists and reclamation can be performed from booth.
> 
> > per-zone LRUs does it also get removed from the per-rss_container LRU?  But
> > how can this be right?  
> 
> I don't get your idea here.

If we have a page which is on the zone LRU with refcount=1 and someone does
put_page() on it, we will take that page off the zone LRU and then actually
free the page.

I am assuming that your patches change that logic so that we will also
remove that page from the per-container LRU at the same time?

If so, the problem which I see is that, under rare circumstances, that
final put_page() will occur from interrupt context.  Hence we would be
trying to remove the page from the per-container LRU at interrupt time. 
But the locks which you have in there are not suited for taking from
interrupt context.

