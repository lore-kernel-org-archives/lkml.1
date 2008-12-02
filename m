Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYLBUZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYLBUZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYLBUZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:25:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYLBUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:25:27 -0500
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
From: Steven Rostedt <srostedt@redhat.com>
To: Luis Henriques <henrix@sapo.pt>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081202194610.GA4864@hades>
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com>
	 <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com>
	 <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com>
	 <20081202190914.GA12115@hades>  <20081202194610.GA4864@hades>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 02 Dec 2008 15:25:09 -0500
Message-Id: <1228249509.4886.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Ingo too ]

On Tue, 2008-12-02 at 19:46 +0000, Luis Henriques wrote:
> (I am CC'ing to Steven Rostedt since he might be interested on this)
> 
> On Tue, Dec 02, 2008 at 07:09:14PM +0000, Luis Henriques wrote:

> I have some other information to had to my previous email.  However, I do not
> know whether it is related with my first bug report.
> 
> It looks like ftrace may stop the CPUs in some situations and I have been
> playing with ftrace for some time.  So, here's what I just did:  started ftrace
> with function tracer and then started kvm.  I got ugly crashes and apparently
> quite easy to reproduce (I get complete freeze or immediate reboot).
> 
> I did not investigated this issue and, again, it may not be related with my
> initial report but there's definitely something wrong here, right?
> 
> (just to refresh, I am using 2.6.28-rc6-00007-ged31348 in x86_64 machine)
> 

Hi,

ftrace only stops the CPUs on start up or shutdown of the function
tracer (i.e. echo function > /debugfs/tracing/current_tracer).  It does
not stop the CPUs at any other time.

Now what ftrace does do, is to call a tracing function at pretty much
every function call in the kernel. In most places this is fine, but
there are some cases that this can be an issue. For example, we can not
trace suspend and resume because on resume smp_processor_id() is
undefined, which ftrace uses.

The following must be available without recursion for the function
tracer to work:

  local_irq_save/restore
  smp_processor_id
  preempt_enable/disable_notrace
  atomic_inc/dec

There could be other things that might be causing the crash. Do you have
a crash dump and config available?

Thanks,

-- Steve


