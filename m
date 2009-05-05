Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZEESaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZEESaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZEESaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:30:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9993 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZEESaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:30:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MP9TThD58zYs3xyMxexQ2RFwRTffdyqBcw11isL4jkMem74JZ1wkK6a5OqxMaEcXM
	OEapQIAnI/MaC3aDdcUTQ==
Date: Tue, 5 May 2009 11:29:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] oom: move oom_adj value from task_struct to
 mm_struct
In-Reply-To: <20090505101834.GB28917@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0905051104060.26060@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com> <alpine.DEB.2.00.0905041725590.11756@chino.kir.corp.google.com> <20090505101834.GB28917@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Nick Piggin wrote:

> Hmm, not particularly bad to do any of this, but I guess the way to
> do it without changing userspace APIs would be to take the lowest
> value of oomkilladj for any thread in the mm and use that.
> 

Then /proc/pid/oom_adj (and, thus, what /proc/pid/oom_score reports) will 
be inconsistent.  In other words, it would be possible for a task to have 
an oom_adj value of +15, meaning to prefer killing it above all others, 
and it turns out to be immune from oom killing because it shares memory 
with an OOM_DISABLE task.  You could argue that's broken in userspace, but 
this patchset actually makes oom_adj values a trait of the memory it 
represents rather than the task itself so not only is it consistent but it 
doesn't cause any surprises when your system (or memcg or cpuset) is oom.

Taking the lowest oom_adj value would also require more than one expensive 
tasklist scan or an internal oom killer stack of eligible tasks to kill so 
we can pop a task that shares ineligible memory and still kill a task that 
has a higher priority as defined by the user.

> I guess the previous behaviour was basically quite random anyway if
> multiple threads each have different oomkilladj variables so it
> probably doesn't matter.
> 

Exactly, and this is what the patchset addresses: oom_adj values become a 
trait of the memory it describes and not tasks that may happen to share 
it.  It also fixes a livelock if the highest priority task actually can't 
be killed because it shares memory with an OOM_DISABLE task.

> I don't suppose you'd ever get a significantly advanced (aka crazy)
> userspace app that would want to deliberately set *one* of its threads
> as OOM_DISABLE and others allowed to be killed, would we?
> 

You could argue that's totally broken in userspace, but there's no reason 
for the kernel to not expose a consistent API that describes the actual 
oom priority.  oomkilladj really is inappropriate as a per task value.
