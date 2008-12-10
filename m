Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLJCI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLJCI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYLJCIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:08:16 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:39152 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYLJCIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DqRmGeh7Ix+CPlPmIx9ODQFjxHFuJxkaws91q5R5y1t1HHEhPM3S7vD9Dz/6dpj7vi
         mzYN73tBrwnsxEBjxgR9SslnvoxuxUsuKdjmnGNmNOiuOZZYNBgi9H31/wtPuWcTN08K
         Yq2s4CgGgf1mOhABRCuDv177zIrnfyhYzO60k=
Message-ID: <21d7e9970812091808r47e0cf07u8df2a9d2a27b783c@mail.gmail.com>
Date: Wed, 10 Dec 2008 12:08:13 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, alan@lxorguk.ukuu.org.uk,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Clement Calmels" <cboulte@gmail.com>,
       "Nadia Derbey" <Nadia.Derbey@bull.net>,
       "Pierre Peiffer" <peifferp@gmail.com>
In-Reply-To: <20081209180250.8d7301a7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203193901.715896543@mini.kroah.org>
	 <20081203194725.GA8950@kroah.com> <20081203194906.GV8950@kroah.com>
	 <21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
	 <alpine.LFD.2.00.0812091447230.3340@localhost.localdomain>
	 <21d7e9970812091643n7e3e4fe5g8e44030adfbababa@mail.gmail.com>
	 <21d7e9970812091746u5b6e8594s8567007ec1e26bac@mail.gmail.com>
	 <20081209180250.8d7301a7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 12:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 10 Dec 2008 11:46:13 +1000 "Dave Airlie" <airlied@gmail.com> wrote:
>
>> >>
>> >> On Wed, 10 Dec 2008, Dave Airlie wrote:
>> >>>
>> >>> On Thu, Dec 4, 2008 at 5:49 AM, Greg KH <gregkh@suse.de> wrote:
>> >>> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>> >>> >
>> >>> Revert.
>> >>>
>> >>> This caused problems in the F10 kernel with idr, the drm device alloc
>> >>> went all wierd,
>> >>> it might be a drm bug but changing this code triggers it and so it
>> >>> isn't really "stable"
>> >>
>> >> Well, maybe it should be reverted in mainlne too, then?
>> >
>> > It appears idr_replace is broken at least in stable with this patch.
>> >
>> > I'm trying to track down where the problem is (idr_replace doesn't look like
>> > idr_find in a lot of places and I wonder if this has ever been tested.)
>> >
>> (cc-trimmed).
>>
>> Okay I'm not idr expert and maybe what the drm is doing is illegal but
>> it never caused a problem up to now.
>>
>> The drm grabs an idr minor number using a NULL pointer to reserve the
>> number, it then uses idr_replace later
>> to stick a pointer into the reserved number. However this seems to be
>> what is broken, I'm not sure if this is a legal
>> use of idrs but has worked like that for a long time now.
>>
>> I can fix the drm to workaround this, and allocate my pointers before
>> I try to get a minor number, but I'd like to know
>> if my usage is illegal over just overlooked.
>
>
> <greps for a while>
>
> I assume we're talking about drivers/gpu/drm/drm_stub.c:drm_minor_get_id()?
>
> I don't immediately see anything in the idr code which special-cases a
> NULL caller pointer?
>

Actually now that I'm starting to wrap my head around it I think it
might be the fact that I call
idr_get_new_above with 64, then later with 0. I'm not sure the new
code is dealing with that case so
well.

We don't do that in the standard kernel tree yet, so it explains why
nobody's noticed, however the KMS
changes introduce it, and we have those in f10.

http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=blob;f=drivers/gpu/drm/drm_stub.c;h=5ca132afa4f2e128999e319e44e31ad156e6ab74;hb=drm-next

is the drm_stub.c from drm-next that will trigger the issue.

Again I'm not sure if this is a legal use of idrs.

Dave.

>
