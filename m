Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZHXUl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZHXUl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZHXUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:41:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZHXUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:41:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sVpMUEQMe71+yzlyhAv+66/XenmRQvgAsdOwTjUq/KJAF1uz6nZfkpSQLZ3Cx6ajI
	zDBIQkZ0gMoq0T8W+eF2Q==
Date: Mon, 24 Aug 2009 13:41:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <1251129384.22398.7166.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Dave Hansen wrote:

> > diff --git a/include/linux/poison.h b/include/linux/poison.h
> > --- a/include/linux/poison.h
> > +++ b/include/linux/poison.h
> > @@ -65,6 +65,9 @@
> >  #define MUTEX_DEBUG_INIT       0x11
> >  #define MUTEX_DEBUG_FREE       0x22
> > 
> > +/********** lib/flex_array.c **********/
> > +#define FLEX_ARRAY_FREE        0x6c    /* for use-after-free poisoning */
> 
> This seems like a good idea, but perhaps we should pick a non-ASCII
> character as the poison value.  If someone ever tried to store strings
> as one-byte elements, they'd be in for a rude awakening the first time
> they store an 'l'.
> 

I wasn't aware that storing an array of ASCII characters was a use case 
for flex array, I'm having a hard type imagining such a user.  We're 
always going to have the possibility of conflict with the poison value 
just from allowing eight byte element sizes, yet that possibility is still 
going to exist if we disabled it on smaller elements and re-defined 
FLEX_ARRAY_FREE as 0x6c6c, for example; the only thing that we've done is 
eliminated the possibility of flex_array_shrink() for arrays consisting of 
smaller elements.  FLEX_ARRAY_FREE (or an additional poison value to 
distinguish between use-uninitialized vs. use-after-free) must be used in 
flex_array_clear() otherwise the cgroup patchset, the only proposed user 
of this library code, could never shrink this array when pid's are free 
like the kmalloc vs. vmalloc patchset could do.

On the other hand, I'd have no problem trying to eliminate 
fa->total_nr_elements (since we already have fa->element_size) since we 
can calculate it in real-time; the only problem is being able to 
distinguish when the elements are being stored in struct flex_array vs. 
being stored in struct flex_array_part.  We could then use that
unsigned int in struct flex_array to store the number of inuse elements 
which is an alternative implementation to flex_array_shrink(), yet I'd 
still propose to keep the poisoning to reveal use-uninitialized.
