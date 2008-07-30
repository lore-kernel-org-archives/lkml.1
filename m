Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYG3LmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYG3LmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYG3LmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:42:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYG3LmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:42:03 -0400
Date: Wed, 30 Jul 2008 07:40:35 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Module : call synchronize_sched() between module exit() and free.
Message-ID: <20080730114035.GD27711@redhat.com>
References: <20080717155724.897537670@polymtl.ca> <20080729211543.GB17097@redhat.com> <20080729224115.GA5209@Krystal> <200807301140.59745.rusty@rustcorp.com.au> <20080730022751.GA15866@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730022751.GA15866@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jul 29, 2008 at 10:27:51PM -0400, Mathieu Desnoyers wrote:
> [...]
> Actually, it's not placing a marker/tracepoint in a module which causes
> a problem, this is a simple function call after all, and correctly dealt
> with by current module.c code.
> [...]

Just to spell it out, it is this scenario I'd like to see documented:

module-foo.c:
   foo() { ... trace_mark (foo, "..."); ... }

module-bar.c:
   setup() { ... marker_probe_register ("foo" , ..., &foo_handler ); }
   teardown() { ... marker_probe_unregister ("foo" , ..., &foo_handler ); }
   foo_handler() { }

1)  module-foo loads
2)  module-bar loads
3)  module-bar.c:setup()
4)  module-foo unloads

What happens here?  Certainly no more calls to foo_handler, but is
that all?  (Would it not be desirable for an active marker to cause
module-foo's refcount to increase, so as to prevent unloading at this
time?)

5)  module-bar.c:teardown()

Can this teardown code succeed fully even if module-foo is already
dead and gone?
  

- FChE
