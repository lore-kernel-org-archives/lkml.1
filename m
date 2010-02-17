Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab0BQChn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:37:43 -0500
Received: from smtp-out.google.com ([216.239.33.17]:40087 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab0BQChm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:37:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HOtlfhQywI/Wh/V0fClWk53x9pbFvNPbBIHaennX3tuyHC0oJAziaaaJtP+hR2Azg
	JHjWnfxKLEgZX5vwIgQ4Q==
Date: Tue, 16 Feb 2010 18:37:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100217112353.b90f732a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161833360.20350@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
 <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com> <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
 <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com> <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com> <20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com> <20100217112353.b90f732a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> And basically. memcg's oom means "the usage over the limits!!" and does
> never means "resouce is exhausted!!".
> 
> Then, marking OOM to zones sounds strange. You can cause oom in 64MB memcg
> in 64GB system.
> 

ZONE_OOM_LOCKED is taken system-wide because the result of a memcg oom is 
that a task will get killed and free memory, so VM_FAULT_OOM doesn't 
require any additional killing if we're oom, it should just retry after 
the task has exited.  If we remove the zone locking for memcg, it is 
possible that pagefaults will race with setting TIF_MEMDIE and two tasks 
get killed instead.  I guess that's acceptable considering its just as 
likely that the memcg will reallocate to the same limit again and cause 
VM_FAULT_OOM to rekill.
