Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZCDNHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZCDNHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZCDNHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:07:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCDNHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:07:06 -0500
Date: Wed, 4 Mar 2009 08:07:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] tracing: lockdep tracepoints
In-Reply-To: <20090304121258.GD6032@nowhere>
Message-ID: <alpine.DEB.2.00.0903040801580.7995@gandalf.stny.rr.com>
References: <1236164586.5330.7142.camel@laptop> <20090304112345.GB6032@nowhere> <1236166375.5330.7209.camel@laptop> <20090304114319.GA4916@elte.hu> <1236167883.5330.7264.camel@laptop> <20090304121258.GD6032@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Mar 2009, Frederic Weisbecker wrote:
> > 
> 
> 
> The TRACE_FIELD_SPECIAL is only used in case of complex assignment,
> those that can't be done in a simple "=" expression.
> 
> All you need is simply:
> 
> TRACE_FORMAT(lock_contended,
>      TPPROTO(struct lockdep_map *lock, unsigned long ip),
>      TPARGS(lock, ip),
>      TPFMT("%s", lock->name)
>      TRACE_STRUCT(
> 	TRACE_FIELD(char *, name, lock->name)
>      )
>      TPRAWFMT("%s");
> );


Nope, that wont work :-(  If this is saved to userspace, all the user 
would have is some hex value. If they have a copy of the vmlinux image, 
then they could probably translate that value, unless it was a module.

Perhaps something like:

 TRACE_EVENT_FORMAT(lock_contended,
	TPPROTO(struct lockdep_map *lock, unsigned long ip),
	TPARGS(lock, ip),
	TPFMT("%s", lock->name);
	TRACE_STRUCT(
		TRACE_FIELD_SPECIAL(char name[16], name,
			strncpy(name, lock->name, 16));
	),
	TPRAWFMT("%s")
 );

This would require those 16 bytes to be copied with the raw format, but 
then we would always have the name (first 16 bytes anyway) for later use.

-- Steve

