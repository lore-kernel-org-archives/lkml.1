Return-Path: <linux-kernel-owner+w=401wt.eu-S1030895AbXDPTUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030895AbXDPTUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030901AbXDPTUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:20:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030895AbXDPTUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:20:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Czh8UVfqYtjCz0xXrNtP3y0ggtAimA5s60JEyAL1qyW8sQAKsDDIQ57FEj3IDEjgk
	d3K5MxK+3PqMtgDCMUcNA==
Date: Mon, 16 Apr 2007 12:20:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hugh@veritas.com>
cc: Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
In-Reply-To: <Pine.LNX.4.64.0704161956510.13584@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704161217310.12685@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
 <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
 <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
 <461FEF1C.5010806@vmware.com> <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704161139020.12097@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0704161956510.13584@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Hugh Dickins wrote:

> > > Compromise patch below: would that be satisfactory to you, David?
> > 
> > I really like the patch, but for perhaps a slightly different reason: 
> > we're only flushing ranges that have been shown to need it.  We aren't 
> > completely flushing the entire mm which is likely to be excessive in 
> > situations where we're actually using /proc/pid/clear_refs in combination 
> > with /proc/pid/smaps for memory footprint approximation (i.e. it's on a 
> > fine granularity).
> 
> It would be more of a reason to like the patch, if more architectures
> actually implemented flush_tlb_range as anything different from
> flush_tlb_mm ;)  Sadly, few can do better than flush_tlb_mm: ia64
> is the exception I remember, and maybe a couple of others.  I put
> flush_tlb_range there merely because it seems more appropriate,
> but it's rather deceptive.
> 

Sure, but what I really like about the patch is that we're only flushing 
something if !flush_end in the first place.  So we can eliminate any TLB 
flushing if that VMA didn't need it; that's a change from the current 
behavior.  And since the most obvious use-case for /proc/pid/clear_refs is 
in conjunction with /proc/pid/smaps for approximating memory footprint, 
we'll end up saving TLB flushes because the granularity with which that 
measurement is taken is usually very fine.

Acked-by: David Rientjes <rientjes@google.com>
