Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0BPJCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:02:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0BPJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:02:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IlPM4kGzlotN1zUAkcRRzjrErErX6EAHfH01bcZt4br2LSwHFcUbcFR+Ku8PT0agb
	3YCNIWaOkoU2iigI3HqUw==
Date: Tue, 16 Feb 2010 01:02:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
 <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > You don't understand that the behavior has changed ever since 
> > mempolicy-constrained oom conditions are now affected by a compulsory 
> > panic_on_oom mode, please see the patch description.  It's absolutely 
> > insane for a single sysctl mode to panic the machine anytime a cpuset or 
> > mempolicy runs out of memory and is more prone to user error from setting 
> > it without fully understanding the ramifications than any use it will ever 
> > do.  The kernel already provides a mechanism for doing this, OOM_DISABLE.  
> > if you want your cpuset or mempolicy to risk panicking the machine, set 
> > all tasks that share its mems or nodes, respectively, to OOM_DISABLE.  
> > This is no different from the memory controller being immune to such 
> > panic_on_oom conditions, stop believing that it is the only mechanism used 
> > in the kernel to do memory isolation.
> > 
> You don't explain why "we _have to_ remove API which is used"
> 

First, I'm not stating that we _have_ to remove anything, this is a patch 
proposal that is open for review.

Second, I believe we _should_ remove panic_on_oom == 2 because it's no 
longer being used as it was documented: as we've increased the exposure of 
the oom killer (memory controller, pagefault ooms, now mempolicy tasklist 
scanning), we constantly have to re-evaluate the semantics of this option 
while a well-understood tunable with a long history, OOM_DISABLE, already 
does the equivalent.  The downside of getting this wrong is that the 
machine panics when it shouldn't have because of an unintended consequence 
of the mode being enabled (a mempolicy ooms, for example, that was created 
by the user).  When reconsidering its semantics, I'd personally opt on the 
safe side and make sure the machine doesn't panic unnecessarily and 
instead require users to use OOM_DISABLE for tasks they do not want to be 
oom killed.
