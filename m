Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZE2Ut5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZE2Ut5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZE2Utt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:49:49 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43717 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZE2Uts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Ih1nJpFHWuBvoWMA84U2A0xySJLcL0v4NIaza+nb7NC3ZJKT1flHCUebMWUs5YLdFh
         XIEU93zXMWVoVo9YbZMiYvMojEdxj3Tb5ReRNCoBadWfd8gCHCAtDyE1MRk5YbuOSJAF
         w9An6Zp61DNb2ZbXzOqgdTpSGX0F1I0d6Zl+8=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1243629142.6645.108.camel@laptop>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop> <1243629142.6645.108.camel@laptop>
Date: Fri, 29 May 2009 22:49:48 +0200
Message-ID: <7c86c4470905291349icb3fc03wa87d7e5c1069eaf4@mail.gmail.com>
Subject: Re: comments on Performance Counters for Linux (PCL)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 10:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2009-05-28 at 18:25 +0200, Peter Zijlstra wrote:
>> >   10/ Group event buffer entry
>> >
>> >        This is activated by setting the PERF_RECORD_GROUP in the record_type
>> >        field.  With this bit set, the values of the other members of the
>> >        group are stored sequentially in the buffer. To help figure out which
>> >        value corresponds to which event, the current implementation also
>> >        stores the raw encoding of the event.
>> >
>> >        The event encoding does not help figure out which event the value refers
>> >        to. There can be multiple events with the same code. This does fit the
>> >        API model where events are identified by file descriptors.
>> >
>> >        The file descriptor must be provided and not the raw encoding.
>>
>> OK, sounds sensible.
>
> This can't actually be done, fds can change, and there is no struct
> file* to fd map.

The API must define an order in which values are stored. Otherwise
how would the application figure out what they correspond to in the
group.

Explain to me what you mean by fds can change. Are you thinking
about dup()+close() for instance?

> If the config isn't good enough, the best we could do is something
> unique per instance.
>
Config isn't good enough for sure. For instance, I could be sampling
the same generic PERF_CPU_COUNT_CYCLES twice in the same
group, once at the user level only (exclude_kernel=1), and once at
the kernel level only (exclude_user=1), but the two config values
would be identical.

If there is no backmapping, then you could get by perhaps by having
the API guarantee that values are stored in the order events were
originally chained in the group. If that does not work, then you need
to emit a unique cookie per fd and let the application maintain a mapping
table.
