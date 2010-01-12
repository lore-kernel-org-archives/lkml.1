Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788Ab0ALEzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0ALEzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 23:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775Ab0ALEzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 23:55:00 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:65195 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0ALEzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 23:55:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pLONBffhrZ/Ng1IQOIOqXiub7A3akcJSQ9FCc9wV8vZbK8vIPyktHg9VCXCTh9IJZV
         52K5f4e8tM6qjN8QGW/1c51Kj8Pu/eRv6lxewC2LPnAJhMqvf6JE/ldf4MdqMHY68pnB
         VTuAmGEat8EsApPD8sWCLa0CArDsJ7lPRdbGc=
Date: Tue, 12 Jan 2010 05:54:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Message-ID: <20100112045454.GJ5243@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 05:56:08PM +0530, Srikar Dronamraju wrote:
> This patch implements ftrace plugin for uprobes.
> 
> Description:
> Ftrace plugin provides an interface to dump data at a given address, top of
> the stack and function arguments when a user program calls a specific
> function.


So, as told before, ftrace plugins tend to be relegated to
obsolescence and I first suggested to plug this into kprobe
events so that we have a unified interface to control/create
u|k|kret probe events.

But after digging more into first appearances, uprobe creation
can follow the kprobes creation flow.

kprobe can be created whenever we want. This is about probing
kernel text and it is already there so that we can set the
probe, default deactivated, in advance.

This is much more tricky in the case of uprobes as I see two
ways to work with it:

- probing on an already running process
- probing on a process we are about to run

Now say we create to create a uprobe trace event for an already
running process. No problem in the workflow, we just need to
set the address and the pid. Fine.

Now what if I want to launch ls and want to profile a function
inside. What can I do with a trace event. I can't create the
probe event based on a pid as I don't know it in advance.
I could give it the ls cmdline and it manages to activate
on the next ls launched. This is racy as another ls can
be launched concurrently.

So I can only say there that an ftrace plugin or an ftrace trace
event would be only a half-useful interface to exploit utrace
possibilities because it only lets us trace already running
apps. Moreover I bet the most chosen workflow to profile/trace
uprobes is by launching an app and profile it from the beginning,
not by profiling an already running one, which makes an ftrace
interface even less than half useful there.

ftrace is cool to trace the kernel, but this kind of tricky
userspace tracing workflow is not adapted to it.

What do you think?

