Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYIWS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYIWS16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYIWS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:27:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYIWS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:27:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=qTPm3QuHu78HsSuvz9lIJjwLwtqpDjoTFhrfuL5v4jxBTZPA/RHRVkilRT7jDnpZM
	GdmfDlPDB4YIRKbdv3acA==
Message-ID: <33307c790809231127w274be5b9lba7931f2e6c4ef73@mail.gmail.com>
Date: Tue, 23 Sep 2008 11:27:37 -0700
From: "Martin Bligh" <mbligh@google.com>
To: prasad@linux.vnet.ibm.com
Subject: Re: Unified tracing buffer
Cc: "Tom Zanussi" <zanussi@comcast.net>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>
In-Reply-To: <20080923175500.GA3843@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
	 <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
	 <20080923175500.GA3843@in.ibm.com>
X-GMailtapped-By: 172.24.198.97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 10:55 AM, K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> On Tue, Sep 23, 2008 at 07:00:38AM -0700, Martin Bligh wrote:
>> > - get rid of anything having to do with padding, nobody needs it and its
>> > only affect has been to horribly distort and complicate a lot of the
>> > code
>> > - get rid of sub-buffers, they just cause confusion
>> > - get rid of mmap, nobody uses it
>> > - no sub-buffers and no mmap support means we can get rid of most of the
>> > callbacks, and a lot of API confusion along with them
>> > - add relay flags - they probably should have been used from the
>> > beginning and options made explicit instead of being shoehorned into the
>> > callback functions.
>>
>> Actually, I think if you did all that, it'd be pretty close to what we
>> want anyway ...
>
> In the perspective of having a layered infrastructure, can we consider
> the interfaces later added over relay (to be used as a wrapper), namely
> relay_printk() and relay_dump()?

Might well work, but let's see what relayfs comes out looking like.
If it's heavily simplfiied, hopefully people will like it.

> - Very minimal work required to log data using the interfaces. Usage is
> made simple to resemble the printk(). Like
>
>        struct relay_printk_data *tpk;
>        tpk->parent_dir = "PARENT";
>        tpk->dir = "DIR";
>        relay_printk(tpk, <String to be output>);
>        relay_dump(tpk, <Some binary data to output>);

You really don't want to store strings in the buffer, it's horribly
inefficient. I think the intent was to store binary data from tagged
events, along with the format strings, and do all the expansion later.
