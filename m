Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZLOEyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZLOEyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZLOEyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:54:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:23939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZLOEyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:54:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kYFSjaEIWrtyPRF2m+rxOp16hdqWmDgseau43ea9oIWatKkBAErisxCLC52AXx6x1
	jwtaAq1yPRn1tSIjUdlGw==
Date: Mon, 14 Dec 2009 20:54:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v4.2
In-Reply-To: <20091215133546.6872fc4f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912142046070.436@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com> <20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com> <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com> <20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com>
 <20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com> <20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com>
 <20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911171609370.12532@chino.kir.corp.google.com> <20091118095824.076c211f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911171725050.13760@chino.kir.corp.google.com>
 <20091214171632.0b34d833.akpm@linux-foundation.org> <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com> <20091215133546.6872fc4f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:

> > I would agree only if the oom killer used total_vm as a the default, it is 
> > long-standing and allows for the aforementioned capability that you lose 
> > with rss.  I have no problem with the added sysctl to use rss as the 
> > baseline when enabled.
> > 
> I'll prepare a patch for adds
> 
>   sysctl_oom_kill_based_on_rss (default=0)
> 
> ok ?
> 

I have no strong feelings either for or against that, I guess users who 
want to always kill the biggest memory hogger even when single page 
__GFP_WAIT allocations fail could use it.  I'm not sure it would get much 
use, though.

I think we should methodically work out an oom killer badness rewrite that 
won't compound the problem by adding more and more userspace knobs.  In 
other words, we should slow down, construct a list of goals that we want 
to achieve, and then see what type of solution we can create.

A few requirements that I have:

 - we must be able to define when a task is a memory hogger; this is
   currently done by /proc/pid/oom_adj relying on the overall total_vm
   size of the task as a baseline.  Most users should have a good sense
   of when their task is using more memory than expected and killing a
   memory leaker should always be the optimal oom killer result.  A better 
   set of units other than a shift on total_vm would be helpful, though.

 - we must prefer tasks that run on a cpuset or mempolicy's nodes if the 
   oom condition is constrained by that cpuset or mempolicy and its not a
   system-wide issue.

 - we must be able to polarize the badness heuristic to always select a
   particular task is if its very low priority or disable oom killing for
   a task if its must-run.

The proposal may be to remove /proc/pid/oom_adj completely since I know 
both you and KOSAKI-san dislike it, but we'd need an alternative which 
keeps the above functionality intact.
