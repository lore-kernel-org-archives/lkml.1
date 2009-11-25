Return-Path: <linux-kernel-owner+w=401wt.eu-S1751119AbZKYFrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbZKYFrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 00:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZKYFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 00:47:50 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63260 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZKYFrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 00:47:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=snSPAWZILz+FI9YYi0VZeWczugUu4PuyEO4CjCtRL7CoxnNmfakDTCUXohNGvE6yhO
         HipFmUM6rWCIF4OWJ1UJp8wWexCvCmP8gnCfb+ov4rE8Enm3Emvpnu1dIK27UYoySuHt
         yzgP5Ahfeubly/N0/a40CTqtmCbAh07Vno0wM=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <19212.22371.633313.129961@cargo.ozlabs.ibm.com>
References: <1256223091-6002-1-git-send-email-eranian@gmail.com>
	 <1258562785.3918.685.camel@laptop>
	 <7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
	 <1258983953.4531.456.camel@laptop>
	 <7c86c4470911240518qe0c3e87k589437ef43f4a3d4@mail.gmail.com>
	 <19212.22371.633313.129961@cargo.ozlabs.ibm.com>
Date: Wed, 25 Nov 2009 06:47:54 +0100
Message-ID: <7c86c4470911242147u160008d4y50385cb348615df8@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix validate_event bug
From: stephane eranian <eranian@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net, eranian@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:00 PM, Paul Mackerras <paulus@samba.org> wrote:
> stephane eranian writes:
>
>> That means we can drop is_software_event() in this code and instead
>> define locally
>> in x86 a is_hw_pmu_event() function as event->pmu == &pmu.
>
> I'd have to see the patch, but that doesn't feel entirely right,
> because there is a unique characteristic of software events, compared
> to hardware or breakpoint events: they are never capacity
> constrained.  In the past, only hardware events were capacity
> constrained, which meant that all the decisions about whether a group
> could go on could be done in the hardware PMU backend.  Now we have
> two sources of capacity constraints, so it may be that a group can't
> go on even if the hardware PMU has capacity.  That's going to be
> somewhat interesting to get completely right, I think.
>
I was talking of is_software_event() in the context of the hardware PMU
code. The reason you were using this function is simply to skip
SW events because, as you said, they are never constrained
and also because they are not related to HW PMU.

You are right about HW breakpoints, because now you have a new source of
constraints. Only the breakpoint code knows about those constraints.

It seems to me you have two ways of solving this:
  1- push the algorithm to assign events to counters up in the generic code
  2- have the generic code invoke all possible constraint sources on each group

I have already said that I would not recommend initially going with 1- because
constraints are very diverse in their nature. It is not as simple as 1 event = 1
bitmask of valid counters. Things can be more dynamic than that, e.g., on AMD64,
whereby for certain events the bitmask depends on what is going on in the other
cores on the socket. There are also similar constraints on advanced
Intel features.
So unlike what I heard early on, constraints are not going away,
instead they are
changing in nature and to something much more complex to deal with.

I believe that until all PMU event assignment logic is implemented in the PMU
specific code, it would be very presumptuous to try and design that
generic algorithm.
So I would go with 2, at least initially.
