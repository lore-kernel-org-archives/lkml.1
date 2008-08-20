Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYHTVrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYHTVrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYHTVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:46:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:56848 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYHTVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nvmJFTAMyk8onSIU+kOnN3cR0ncWpjvx34FSzVxe6LA74gTy1slAFD5F5Dpw51VMOj
         ZO7lon+Qw73AEjzLKaAGw1GdE/gTEx7KLy7/xX+A+0ZckKu4Zas1yfTWYgLJVxTBxwmC
         A97WJ6NToHmwqnnHkDEY7xrV39aJKdrwb3VJo=
Message-ID: <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:46:49 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Cc: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dave Jones" <davej@codemonkey.org.uk>
In-Reply-To: <48AC8F69.4050201@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48972EA8.8040001@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl>
	 <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl>
	 <20080819190757.GA17470@linux-os.sc.intel.com>
	 <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl>
	 <48AC29CA.1060203@keyaccess.nl>
	 <20080820194127.GA10887@linux-os.sc.intel.com>
	 <48AC8F69.4050201@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 7:40 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 20-08-08 21:41, Venki Pallipadi wrote:
>
>> OK. I have reproduced this list size issue locally and this order 1
>> allocation and set_memory_uc on that allocation is actually coming
>> from agp_allocate_memory() -> agp_generic_alloc_page() ->
>> map_page_into_agp() agp_allocate_memory breaks higher order page
>> requests into order 1 allocs.
>>
>> On my system I see multiple agp_allocate_memory requests for nrpages 8841,
>> 1020, 16, 2160, 2160, 8192. Together they end up resulting in more than 22K
>> entries in PAT pages.
>
> Okay, thanks for the confirmation.
>
> Now, how to fix...
>
> Firstly, it seems we can conclude that any expectancy of a short PAT list is
> simply destroyed by AGP. I believe the best thing migh be to look into
> "fixing" AGP rather than PAT for now?
>
> In a sense the entire purpose of the AGP GART is collecting non contiguous
> pages but given that in practice it's generally still just one or at most a
> few regions, going to multi-page allocs sounds most appetising to me.
>
> All in tree AGP drivers except sgi-agp use agp_generic_alloc_page(), ali via
> m1541_alloc_page and i460 via i460_alloc_page.

In the future we will be getting more smaller AGP allocs, so the other
problem needs a fix as well.

http://git.kernel.org/?p=linux/kernel/git/airlied/agp-2.6.git;a=shortlog;h=agp-pageattr2

contains some code I started on before that moves the interfaces
around,  Shaohua has been looking at
it as it needs the changes to the set_pages interface as well, which
is where I ran out of time/steam last time.

However with alloc/free pages we could change to a higher order
allocation function as long as it fell back to lower
orders internally.

Dave.

>
> Rene.
>
