Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab0BJWb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:31:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab0BJWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:31:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nf9pm8HxHfFyabgjDUy4DlYSwQGWTfiqWg0AdfYF3Mz+ZLbRfba6cqG8vYh3na+T/
	u6sjVM4BHzBDlgU7CBOiw==
Date: Wed, 10 Feb 2010 14:31:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Rik van Riel <riel@redhat.com>, Lubos Lunak <l.lunak@suse.cz>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <20100210221847.5d7bb3cb@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1002101427490.29718@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <4B6B4500.3010603@redhat.com> <alpine.DEB.2.00.1002041410300.16391@chino.kir.corp.google.com> <201002102154.43231.l.lunak@suse.cz> <4B7320BF.2020800@redhat.com> <20100210221847.5d7bb3cb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Alan Cox wrote:

> One of the problems with picking on tasks that fork a lot is that
> describes apache perfectly. So a high loaded apache will get shot over a
> rapid memory eating cgi script.
> 

With my rewrite, the oom killer would not select apache but rather the 
child with a seperate address space that is consuming the most amount of 
allowed memory and only when a configurable number of such children (1000 
by default) have not had any runtime.  My heuristic is only meant to 
slightly penalize such tasks so that they can be distinguished from oom 
kill from other parents with comparable memory usage.  Enforcing a strict 
forkbomb policy is out of the scope of the oom killer, though, so no 
attempt was made.

> Any heuristic is going to be iffy - but that isn't IMHO a good one to
> work from. If anything "who allocated lots of RAM recently" may be a
> better guide but we don't keep stats for that.
> 

That's what my heuristic basically does, if a parent is identified as a 
forkbomb, then it is only penalized by averaging the memory consumption of 
those children and then multiplying it by the same number of times the 
configurable forkbomb threshold was reached.
