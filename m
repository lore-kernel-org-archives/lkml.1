Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZAUUve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZAUUve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZAUUvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:51:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZAUUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:51:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=tOzWujhAKY07IxXtBVCbVw/GkHqYcGiu53jXFY2VvdmCHLWBSeyUgnBxtkTSXcpgL
	wp8DCpcT7bZjDv+Urb1rg==
Date: Wed, 21 Jan 2009 12:49:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901212054.34929.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <20090121131739.GB4997@ioremap.net> <200901212054.34929.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.141
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009, Nikanth Karthikesan wrote:

> This is a container group based approach to override the oom killer selection 
> without losing all the benefits of the current oom killer heuristics and 
> oom_adj interface.
> 
> It adds a tunable oom.victim to the oom cgroup. The oom killer will kill the 
> process using the usual badness value but only within the cgroup with the 
> maximum value for oom.victim before killing any process from a cgroup with a 
> lesser oom.victim number. Oom killing could be disabled by setting 
> oom.victim=0.
> 

This doesn't help in memcg or cpuset constrained oom conditions, which 
still go through select_bad_process().

If the oom.victim value is high for a specific cgroup and a memory 
controller oom occurs in a disjoint cgroup, for example, it's possible to 
needlessly kill tasks.  Obviously that is up to the administrator to 
configure, but may not be his or her desire for system-wide oom 
conditions.

It may be preferred to kill tasks in a specific cgroup first when the 
entire system is out of memory or kill tasks within a cgroup attached to a 
memory controller when it is oom.

The same scenario applies for cpuset-constrained ooms.  Since oom.victim 
is given higher preference than all tasks' oom_adj values, it is possible 
to needlessly kill tasks that do not lead to future memory freeing for the 
nodes attached to that cpuset.

It also requires that you synchronize the oom.victim values amongst your 
cgroups.
