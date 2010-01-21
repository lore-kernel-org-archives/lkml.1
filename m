Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216Ab0AUKpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0AUKpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674Ab0AUKpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:45:21 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34878 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0AUKpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YPWqReatl+cM/2UugR6iVR7RMcfLNRtRRlHOVfNvzOrvnOtmaQw1h0MaiKe6d19x4N
         p57/+8OLohFKy5MZefKMnAY30sr6h4kE7JTlBAQT9W4W71vcQhT/kOBAOji1rE8ObYNT
         Oj85cIT5XC2FiATPbFxfrFzXzRvIzy7tmQx+g=
Date: Thu, 21 Jan 2010 11:45:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
Message-ID: <20100121104513.GA5017@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere> <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:08:12AM +0100, Stephane Eranian wrote:
> >> > Do you mean this:
> >> >
> >> > hw_perf_group_sched_in_begin(&x86_pmu);
> >> >
> >> > for_each_event(event, group) {
> >> >         event->enable();        //do the collection here
> >> > }
> >> >
> >> >
> >> > if (hw_perf_group_sched_in_end(&x86_pmu)) {
> >> >         rollback...
> >> > }
> >> >
> >> > That requires to know in advance if we have hardware pmu
> >> > in the list though (can be a flag in the group).
> >>
> 
> I don't think this model can work without scheduling for each event.
> 
> Imagine the situation where you have more events than you have
> counters. At each tick you:
>    - disable all events
>    - rotate the list
>    - collect events from the list
>    - schedule events
>    - activate
> 
> Collection is the accumulation of events until you have as many as you
> have counters
> given you defer scheduling until the end (see loop above).
> 
> But that does not mean you can schedule what you have accumulated. And then what
> do you do, i.e., rollback to what?



If the scheduling validation fails, then you just need to rollback
the whole group.

That's sensibly what you did in your patch, right? Except the loop
is now handled by the core code.


> 
> With incremental, you can skip a group that is conflicting with the
> groups already
> accumulated. What hw_perf_group_sched_in() gives you is simply a way to do
> incremental on a whole event group at once.


I don't understand why that can't be done with the above model.
In your patch we iterate through the whole group, collect events,
and schedule them.

With the above, the collection is just done on enable(), and the scheduling
is done with the new pmu callbacks.

The thing is sensibly the same, where is the obstacle?


> 
> Given the perf_event model, I believe you have no other way but to do
> incremental
> scheduling of events. That is the only way you guarantee you maximize the use of
> the PMU. Regardless of that, the scheduling model has a bias towards smaller
> and less constrained event groups.


But the incremental is still the purpose of the above model. I feel
confused.

