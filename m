Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZEMFc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZEMFc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZEMFcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:32:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:47010 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZEMFcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bUwRtqRfhrmBWGbTklJBDDA33xl6N5O5zb5K4oOTmPnrmeYjclEJ/dEzj5lq8Mij4B
         fSYFb9VUo76rhJ2Fc+DPobVX/jjLZ2G3iQngZ07jB/tVhAM7q4H0gjPs2uQJzYTyYrCf
         VzArRrR6Hwe4K2V3aS3P4Jy+Zf0IAVF/2rapg=
MIME-Version: 1.0
In-Reply-To: <49F8B1A1.4010208@garzik.org>
References: <49EE37AF.4020507@zytor.com>
	 <20090421.173123.191021055.davem@davemloft.net>
	 <adak55438gp.fsf_-_@cisco.com>
	 <20090428.221228.217954247.davem@davemloft.net>
	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>
	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org>
Date: Wed, 13 May 2009 14:32:19 +0900
Message-ID: <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 04:59, Jeff Garzik <jeff@garzik.org> wrote:
> Roland Dreier wrote:
>>
>>  > This removal patch is completely pointless, because it moves us
>>  > backwards to the point where we had a bunch of drivers defining it.
>>
>> No, the current kernel still requires drivers to define it anyway,
>> because there are tons of 32-bit architectures that are not x86.
>
> Then let's fix that issue...  by propagating the common definition to other
> platforms that properly implement {read,write}[bwl] in terms of the PCI bus.
>
>
>> And more than that, centralizing the definition makes the API much more
>> dangerous for driver authors.
>
> I think that's really cranking the hyperbole level to 11.
>
> The common definition is... the one found most commonly in the wild. For
> weird drivers, they will do their own thing.
>
> That's pretty much how other drivers handle things.
>
> Apply your logic here to _any_ API in the kernel, for the same result.
>
>
>>  > At least the networking drivers I messed with (until 11/2008) were
>>  > always fine with a non-atomic readq.
>>
>> The commit to niu I keep citing (e23a59e1, "niu: Fix readq
>> implementation when architecture does not provide one.") shows that
>> drivers need to take care.  Now, the x86 implementation would happen to
>
> That commit also shows that, had the driver been using a common definition,
> problems would not have arisen.
>
>
>> work for that hardware, but eg drivers/infiniband/hw/amso1100 defines
>> readq with the opposite order -- whether that's required or just an
>
> 'required' seems unlikely, given that
>
> a) their readq only exists when #ifndef readq, thus implying the
> driver-local readq is far less tested, on their most-tested, highest-volume
> platform.
>
> b) their readq still operates in LE order -- as it should: read,write[bwl]
> were defined in terms of PCI originally, and thus defined to be LE.
>
> c) their __raw_writeq writes in lower-32-bits-first, as one would expect
>
>
>> arbitrary choice, I don't know.  And drivers/infiniband/hw/mthca has
>> some uses of __raw_writeq() that only work if no other CPU accesses to
>> the same page can happen between the two halves, so it adds a per-page
>> spinlock for 32-bit architectures.  etc.
>
> Any use of __raw_xxx implies that You Know What You're Doing And Accept The
> Consequences.  __raw_xxx means _you_ handle endian conversions, barriers,
> and other arch-specific details.  I don't think that a driver intentionally
> using the "raw" APIs is a good source of ideas and generalizations.
>
> So, for your three examples,
>
>        1) niu - common definition is OK
>
>        2) amso1100 - common definition is OK; driver-local definition
>           never used on common PCI platforms
>
>        3) mthca - intentionally uses raw API, an API which ditches
>           arch-specific barriers, endian conversions, and other
>           guarantees.
>
> Given that, I see zero justification for API removal.  I see justification
> for propagating this code to other PCI-capable platforms.
>
> Finally, I think given all this time we've had driver-define writeq and
> readq, and "driver authors were forced to think about this API" -- the
> result was the obvious definition now in place!
>
>        Jeff
>
>
>
>
>

I think it's good time to decide making all architectures
which have readq/writeq provide HAVE_READQ/HAVE_WRITEQ or not.

Adding HAVE_READQ/HAVE_WRITEQ to Kconfig of architectures needs
agreement of all maintainers of these.

But, David Miller, maintainer of SPARC architecture, acked Roland's patch
because of the possibility of bugs non-atomicity of readq/writeq of
x86-32 will cause.

And, Jeff Garzik said that he saw zero justification for API removal.

Which way should we choose?
Remove readq/writeq from x86-32?
Or add HAVE... to all architectures with readq/writeq?
