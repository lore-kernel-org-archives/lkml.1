Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYBGJLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYBGJLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYBGJLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:11:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:27723 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYBGJLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VaXQF/2ROgIC/VkMAkh8EneEA5IPx3VJSV8aTPqYUAI0ELcERMRVxWfqdmIljjoou2r9rujnFJmkAKfs79Xw5HCib7MjXqp3LyTrdbSHYu4eWeNF0f5trX0SGB1AXHrBio9td0Jq0qGqpgHZoW155q7yDrpY54axVIXs8DPh+/4=
Message-ID: <86802c440802070111o5a4bc700g75a0693f8307d766@mail.gmail.com>
Date: Thu, 7 Feb 2008 01:11:19 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb mtrrs - FIX
Cc: "Balaji Rao" <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de, "Harvey Harrison" <harvey.harrison@gmail.com>
In-Reply-To: <20080207090452.GB12884@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802071257.51893.balajirrao@gmail.com>
	 <20080207080245.GA28631@elte.hu>
	 <200802071351.02763.balajirrao@gmail.com>
	 <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com>
	 <20080207090452.GB12884@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 1:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> > minor difference
> > +               trim_start = highest_pfn << PAGE_SHIFT;
> > +               trim_size = end_pfn << PAGE_SHIFT;
> >
> > could cause some problem with 32 bit kernel when mem > 4g. becase
> > highest_pfn and end_pfn is unsigned long aka 32 bit ...could overflow.
> >
> > so need to assign thtem to tr, 32-bitim_start/trim_end at first
> > or
> > +               trim_start = (u64)highest_pfn << PAGE_SHIFT;
> > +               trim_size = (u64)end_pfn << PAGE_SHIFT;
>
> indeed ...
>
> i think the 64-bit behavior of gcc is inherently dangerous, we had
> numerous subtle bugs in that area.
>
> i think perhaps Sparse should be extended to warn about this. I think
> any case where on _32-bit_ we have an 'unsigned long' that is shifted to
> the left by any significant amount is clearly in danger of overflowing.
> _Especially_ when the lvalue is 64-bit!
>
> or in other words, on any such construct:
>
>    64-bit lvalue = ... 32-bit value
>
> we should enforce _explicit_ (u64) conversions.

so you mean gcc will do some optimization to make

+               trim_start = highest_pfn;
+               trim_start <<= PAGE_SHIFT;

to be

+               trim_start = highest_pfn << PAGE_SHIFT;

looks scary...

then gcc need to be fixed.

YH
