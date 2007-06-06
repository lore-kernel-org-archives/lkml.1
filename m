Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXFFBYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXFFBYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933451AbXFFBYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:24:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbXFFBYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:24:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=M9QQRkBO09cE23QRbGnupKlKsSMVGWIT2MgAC09mxiB8LawAOFBS7yIXgZrs4zRO1
	Jm5tf6lnmtAEZEFer+ZGA==
Date: Tue, 5 Jun 2007 18:23:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706051817380.23799@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Christoph Lameter wrote:

> Exclusive is not as absolute as you may think. There is also the 
> GFP_KERNEL exception.
> 

Memory exclusivity with respect to cpusets should guarantee that memory 
nodes do not overlap with siblings if they are marked with mems_exclusive.  
The patch simply preserves that behavior through the time period between 
when the OOM killer issues a SIGKILL and the task is exiting and marked 
with PF_EXITING.

Obviously GFP_KERNEL allocations can allocate regardless of our memory 
exclusivity, but the point is that a job in one exclusive cpuset should 
not have the ability to effect the performance (in terms of reclaim and 
swap), memory usage, or survival of jobs in other exclusive cpusets 
because it was out of memory.

> Processes stuck in D state is another issue with reliability.
> 

But it's a reality that we need to respect.  It happens and when it does
it has the potential to hamper other cpusets that we setup to be exclusive 
themselves.

		David
