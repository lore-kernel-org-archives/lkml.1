Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZKBUx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZKBUx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbZKBUxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:53:55 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbZKBUxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:53:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=S4ofM/E+dpcUUKcfOUIO/yqfwNX2avlJZ+X8VdDPZFj3sHLrheNg5nNu+gTz31xX0
	12jrpcka3Pmmybk4cYDlg==
Date: Mon, 2 Nov 2009 12:53:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
In-Reply-To: <alpine.DEB.1.10.0911021139100.24535@V090114053VZO-1>
Message-ID: <alpine.DEB.2.00.0911021249470.22525@chino.kir.corp.google.com>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com> <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com> <20091031201158.GB29536@elf.ucw.cz> <4AECCF6A.4020206@redhat.com> <alpine.DEB.1.10.0911021139100.24535@V090114053VZO-1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Christoph Lameter wrote:

> What is realtime in this scenario? There are no guarantees that reclaim
> wont have to occur. There are no guarantees anymore and therefore you
> cannot really call this realtime.
> 

Realtime in this scenario is anything with a priority of MAX_RT_PRIO or 
lower.

> Is realtime anything more than: "I want to have my patches merged"?
> 

These allocations are not using ~__GFP_WAIT for a reason, they can block 
on direct reclaim.

But we're convoluting this issue _way_ more than it needs to be.  We have 
used ALLOC_HARDER for these tasks as a convenience for over four years.  
The fix here is to address an omittion in the page allocator refactoring 
code that went into 2.6.31 that dropped the check for !in_interrupt().

If you'd like to raise the concern about the rt exemption being given 
ALLOC_HARDER, then it is seperate from this fix.
