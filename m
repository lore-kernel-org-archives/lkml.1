Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360Ab0A3Wxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0A3Wxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 17:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978Ab0A3Wxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 17:53:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0A3Wxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 17:53:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=s1r2HRxts0wVmqfWrqkWqvcknfBIr7zWbCkTzO1pBmzCgQyv5AI98EcX/sL5l7/5q
	DfjB5ZKibQeGGrEN0rxcw==
Date: Sat, 30 Jan 2010 14:53:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <4B642A40.1020709@gmail.com>
Message-ID: <alpine.DEB.2.00.1001301444480.16189@chino.kir.corp.google.com>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com> <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk> <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com> <20100129163030.1109ce78@lxorguk.ukuu.org.uk>
 <5a0e6098f900aa36993b2b7f2320f927.squirrel@webmail-b.css.fujitsu.com> <alpine.DEB.2.00.1001291258490.2938@chino.kir.corp.google.com> <4B642A40.1020709@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1001301445031.16189@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010, Vedran Furac wrote:

> > The oom killer has been doing this for years and I haven't noticed a huge 
> > surge in complaints about it killing X specifically because of that code 
> > in oom_kill_process().
> 
> Well you said it yourself, you won't see a surge because "oom killer has
> been doing this *for years*". So you'll have a more/less constant number
> of complains over the years. Just google for: linux, random, kill, memory;
> 

You snipped the code segment where I demonstrated that the selected task 
for oom kill is not necessarily the one chosen to die: if there is a child 
with disjoint memory that is killable, it will be selected instead.  If 
Xorg or sshd is being chosen for kill, then you should investigate why 
that is, but there is nothing random about how the oom killer chooses 
tasks to kill.

The facts that you're completely ignoring are that changing the heuristic 
baseline to rss is not going to prevent Xorg or sshd from being selected 
(in fact, I even showed that it makes Xorg _more_ preferrable when I 
reviewed the patch), and you have complete power of disabling oom killing 
for selected tasks and that trait is inheritable to children.

I agree that we can do a better job than needlessly killing innocent tasks 
when we have a lowmem oom.  I suggested killing current in such a scenario 
since ZONE_DMA memory was not reclaimable (and, soon, not migratable) and 
all memory is pinned for such purposes.  However, saying we need to change 
the baseline for that particular case and completely misinterpret the 
oom_adj values for all system-wide tasks is simply not an option.  And 
when that point is raised, it doesn't help for people to take their ball 
and go home if their motivation is to improve the oom killer.
