Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZHTW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZHTW4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZHTW4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:56:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZHTW4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:56:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FHrP+mf0cvaNk/vPRbt1mxS6cOQsulOJ0CV5NWz76hgC8K7X6iF4UjCnWi+SEEyuD
	KPJ1iS8OdrcFAlZ9AbLJA==
Date: Thu, 20 Aug 2009 15:56:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jonathan Corbet <corbet@lwn.net>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       bblum@andrew.cmu.edu, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
In-Reply-To: <20090820163510.27942b62@bike.lwn.net>
Message-ID: <alpine.DEB.2.00.0908201542440.29906@chino.kir.corp.google.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com> <20090820141400.f6d3d5a6.akpm@linux-foundation.org> <20090820163510.27942b62@bike.lwn.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Jonathan Corbet wrote:

> On Thu, 20 Aug 2009 14:14:00 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Hang on.  Isn't this why Dave just wrote and I just rush-merged
> > lib/flex_array.c?
> > 
> > Was that code evaluated for this application and judged unsuitable?  If so,
> > for what reason?
> 
> Should it be helpful: I wrote an overview of the flex_array API here:
> 
> 	http://lwn.net/Articles/345273/
> 
> I could format it up for addition to Documentation/ if people want.
> 

It's definitely helpful for this use case, flex array can store 261,632 
pid_t's on 64 bit.

Instead of reallocating new memory when the pidlist becomes smaller, it 
would then be sufficient to simply shrink the flex array by freeing parts 
members that are newly unused (which also avoids the oom possibility in 
pidlist_resize()).

flex_array_shrink(struct flex_array *) would require element poisoning 
when an element is cleared, but that's probably not far off anyways 
because it has additional advantages such as preventing flex_array_get() 
on an element that has not been put.
