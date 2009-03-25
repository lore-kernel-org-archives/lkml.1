Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZCYKvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZCYKvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZCYKvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:51:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZCYKvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:51:00 -0400
Date: Wed, 25 Mar 2009 11:50:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>
Subject: Re: [PATCH 58/61] dynamic debug: combine dprintk and dynamic printk
Message-ID: <20090325105023.GL2341@elte.hu>
References: <20090325001659.GA22461@kroah.com> <1237940825-22904-58-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237940825-22904-58-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@suse.de> wrote:

> From: Jason Baron <jbaron@redhat.com>
> 
> This patch combines Greg Bank's dprintk() work with the existing 
> dynamic printk patchset, we are now calling it 'dynamic debug'.
> 
> The new feature of this patchset is a richer /debugfs control file 
> interface, (an example output from my system is at the bottom), 
> which allows fined grained control over the the debug output. The 
> output can be controlled by function, file, module, format string, 
> and line number.

Hm, dunno this overlaps quite a bit with existing tracing 
facilities.

There seems to be serious consolidation potential here, if you want 
to reduce code and want to cooperate with existing tracing 
facilities.

In particlar, this facility seems to be a subset of what is already 
possible via trace_printk(). We could make every dprintk() site show 
up in /debug/tracing/events/dprintk/, and make it possible to toggle 
them on/off individually.

Furthermore it would also be possible to use the user-defined per 
tracepoint filter expression facility. That way each dprintk site 
can be (optionally) tailored individually.

For example we could enable such use:

  echo 'pid == 1234' > /debug/tracing/events/dprintk/fs/lockd/svc4proc.c:71/filter
  echo 1             > /debug/tracing/events/dprintk/fs/lockd/svc4proc.c:71/enabled

To tailor the following dprintk() in fs/lockd/svc4proc.c (line 71):

  static __be32
  nlm4svc_proc_null(struct svc_rqst *rqstp, void *argp, void *resp)
  {
          dprintk("lockd: NULL          called\n");
          return rpc_success;
  }

To only be printed for PID 1234.

Per subsystem filters would be available too. The subsystem 
maintainers dont have to do anything but place dprintk() calls - 
they'll show up under /debug/tracing/events/dprintk/ automatically.

Would you be interested in this?

	Ingo
