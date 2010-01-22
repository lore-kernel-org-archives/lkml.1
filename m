Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057Ab0AVRzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0AVRzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933Ab0AVRzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:55:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:44864 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0AVRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=QXD0hNw68ycsy4hbdmh+kYjYeIi57iB5zgD8LyYUgVoJAF3sqltzpGexQJBI6o735M
         o4JOCujR4kPuCyxOsjOue0mFAvtdZtmSA0VHaGmPbYsPGOj0l5eFLEPN/H2JttVH596X
         3sN8smpy4x6zqzZwt5q2Jpu40GlRHVJtc9JWU=
From: Don Mullis <don.mullis@gmail.com>
To: dedekind@infradead.org
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, david@fromorbit.com
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box>
	<87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org>
	<1264163348.3032.240.camel@localhost>
Date: Fri, 22 Jan 2010 09:55:39 -0800
In-Reply-To: <1264163348.3032.240.camel@localhost> (Artem Bityutskiy's message
	of "Fri, 22 Jan 2010 14:29:08 +0200")
Message-ID: <87my0681no.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind@infradead.org> writes:

> On Fri, 2010-01-22 at 11:43 +0100, Andi Kleen wrote:
>> Don Mullis <don.mullis@gmail.com> writes:
>> >
>> > Being just a dumb library routine, list_sort() has no idea what context
>> > it's been called in, how long a list a particular client could pass in,
>> > nor how expensive the client's cmp() callback might be.
>> >
>> > The cmp() callback already passes back a client-private pointer.
>> > Hanging off of this could be a count of calls, or timing information,
>> > maintained by the client.  Whenever some threshold is reached, the
>> > client's cmp() could do whatever good CPU-sharing citizenship required.
>> 
>> need_resched() does all the timing/thresholding (it checks the 
>> reschedule flag set by the timer interrupt). You just have to call it.
>> But preferable not in the inner loop, but in a outer one. It's
>> not hyper-expensive, but it's not free either.
>> 
>> The drawback is that if it's called the context always has to
>> allow sleeping, so it might need to be optional.
>> 
>> Anyways a better fix might be simply to ensure in the caller
>> that lists never get as long that they become a scheduling
>> hazard. But you indicated that ubifs would pass very long lists?
>> Perhaps ubifs (and other calls who might have that problem) simply
>> needs to be fixed.
>
> No, they are not very long. A hundred or so I guess, rarely. But we need
> to check what is really the worst case, but it should not be too many.

I suggest for now we leave scheduling issues as the caller's
responsibility, and keep list_sort() simple.  Wouldn't want to be
getting any email like this:

         http://lwn.net/Articles/366768/
