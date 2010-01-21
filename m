Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177Ab0AUKi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0AUKi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674Ab0AUKi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:38:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55839 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0AUKi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:38:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CMNy4bf28W7q4/lJobPx7FcG2yxI2gm4BrSM3l4qZYftufOIqyjFIdSCRwcnu5X4U
	uF8lw/0A//637dkzaQJEQ==
MIME-Version: 1.0
In-Reply-To: <1264069717.4283.1148.camel@laptop>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
	 <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
	 <1264068712.4283.1141.camel@laptop>
	 <bd4cb8901001210221u5f02f05eq512df5dbb314419b@mail.gmail.com>
	 <1264069717.4283.1148.camel@laptop>
Date: Thu, 21 Jan 2010 11:38:54 +0100
Message-ID: <bd4cb8901001210238hae424b4qe5788f2a025c897a@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 11:21 +0100, Stephane Eranian wrote:
>
>> Are you suggesting a speculative approach where you first try simply
>> accumulate then schedule and if this fails, then restart the whole
>> loop but this time adding and scheduling each event individually?
>> For groups, you'd have to fail the group if one of its events fails.
>
> No, I'm only talking about groups. The complaint from frederic was that
> current hw_perf_group_sched_in() implementations have to basically
> replicate all of the group_sched_in() and event_sched_in() stuff, which
> seems wasteful.
>
I agree about the replication problem. But this comes from the fact that
if you call hw_perf_group_sched_in() and you succeed, you want to only
execute part of what group_sched_in() normally does, namely mark the
event as active, update timing but skip event_sched_in() stuff, incl. enable().
Actual activation is deferred until perf_enable() which avoids having some
events actually measuring while you are still scheduling events.

> So I was thinking of an alternative interface that would give the same
> end result but not as much code replication.
>
> I'm now leaning towards adding a parameter to ->enable() to postpone
> schedulability and add a hw_perf_validate() like call.
>
> With that I'm also looking at what would be the sanest way to multiplex
> all the current weak hw_perf* functions in the light of multiple pmu
> implementations.
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
