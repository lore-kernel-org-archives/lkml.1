Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZHXU36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZHXU36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZHXU34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:29:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbZHXU3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:29:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hX1MZdiWRY/oUmFcovpP+Zx86s5IW5gjyY3USamntGtMeGPKVDrqdQCoI/puLsOQ6
	KrPBXY+fdPIRwz8kzouUw==
Date: Mon, 24 Aug 2009 13:29:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4 -mm] flex_array: add flex_array_clear function
In-Reply-To: <1251128488.22398.7113.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908241323360.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com> <1251128488.22398.7113.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Dave Hansen wrote:

> My only worry about this is that it's largely a copy-and-paste of
> flex_array_put().  If we had a function that just returned a pointer to
> 'dst', we could use that in both cases.  
> 
> Couldn't we implement the above with just:
> 
> int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
> {
> 	return flex_array_put(fa, element_nr, &empty_zero_page);
> }
> 

Sure, if you never increase FLEX_ARRAY_PART_SIZE.  Otherwise, doing

static char zero_part[FLEX_ARRAY_PART_SIZE] = {
	[0 ... FLEX_ARRAY_PART_SIZE - 1] = 0
};

and using flex_array_put(fa, element_nr, &zero_part) would work although 
you're trading off cleaner, yet not more efficient, code at the cost of 
FLEX_ARRAY_PART_SIZE wasted memory and memcpy() being slower than 
memset().
