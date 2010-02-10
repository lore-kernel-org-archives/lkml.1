Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0BJQHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:07:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab0BJQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:07:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=kLPmUKyWzinwv9ANKc5tDNQM+DrIBrQf5Kbi5qHxWno5yjh8AXxN7kZt+ZMSxj07d
	6MBDl8ZCHSpwuIObY+UoQ==
MIME-Version: 1.0
In-Reply-To: <6096959DEF5C9447A6BF80BDC7EB9EDC14913E8B@SBOSEXMB1.amd.com>
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com>
	 <1265803166.11509.286.camel@laptop>
	 <bd4cb8901002100504i8e716e8ob845f692e031726f@mail.gmail.com>
	 <1265807830.11509.295.camel@laptop>
	 <1265808501.11509.300.camel@laptop>
	 <7c86c4471002100558s1a744ae7h6b3837c786e03704@mail.gmail.com>
	 <6096959DEF5C9447A6BF80BDC7EB9EDC14913E8B@SBOSEXMB1.amd.com>
Date: Wed, 10 Feb 2010 17:07:13 +0100
Message-ID: <bd4cb8901002100807y7b142f02ofb8cecb507ddf681@mail.gmail.com>
Subject: Re: [perfmon2] [PATCH] perf_events: AMD event scheduling (v3)
From: Stephane Eranian <eranian@google.com>
To: "Drongowski, Paul" <paul.drongowski@amd.com>
Cc: eranian@gmail.com, Peter Zijlstra <peterz@infradead.org>,
       perfmon2-devel@lists.sf.net, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 4:59 PM, Drongowski, Paul
<paul.drongowski@amd.com> wrote:
> Good catch!
>
> Historically, AMD has treated the bit field EventSelect<7:5>
> in model specific register MSRC001_00[03:00] Performance Event
> Select Register (PERF_CTL[3:0]) like an "event group selector".
> Please see the "BIOS and Kernel Developer's Guide for AMD
> Family 10h Processors."
>
> Typically, EventSelect<7:5> == 0x7 selects Northbridge
> events.
>
> Yes, when the event select value was extended to twelve bits,
> it placed this field somewhere in the middle of the full
> twelve bit value. ;-)
>
> Please consider AMD Family 10h event 0x1C0 Retired x87
> Floating Point Operations. This is not a Northbridge event.
> If the test is greater than or equal to (e.g., 0x1C0 >= 0x0E0),
> then this event will be incorrectly identified as a
> Northbridge event. (There are other similar examples.)
>
Good example.

> So, I would recommend testing EventSelect<7:5> == 0x7
> in order to detect AMD Northbridge events.
>
Ok, so something like the following would do it:

static inline int amd_is_nb_event(struct hw_perf_event *hwc)
{
   return (hwc->config >> 5) & 0x7 == 0x7;
}
