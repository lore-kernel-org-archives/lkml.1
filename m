Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbXFEXpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbXFEXpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933456AbXFEXpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:45:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14927 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbXFEXpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:45:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ohRsEmsssdvVO8seU/u8qlteFWDqtZug58CJa0j5UOqm5y1JhGdXQGXEN98NPyCko
	r0/SkbKlPh/K0uIQXaAPA==
Date: Tue, 5 Jun 2007 16:44:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Christoph Lameter wrote:

> But with the patch the process would be able to terminate. There is no 
> global OOM situation. If there would be a global OOM situation then 
> TIF_MEMDIE would not help.
> 

Sure it would, it would have access to memory reserves because of the 
change in watermarks through get_page_from_freelist().

If that fails, we can't allocate elsewhere because then we have taken 
exclusive memory from other applications and is contrary to the definition 
of mem_exclusive.  You need to construct your cpuset hierarchy with these 
scenarios in mind; when you ask for an exclusive cpuset, it shouldn't come 
with a disclaimer that says "if another cpuset that is also exclusive 
happens to OOM, we'll steal your memory anyway and it's not our problem if 
the dying task gets stuck in D state and doesn't exit synchronously or 
reliably because all we did was send it a SIGKILL."

> So its seems that the patch is addressing an imagined situation?
> 

No, it's returning us to the previous logic where an exclusive cpuset was 
actually exclusive.

And, again, without this change it is possible to allocate in other 
exclusive cpusets without first exhausting your own memory reserves.  
That's wrong.

		David
