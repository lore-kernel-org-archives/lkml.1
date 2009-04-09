Return-Path: <linux-kernel-owner+w=401wt.eu-S936145AbZDIQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145AbZDIQwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZDIQvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:51:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:34578 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbZDIQvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:51:53 -0400
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	 <1239292496.7647.607.camel@twins>
	 <20090409181404.71ac2988@osiris.boeblingen.de.ibm.com>
	 <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Apr 2009 18:53:51 +0200
Message-Id: <1239296031.21985.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 18:48 +0200, Heiko Carstens wrote:
> Updated Patch below:
> 
> Subject: [PATCH] mutex: have non-spinning mutexes on s390 by default
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> The adaptive spinning mutexes will not always do what one would expect on
> virtualized architectures like s390. Especially the cpu_relax() loop in
> mutex_spin_on_owner might hurt if the mutex holding cpu has been scheduled
> away by the hypervisor.
> We would end up in a cpu_relax() loop when there is no chance that the
> state of the mutex changes until the target cpu has been scheduled again by
> the hypervisor.
> For that reason we should change the default behaviour to no-spin on s390.
> 
> We do have an instruction which allows to yield the current cpu in favour of
> a different target cpu. Also we have an instruction which allows us to figure
> out if the target cpu is physically backed.
> 
> However we need to do some performance tests until we can come up with
> a solution that will do the right thing on s390.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I was looking at how an monitor-wait could be used here, but that
appears non-trivial, there's two variables we're watching, lock->owner
and rq->curr, either could change.

Reducing that to 1 seems an interesting problem :-)
