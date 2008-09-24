Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYIXVDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYIXVDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYIXVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:03:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYIXVDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:03:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=FXZtj6e0XWpszHiFpyg0DJUXKu5Rsta4wBtUYWf7xsrtFC8wgcMpB99w0NR2c4TYv
	HYIpgDxNw+AkOghGu370w==
Message-ID: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
Date: Wed, 24 Sep 2008 14:03:18 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>
	 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
X-GMailtapped-By: 172.28.16.143
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, then how about this?
>
> Each page will start with a time stamp (I'm still aligning everything by 8
> bytes, just because it simplifies things). Then we can have a 3 byte
> (24 bit) counter offset? Then we can have a header that looks like:
>
> struct {
>        unsigned char time[3];
>        unsigned char length;
>        unsigned char buff[];
> };
>
> This still allows me to have the 2048 byte size buffer.
>
> Or is 24 bits for time too small? The offest will be from the previous
> entry, and not the beginning of the page.
>
> If one defines a fixed size entry, we could just use the full 32 bits for
> the timestamp, since the length will be ignored in that case, and will
> become part of the buffer.
>
> Hence,
>
> struct {
>        unsigned int time;
>        unsigned char length;
>        unsigend char buff[];
> };

How about we just steal 5 bits from the timestamp to indicate event
lengths up to 32 bytes, and if it's 0, that means there's a length
field following? Also that'd mean you could use a longer length field
and get beyond 256 bytes to 4096, without impacting most events.

struct {
        u32 length:5, time_delta:27;
        u16 length;
        u8 buf[];
};

struct {
        u32 length:5, time_delta:27;        /* where length == 0 */
        u8 buf[];
};

Obviously we could less than 5 bits, even just 1 for a flag ...
