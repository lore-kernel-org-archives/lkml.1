Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYKXVoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYKXVoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYKXVnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:43:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbYKXVnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:43:50 -0500
Subject: Re: [PATCH] tracing: allow tracing of suspend/resume & hibernation
	code again
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Teoh <htmldeveloper@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081123094124.GO30453@elte.hu>
References: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
	 <200811221359.24808.rjw@sisk.pl>  <20081123094124.GO30453@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 24 Nov 2008 16:43:05 -0500
Message-Id: <1227562985.7622.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-11-23 at 10:41 +0100, Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > Q2: how to ftrace s2ram and resume?  I attempted to do it, but the 
> > > trace output is always filled with "resume" related functions when 
> > > it started up, which is only logical.
> > 
> > The tracing is disabled during suspend/resume, so you can't.
> 
> i think we could lift this restriction now that dftrace is gone for 
> good - which was causing most of the trouble.

The suspend resume problem did not happen with the dtrace. But whenever
there is a trace happening. It would fail with the stack tracer on with
the static function tracer.

The problem is that there are several functions in resume that are
called without first setting up smp_processor_id().  That is, if you
call smp_processor_id() it will crash the system. The function tracer
uses smp_processor_id() to stop recursion (per_cpu disabled variable).

Anything that actually tries to use the ring buffer will also crash,
since it too will use smp_processor_id to find the per cpu ring buffer
to write to.

-- Steve

> 
>   41108eb10142e0552f2de1e4c0675b108c5f018f
>   f42ac38c59e0a03d6da0c24a63fb211393f484b0
> 
> Completely untested patch below. Peter, does it work for you?
> 


