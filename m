Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZDXTAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZDXTAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZDXTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:00:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZDXTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:00:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nmWGjv/9FQJ+8Qk3ZERey3c8D1s6HBkHtYUCjvKq0Kux5vTejDloOAnqM61LaK4SW
	Q5BtHqKK06PeylkrM4rhA==
Date: Fri, 24 Apr 2009 12:00:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zeno Davatz <zdavatz@gmail.com>
cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
In-Reply-To: <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com> <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com> <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Zeno Davatz wrote:

> Apr 24 09:01:06 thinpower [1349923.693331] Out of memory: kill process
> 21490 (apache2) score 53801 or a child
> Apr 24 09:01:06 thinpower [1349923.693410] Killed process 21490 (apache2)
> 

If your machine hangs here, then it's most likely because apache2 is 
getting stuck in D state and cannot exit (and it has access to memory 
reserves because of TIF_MEMDIE since it has been oom killed, so it may 
deplete all memory).

I'm assuming that you're describing a machine hang as the inability to 
ping it or ssh into it, not simply your apache server dying.

These types of livelocks are possible with the oom killer when a task 
fails to exit, one possible way to fix that is to introduce an oom killer 
timeout such that if a task fails to exit for a pre-defined period of 
time, the oom killer will choose to kill another task in the hopes of 
future memory freeing.  The problem with that approach, however, is that 
the hung task can consume an enormous amount of memory that will never be 
freed.

> > If this is reproducible, I'd recommend enabling
> > /proc/sys/vm/oom_dump_tasks so that the oom killer will dump the tasklist
> > and show us what may be causing the livelock.
> 
> Ok, how do I enable that? I will google for it.
> 

You're right in your reply, you can enable it with

	echo 1 > /proc/sys/vm/oom_dump_tasks

This will print the tasklist and some pertinent information alongside the 
oom killer output you've already posted.  It will give a better idea of 
the memory usage on the machine and if killing a subsequent task would 
actually help in this case.
