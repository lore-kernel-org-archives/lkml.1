Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbZEKV2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbZEKV2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbZEKV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:28:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbZEKV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:28:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FQYbj6AkAj+lyOwz3BX4f5ERWzLET0dSeVOVBgvjk9Ho2M+Aq4z8M8faX7TJlrywH
	jq+IH4KrYxHLwGCeE0Mzg==
Date: Mon, 11 May 2009 14:28:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.ziljstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11 -mmotm] oom: fix possible oom_dump_tasks NULL
 pointer
In-Reply-To: <20090511141138.3e8118ab.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905111418560.466@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com> <20090511141138.3e8118ab.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> On Sun, 10 May 2009 15:07:16 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
> > pointer for tasks that have detached mm's since task_lock() is not held
> > during the tasklist scan.
> 
> ok.  But a better changelog would have told us how the patch fixes the
> problem?
> 

Sure, I suppose "Add the task_lock()." could follow it.

> This patch series is partially core MM and partially drivers/staging. 
> I don't normally handle staging things, so I'd need to be cherrypicking
> from this lot.  Is there any interdependency between the two things?
> 

This was a source of confusion from me when I posted a smaller set earlier 
that made the same changes to the staging driver, and the only reason I 
sent the change here was because drivers/staging/android/lowmemorykiller.c 
is in Linus' tree.

This patch series moves oomkilladj from struct task_struct to struct 
mm_struct where it more appropriately belongs.  The Android 
lowmemorykiller uses oomkilladj, so it will fail to compile in Linus' git 
if you pushed the patchset to him and the Android driver were enabled.

To prevent that breakage, they should probably either all go through one 
series so nothing ever breaks or Greg takes the staging patches and then 
pushes them when you push the other changes.  I thought the former would 
be easier for the maintainers (apparently not :).

I'd be fine with seperating the staging changes out, sending them to Greg, 
and then just assuming that it'll all work out in the end.
