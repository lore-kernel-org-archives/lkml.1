Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZHXWoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZHXWoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZHXWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:44:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37502 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZHXWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:44:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rO/eHfMGuVwJfmvdNF3+P053fVeMqTnljl0HMABXMbKC08kw7SYpfXd9Uv5VH6FFZ
	nWZU/pLsmzN5DhpHMY/BA==
Date: Mon, 24 Aug 2009 15:44:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <1251150156.22398.8289.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251150156.22398.8289.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Dave Hansen wrote:

> On Mon, 2009-08-24 at 13:41 -0700, David Rientjes wrote:
> > On the other hand, I'd have no problem trying to eliminate 
> > fa->total_nr_elements (since we already have fa->element_size) since we 
> > can calculate it in real-time; the only problem is being able to 
> > distinguish when the elements are being stored in struct flex_array vs. 
> > being stored in struct flex_array_part.
> 
> Yeah, that's the only reason it's there: to determine if we're using the
> compact form or not.  We could probably find another place to store
> that, or just store a flag telling whether we're using that form or not.
> We couldn't do the bounds-checking, but I'm OK with that.
> 

I'm starting to think that maybe an `unsigned int flags' is eventually 
going to need to be added anyway: one reason is to serve this purpose of 
identifying arrays that are stored in the base structure.  Another 
possible reason is to identify flex arrays that want the poison behavior 
to identify use-uninitialized and use-after-free and would be passed such 
as flex_array_alloc(size, total, FLEX_ARRAY_POISON, gfp) to isolate arrays 
that may, as you said, store elements of types other than void * or those 
significantly small enough that they would collide with the poison values 
at a higher probability.
