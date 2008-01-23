Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYAWRoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYAWRoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYAWRoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:44:23 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:9499 "EHLO
	outbound8-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049AbYAWRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:44:22 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47977E39.8000109@am.sony.com>
Date: Wed, 23 Jan 2008 09:49:45 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
 disabled
References: <20080123160236.969334052@goodmis.org> <20080123160441.236562634@goodmis.org> <1201107978.13596.16.camel@imap.mvista.com> <20080123172509.GC22229@Krystal>
In-Reply-To: <20080123172509.GC22229@Krystal>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2008 17:44:12.0620 (UTC) FILETIME=[90ADD8C0:01C85DE7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Can we change this for :
> if (!(irqs_disabled() && !oops_in_progress) && wake_klogd)
>   wake_up_klogd();

!oops_in_progress is already inside wake_up_klogd().

Also, I think you'd want that first '!' inside the parens.

I've been working on a system to handle deferred displaying
of printk messages, when printk is called in interrupt context.
Currently on a serial console if printk is called with
ints disabled, it can hold interrupts off for up to 20
milliseconds.

My solution was to set up a worker thread to handle deferred
printk activity.  I don't think this works for the oops case,
because you don't want to defer the output.  However, I can
post this code if you think it would help with this problem.

I hesitate to just drop the call to wake_up_klogd() without
some kind of mechanism call it later.  Waiting until the
next printk will work to drain the buffer, but could lead
to indefinite intervals with printks waiting to be logged.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

