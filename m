Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZHRBq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZHRBq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758582AbZHRBq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:46:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56171 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579AbZHRBq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:46:57 -0400
Subject: Re: [patch 1/3] flex_array: fix get function for elements in base
 starting at non-zero
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908171738030.1766@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
	 <1250554751.10725.22076.camel@nimitz>
	 <alpine.DEB.2.00.0908171738030.1766@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 18:46:56 -0700
Message-Id: <1250560016.10725.22472.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 17:49 -0700, David Rientjes wrote:
> On Mon, 17 Aug 2009, Dave Hansen wrote:
> 
> > On Mon, 2009-08-17 at 16:46 -0700, David Rientjes wrote:
> > > This fixes the bug by only checking for NULL parts when all elements do
> > > not fit in the base structure when flex_array_get() is used.  Otherwise,
> > > fa_element_to_part_nr() will always be 0 since there are no parts
> > > structures needed and such element may never have been put.  Thus, it
> > > will remain NULL due to the kzalloc() of the base.
> > 
> > Whew.  That one took me way longer to grok than it should have.  Thanks
> > for finding this.  Just to be clear, there is only a bug in
> > flex_array_get(), right?  The flex_array_put() change is completely
> > separate and is intended to optimize the case where we know the pointer
> > can't be NULL.
> > 
> > This definitely fixes a bug, but do you mind if we do it a bit
> > differently?  The compiler should be able to take care of figuring out
> > when that pointer actually needs to be checked, and I think it looks a
> > bit nicer as it stands.   
> > 
> 
> Your patch doesn't optimize the check away when all the elements are 
> stored in the base structure, gcc doesn't infer that part must be valid 
> based upon previous dereferences.  In fact, the resulting assembly would 
> probably show the calculation of the element offset from `part' to happen 
> in all cases iff part is non-NULL.
> 
> The flex_array_put() optimization is done for the same reason.

Oh, I wasn't talking about dereferences.  I figured it would happen from
the *assignment*.  But, I guess with address space wrapping or other
oddities, gcc can't make that optimization, so my assumption was bogus.
We're arguing way too much about two instructions.  Either way is fine
with me.

-- Dave

