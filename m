Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYCMBLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYCMBLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYCMBLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:11:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:51150 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYCMBLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TTEXpzFmV7PJkJ9rsMWoEZZZUUUQ9wPhVZ6VKfCLbKEHMEEjvCuqwi4C628yOuV2SmzXVHs4lXoZMRaznh1dNIjhTUJ1ngIuUeC65RTbq23d8/FHtg1U2bNxY9S96zLuUPb9EPINLf1OFuIgXwUB0RodxpbYpZ92UrG2F25PqWw=
Message-ID: <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
Date: Wed, 12 Mar 2008 18:11:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080312163359.7fe0fd80.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	 <86802c440803121621j3b9ec7e8nf7ae62b894eb85df@mail.gmail.com>
	 <20080312163359.7fe0fd80.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 4:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 12 Mar 2008 16:21:22 -0700
>
>
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Tue, Mar 11, 2008 at 6:01 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > > [PATCH] mm: fix boundary checking in free_bootmem_core
>  > >
>  > >  so call it when numa is enabled, we don't know which node have that range.
>  > >  and make it more robust.
>  > >
>  > >  try to trim it to get valid sidx, and eidx.
>  > >
>  > >  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  > >
>  >
>  > Ingo,
>  >
>  > this one need to be applied before
>  > [PATCH] x86_64: reserve dma32 early for gart
>  >
>
>  So perhaps we should merge
>  mm-fix-boundary-checking-in-free_bootmem_core.patch into 2.6.25?
also we can remove some NODE_DATA(0) assumpation on free_bootmem path.
>
>  <looks at it>
>
>  Sorry, but I find the changelog very hard to amke sense of.  I presently
>  have:
>
>
>   So call it when numa is enabled, we don't know which node have that
>   range.  and make it more robust.
>
>   Try to trim it to get valid sidx, and eidx.
>
>  Could you please expand on this?

please check following...

---
with numa enabled, some caller could have range on one node but try to
free that on other node.
that could cause some pages is freed wrongly.
For example: when we try to allocate 128g boot ram early for
gart/swiotlb, and free that range later so gart/swiotlb could get some
range afterwards. then with this patch, we don't need to care which
node is the range, just loop to call free_bootmem_node for all online
nodes.

this patch make free_bootmem_core more robust by trim the sidx and
eidx according the ram range that
node have.

----
