Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZKWNp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZKWNp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZKWNp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:45:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZKWNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:45:56 -0500
Subject: Re: [PATCH] perf_events: fix validate_event bug
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, eranian@google.com
In-Reply-To: <7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
References: <1256223091-6002-1-git-send-email-eranian@gmail.com>
	 <1258562785.3918.685.camel@laptop>
	 <7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 14:45:53 +0100
Message-ID: <1258983953.4531.456.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 14:34 +0100, stephane eranian wrote:

> > Won't this give very funny results for mixed pmu groups?
> >
> 
> What do you mean by 'mixed pmu groups'?

We currently have a number of struct pmu objects:

 perf_ops_generic
 perf_ops_cpu_clock
 perf_ops_task_clock

which are all software based PMUs, and one of:

 pmu        (arch/x86/kernel/cpu/perf_event.c)
 power_pmu  (arch/powerpc/kernel/perf_event.c)

To represent the hardware PMU.

Now say you mix software events and hardware events into a single group,
the loop in validate_group:

  list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
	if (!validate_event(&fake_pmu, sibling))
			return -ENOSPC;
  }

could pass a !hardware event into validate_event(), which currently
ignores it because event->pmu won't be &pmu, however if you remove that
check, it'll try and call x86 routines on a software event, which is
bound to go funny.

Now Frederic is going to make things more interesting by representing HW
breakpoints as another HW PMU (the distinction between hw/sw pmu is in
scheduling, you can always schedule a software event).

This weakens the !is_software_event(), in that !software doesn't tell
you which hardware event it is -- something which needs mending in your
more complex x86 constraints scheduling patch.

