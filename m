Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0BJP7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:59:37 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:51885
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755101Ab0BJP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:59:35 -0500
X-SpamScore: -31
X-BigFish: VPS-31(zzab9bh542N1432R98dN936eM148cM9371Pa03emzz1202hzz5a6ciz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KXMV2Z-03-C5Q-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [perfmon2] [PATCH] perf_events: AMD event scheduling (v3)
Date: Wed, 10 Feb 2010 10:59:24 -0500
Message-ID: <6096959DEF5C9447A6BF80BDC7EB9EDC14913E8B@SBOSEXMB1.amd.com>
In-Reply-To: <7c86c4471002100558s1a744ae7h6b3837c786e03704@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [perfmon2] [PATCH] perf_events: AMD event scheduling (v3)
Thread-Index: AcqqXi0owTlKwp7OTv2KrJXVWYz3rwACX+GA
References: <4b703957.0702d00a.6bf2.7b7d@mx.google.com><1265803166.11509.286.camel@laptop><bd4cb8901002100504i8e716e8ob845f692e031726f@mail.gmail.com><1265807830.11509.295.camel@laptop><1265808501.11509.300.camel@laptop> <7c86c4471002100558s1a744ae7h6b3837c786e03704@mail.gmail.com>
From: "Drongowski, Paul" <paul.drongowski@amd.com>
To: <eranian@gmail.com>, "Peter Zijlstra" <peterz@infradead.org>
CC: <perfmon2-devel@lists.sf.net>, <fweisbec@gmail.com>,
       <linux-kernel@vger.kernel.org>, "Stephane Eranian" <eranian@google.com>,
       <paulus@samba.org>, <mingo@elte.hu>, <davem@davemloft.net>
X-OriginalArrivalTime: 10 Feb 2010 15:59:27.0141 (UTC) FILETIME=[05A49D50:01CAAA6A]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1AG0GmE016448

Good catch!

Historically, AMD has treated the bit field EventSelect<7:5>
in model specific register MSRC001_00[03:00] Performance Event
Select Register (PERF_CTL[3:0]) like an "event group selector".
Please see the "BIOS and Kernel Developer's Guide for AMD
Family 10h Processors."

Typically, EventSelect<7:5> == 0x7 selects Northbridge
events.

Yes, when the event select value was extended to twelve bits,
it placed this field somewhere in the middle of the full
twelve bit value. ;-)

Please consider AMD Family 10h event 0x1C0 Retired x87
Floating Point Operations. This is not a Northbridge event.
If the test is greater than or equal to (e.g., 0x1C0 >= 0x0E0),
then this event will be incorrectly identified as a
Northbridge event. (There are other similar examples.)

So, I would recommend testing EventSelect<7:5> == 0x7
in order to detect AMD Northbridge events.

Thanks for implementing the AMD event scheduling feature!

-- pj

Paul Drongowski
AMD CodeAnalyst team


-----Original Message-----
From: stephane eranian [mailto:eranian@googlemail.com] 
Sent: Wednesday, February 10, 2010 8:58 AM
To: Peter Zijlstra
Cc: perfmon2-devel@lists.sf.net; fweisbec@gmail.com; linux-kernel@vger.kernel.org; Stephane Eranian; paulus@samba.org; mingo@elte.hu; davem@davemloft.net
Subject: Re: [perfmon2] [PATCH] perf_events: AMD event scheduling (v3)

On Wed, Feb 10, 2010 at 2:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-10 at 14:17 +0100, Peter Zijlstra wrote:
>> On Wed, 2010-02-10 at 14:04 +0100, Stephane Eranian wrote:
>>
>> > > @@ -2268,7 +2268,7 @@ static inline int amd_is_nb_event(struct
>> > > Â  Â  Â  Â u64 val = hwc->config & K7_EVNTSEL_EVENT_MASK;
>> > > Â  Â  Â  Â /* event code : bits [35-32] | [7-0] */
>> > > Â  Â  Â  Â val = (val >> 24) | (val & 0xff);
>> > > - Â  Â  Â  return val >= 0x0e0;
>> > > + Â  Â  Â  return val >= 0xe00;
>> > > Â }
>> > >
>> > I don't understand the change from 0xe0 to 0xe00.
>> > That's not the same thing at all.
>> > Event select is bits 0-7 + 32-35.
>>
>> OK that appears to be my bad, because you extended K7_EVNTSEL_EVENT_MASK
>> with bit 35 I thought NB events all had bit 35 set.
>>
>> But looking at the AMD docs it does indeed appear to start at 0xe0, and
>> there are no events with bit 35 set, only a few with bit 32.
>>
>> I'll switch it back to 0xe0.
>
> Fwiw, for the purpose of that function you might as well write:
>
> static inline int amd_is_nb_event(struct hw_perf_event *hwc)
> {
> Â  Â  Â  Â return (hwc->config & K7_EVNTSEL_EVENT_MASK) > 0xe0;
> }
>
> No need to move bits around higher than the value you compare against.
>
I think given the existing event codes, that would be fine too.

------------------------------------------------------------------------------
SOLARIS 10 is the OS for Data Centers - provides features such as DTrace,
Predictive Self Healing and Award Winning ZFS. Get Solaris 10 NOW
http://p.sf.net/sfu/solaris-dev2dev
_______________________________________________
perfmon2-devel mailing list
perfmon2-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/perfmon2-devel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
