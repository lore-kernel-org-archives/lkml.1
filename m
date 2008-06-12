Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYFLPzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYFLPzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYFLPzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:55:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYFLPze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:55:34 -0400
Date: Thu, 12 Jun 2008 11:53:32 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080612155332.GA16658@redhat.com>
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213280823.31518.114.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jun 12, 2008 at 04:27:03PM +0200, Peter Zijlstra wrote:
> [...]
> > Well, the string contains each field name and type. Therefore, SystemTAP
> > can hook on a marker and parse the string looking for some elements by
> > passing a NULL format string upon probe registration. Alternatively, it
> > can provide the exact format string expected when it registers its probe
> > to the marker and a check will be done to verify that the format string
> > passed along with the registered probe matches the marker format string.
> 
> Yes, I get that, its one of the ugliest things I've met in this whole
> marker story. Why can't stap not insert a normal trace handler that
> extracts the information from prev/next it wants? [...]

Think this through.  How should systemtap (or another user-space
separate-compiled tool like lttng) do this exactly?

(a) rely on debugging information?  Even assuming we could get proper
    anchors (PC addresses or unambiguous type names) to start
    searching dwarf data, we lose a key attractions of markers: that
    it can robustly transfer data *without* dwarf data kept around.

(b) rely on hand-written C code (prototypes, pointer derefrencing
    wrappers) distributed with systemtap?  Not only would this be a
    brittle maintenance pain in the form of cude duplication, but then
    errors in it couldn't even be detected until the final C
    compilation stage.  That would make a lousy user experience.

(c) have systemtap try to parse the mhiramat-proposed "(struct
    task_struct * next, struct task_struct * prev)" format strings?
    Then we're asking systemtap to parse potentially general C type
    expressions, find the kernel headers that declare the types?
    Parse available subfields?  That seems too much to ask for.

(d) or another way?


- FChE
