Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZCSLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZCSLqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZCSLqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:46:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:34271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZCSLqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:46:05 -0400
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <1237462867.7867.43.camel@twins>
References: <20090317215606.037073805@chello.nl>
	 <20090317220421.336322251@chello.nl>
	 <18880.23662.233043.833458@drongo.ozlabs.ibm.com>
	 <1237366063.5069.64.camel@laptop>
	 <18881.29300.669876.820286@cargo.ozlabs.ibm.com>
	 <1237462867.7867.43.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 19 Mar 2009 12:45:50 +0100
Message-Id: <1237463150.7867.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 12:41 +0100, Peter Zijlstra wrote:
> On Thu, 2009-03-19 at 09:15 +1100, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > Ah, I thought we should keep a pure 64 bit raw value. You never know
> > > what hardware will do.
> > 
> > Oh I see, you use hw_event->raw_event if hw_event->raw is set.  I
> > missed that before.
> > 
> > Still, you're putting that into hwc->config along with other bits like
> > ARCH_PERFMON_EVENTSEL_USR and ARCH_PERFMON_EVENTSEL_OS, so I would
> > think we could spare two bits for the type, leaving 62 bits for the
> > raw event code.  And if that isn't enough, there's the
> > hw_event.extra_config_len field, which allows userspace to pass in
> > arbitrary amounts of extra PMU configuration data.
> 
> Good point, overflow interrupt, and usr/os/hv event filter and enable
> bits are usually in the config word.
> 
> OK, how about the below? I didn't cut it to 2 bits, as that would
> already exhaust the TYPE space -- then again, 60 does feel cramped a
> bit..

Hmm, we could play dirty and do:

union {
  struct {
    __u64 raw_event_id : 63,
          raw          :  1;
  };
  struct {
    __u64 event_id     : 56,
          type            8;
  };
};

Giving us 7 bit type space.
