Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbZIHW0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbZIHW0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZIHW0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:26:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZIHW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:26:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YUTAxsPUiT1DxCBRuOuCMfmED3P7YPsUqaMV1mv+8iAT0GxPorbFnGspxtnX4EZHh
	oCvUci8dNfmQ7cZIcLaYA==
Date: Tue, 8 Sep 2009 15:26:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, David Rientjes wrote:

> I'm starting to think that maybe an `unsigned int flags' is eventually 
> going to need to be added anyway: one reason is to serve this purpose of 
> identifying arrays that are stored in the base structure.  Another 
> possible reason is to identify flex arrays that want the poison behavior 
> to identify use-uninitialized and use-after-free and would be passed such 
> as flex_array_alloc(size, total, FLEX_ARRAY_POISON, gfp) to isolate arrays 
> that may, as you said, store elements of types other than void * or those 
> significantly small enough that they would collide with the poison values 
> at a higher probability.
> 

I was looking at converting a vmalloc'd array somewhere (anywhere, really) 
to use flex array instead.

The cgroup pidarray can't be converted because it sorts the array, for 
which flex array lacks support (and isn't really in its scope since the 
mapping from index to element is then pointless).  An alternative 
implementation like flex list, which I've already eluded to, seems more 
appropriate.

I also looked at oprofile's event_buffer, which vmalloc's elements of size 
unsigned long up to a certain threshold.  Flex array could accomodate 
261,632 such elements on x86_64 and the buffer threshold defaults to 
131,072, so it was looking like a good candidate.

The problem is that it copies the entire array to userspace up to a 
certain element when reading the oprofile `buffer' file.  That's not 
possible with flex array without vmalloc'ing memory of size buffer_pos * 
sizeof(unsigned long) and memcpy'ing the elements into it.  So using flex 
array in this case is pointless (and considerably slower on every read).

I'm struggling to find other examples.  Dave, do you know of any 
subsystems in the kernel that can readily be converted to using flex 
array?
