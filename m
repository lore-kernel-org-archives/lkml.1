Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYKWIXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYKWIXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYKWIXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:23:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:28837 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYKWIXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o3mTAkuMYnPaX9VU5arIZNlEsYbCA7sM5Txyk5BV3Aj4PSMYrRUZN2i1muV83jryUK
         kmyR84zFWJ/bBK0TEva1dKyK2meGMljZKclY8fELaG95BCx+xXECvX1ejNEO1PwsBCt9
         eh2CYQyMGyJK6xey3ATfZJu4dJqmtqWU21Lm4=
Message-ID: <d36bb30d0811230023i2d80d93fv2fc45d518ecaf04a@mail.gmail.com>
Date: Sun, 23 Nov 2008 16:23:03 +0800
From: "Yang Xi" <yangxilkm@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2.6.28-rc4]lock_stat: Add "con-hungry" to show that how many person-time fight for the ticket spinlock
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, chyyuu <chyyuu@gmail.com>,
       "Fu, Michael" <michael.fu@intel.com>
In-Reply-To: <1227404426.7685.19975.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d36bb30d0811180300r77c3a13ld0a4881a8261a40@mail.gmail.com>
	 <1227025232.29743.23.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811182118x1e394780n8a257fd4c44f4836@mail.gmail.com>
	 <1227112785.29743.37.camel@lappy.programming.kicks-ass.net>
	 <d36bb30d0811200009j742416a6nbc0519ff8d95970b@mail.gmail.com>
	 <1227404426.7685.19975.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 9:40 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2008-11-20 at 16:09 +0800, Yang Xi wrote:
>> > I of course meant folding cpu and isspinlock into a combined bitfield
>> > (sorry for not being more clear), thereby saving space, this still takes
>> > 2*sizeof(int).
>> >
>> > We can safely take some bits from the cpu number as there currently are
>> > no plans for a 2g cpu machine, right SGI? :-)
>> Thanks, ok, 31bits enough for cpu at now stage. 1bit for isticketspinlock.
>> Here is the new one. Welcome more comments :).
>
> Looks good, one more question :-)
>
>> --- a/include/linux/spinlock.h
>> +++ b/include/linux/spinlock.h
>> @@ -127,6 +127,12 @@ do {
>>                  \
>>  #define spin_is_contended(lock)
>> __raw_spin_is_contended(&(lock)->raw_lock)
>>  #endif
>>
>> +#ifdef CONFIG_HAVE_TICKET_SPINLOCK
>> +#define spin_nr_contended(lock) __ticket_spin_nr_contended(&(lock)->raw_lock)
>> +#else
>> +#define spin_nr_contended(lock) (0)
>> +#endif
>> +
>
> Does it make sense to make the alternative case return
> spin_is_contended()?
You mean do it like this?
#ifdef CONFIG_HAVE_TICKET_SPINLOCK
#define spin_nr_contended(lock) __ticket_spin_nr_contended(&(lock)->raw_lock)
#else
#define spin_nr_contended(lock) (spin_is_contended(lock) ? 1: 0)

If we do it like this, for some architectures which donot have ticket
spinlock, we can know that the percentage of contentions which involve
more than two threads (con-hungry/ contention times). But i donot know
whether there are some guys are interested in this number.

Best regards

>
>
