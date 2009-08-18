Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZHRAtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZHRAtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbZHRAtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:49:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40729 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZHRAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:49:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZiWuTs8y0eRHguWI2OrFUZm57tMzXk9I6ZyYX7qbP8Mbxv4f749ZfROHljxEHEUAJ
	yb9l/8w/2nxRGlLwusUpQ==
Date: Mon, 17 Aug 2009 17:49:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] flex_array: fix get function for elements in base
 starting at non-zero
In-Reply-To: <1250554751.10725.22076.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908171738030.1766@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com> <1250554751.10725.22076.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Dave Hansen wrote:

> On Mon, 2009-08-17 at 16:46 -0700, David Rientjes wrote:
> > This fixes the bug by only checking for NULL parts when all elements do
> > not fit in the base structure when flex_array_get() is used.  Otherwise,
> > fa_element_to_part_nr() will always be 0 since there are no parts
> > structures needed and such element may never have been put.  Thus, it
> > will remain NULL due to the kzalloc() of the base.
> 
> Whew.  That one took me way longer to grok than it should have.  Thanks
> for finding this.  Just to be clear, there is only a bug in
> flex_array_get(), right?  The flex_array_put() change is completely
> separate and is intended to optimize the case where we know the pointer
> can't be NULL.
> 
> This definitely fixes a bug, but do you mind if we do it a bit
> differently?  The compiler should be able to take care of figuring out
> when that pointer actually needs to be checked, and I think it looks a
> bit nicer as it stands.   
> 

Your patch doesn't optimize the check away when all the elements are 
stored in the base structure, gcc doesn't infer that part must be valid 
based upon previous dereferences.  In fact, the resulting assembly would 
probably show the calculation of the element offset from `part' to happen 
in all cases iff part is non-NULL.

The flex_array_put() optimization is done for the same reason.
