Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZLWR4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZLWR4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZLWR4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:56:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:17736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbZLWR4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:56:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,443,1257148800"; 
   d="scan'208";a="478687883"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>,
       Arjan van de Ven <arjan@infradead.org>
Date: Wed, 23 Dec 2009 09:56:04 -0800
Subject: RE: [PATCH] prctl: return MCE process flags through pointer
Thread-Topic: [PATCH] prctl: return MCE process flags through pointer
Thread-Index: AcqDuVisOgIP3EgHR4iT5vcLq6BiZwAPJKvg
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
	<87hbricwz8.fsf@basil.nowhere.org>
	<20091222173424.980d5d33.akpm@linux-foundation.org>
	<20091223095223.GB20539@basil.fritz.box>
 <20091223021807.abbd993e.akpm@linux-foundation.org>
In-Reply-To: <20091223021807.abbd993e.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec Andrew Morton wrote:
>On Wed, 23 Dec 2009 10:52:23 +0100 Andi Kleen <andi@firstfloor.org> wrote:
>
>> On Tue, Dec 22, 2009 at 05:34:24PM -0800, Andrew Morton wrote:
>> > On Wed, 23 Dec 2009 02:14:51 +0100 Andi Kleen <andi@firstfloor.org>
>wrote:
>> >
>> > > "Smith, GeoffX" <geoffx.smith@intel.com> writes:
>> > >
>> > > > This patch fixes the semantics of prctl() option PR_MCE_KILL_GET
>> > > > to pass the return value through *arg2.
>> > > >
>> > > > With this change, the option now follows the same conventions as
>the
>> > > > other "get" options added since 2.6.0, and also brings it into
>> > > > conformance with the advice in chapter 16 of
>Documentation/CodingStyle.
>> > > >
>> > > > This prctl() option was only added within the last month, so there
>are
>> > > > not any production applications to break.  This patch applies
>cleanly
>> > > > to mainline and to 2.6.32.2 for backporting.
>> > >
>> > > It breaks the test suite, the man pages, qemu and one slide deck at
>least.
>> > >
>> >
>> > Should've got it right the first time.
>>
>> To be honest it's not fully clear to me what is "wrong" with returning
>> the return value with "return".
>
>Just a convention thing.
>
>> If there was a security bug or something maybe such a radical step
>> as changing a published API would be justified, but for this I'm
>sceptical.
>
>hm, OK, shrug.
>

Sorry, I wasn't aware of any published API, PR_MCE_KILL and KILL_GET just got accepted into mainline.  (And why aren't they called PR_SET/GET_MCE_KILL???)

I just noticed that these new options didn't follow the conventions of most prctl() options.  There is only one option newer than 2.3.48 that uses return-as-function-result, and that one is essentially a no-op.

>Regarding "prctl: return timerslack through pointer": are there any
>known users of PR_GET_TIMERSLACK yet?

The feature is only 3 months old, so no.  We are finding it beneficial in my group at Intel, which is the only reason I am looking at prctl().

>Why are task_struct.timer_slack_ns and
>task_struct.default_timer_slack_ns unsigned long, btw?  AFACIT we could
>make them unsigned ints.

Timer slack is not a Boolean or enum, and we want the greatest range possible.  (Actually, I'd like to talk Arjan into using the same time structure as select(), but that's another discussion.) Internally hrtimer uses unsigned long.  I know long and unsigned long are the same on some architectures, but let's not introduce an unnatural restriction -- recall that arg2 is unsigned long.

