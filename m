Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYIWR4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYIWR4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYIWR4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:56:44 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37352 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359AbYIWR4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:56:43 -0400
Date: Tue, 23 Sep 2008 23:25:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Martin Bligh <mbligh@google.com>, Tom Zanussi <zanussi@comcast.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923175500.GA3843@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <1222147545.6875.135.camel@charm-linux> <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 07:00:38AM -0700, Martin Bligh wrote:
> > - get rid of anything having to do with padding, nobody needs it and its
> > only affect has been to horribly distort and complicate a lot of the
> > code
> > - get rid of sub-buffers, they just cause confusion
> > - get rid of mmap, nobody uses it
> > - no sub-buffers and no mmap support means we can get rid of most of the
> > callbacks, and a lot of API confusion along with them
> > - add relay flags - they probably should have been used from the
> > beginning and options made explicit instead of being shoehorned into the
> > callback functions.
> 
> Actually, I think if you did all that, it'd be pretty close to what we
> want anyway ...

In the perspective of having a layered infrastructure, can we consider
the interfaces later added over relay (to be used as a wrapper), namely
relay_printk() and relay_dump()?

Also add the following features to it and we get close to the
functionality that is sought:

- Add callbacks to append fine-granular timestamp information depending
upon user's requirement
- Ability to provision more custom-defined control files that can suit
independent tracer's requirements

These interfaces already come along with the following features (some
repetition here from my previous email for the sake of completeness):

- Very minimal work required to log data using the interfaces. Usage is
made simple to resemble the printk(). Like

	struct relay_printk_data *tpk;
	tpk->parent_dir = "PARENT";
	tpk->dir = "DIR";
	relay_printk(tpk, <String to be output>);
	relay_dump(tpk, <Some binary data to output>); 

Output at:
	<debugfs_mount>/PARENT/DIR/<TRACE FILES>

- Assumes default values for most tunables, such as per-CPU buffer size,
relay-flags (such as global vs local per-cpu buffers, flight recorder vs
overwrite mode), thus reducing the work required for setting up these
interfaces. They can be over-written in case of advanced needs.

- Well defined control operations to start, stop tracing operations, status
files to indicate buffer overflow, etc.

- Given the recent patches that Tom Zanussi has sent to bring in the
erstwhile 'trace' functionality into relay itself, there can be a lot of
code-reduction in relay.c (in -mm) thereby leading to a light-weight
implementation.

Thanks,
K.Prasad

