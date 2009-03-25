Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZCYV2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZCYV2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZCYV2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:28:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbZCYV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:28:14 -0400
Date: Wed, 25 Mar 2009 14:20:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
Message-Id: <20090325142006.3ba0ee10.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903250840440.29264@localhost.localdomain>
References: <20090325051920.406564281@goodmis.org>
	<20090325052023.071564146@goodmis.org>
	<84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	<alpine.LFD.2.00.0903250840440.29264@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 08:50:44 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 25 Mar 2009, Pekka Enberg wrote:
> > On Wed, Mar 25, 2009 at 7:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > This makes sense, since we now encourage developers to just call kfree
> > > without checking for NULL.
> > 
> > But those are _error handling paths_ (at least supposed to be). I
> > wonder which call-sites are responsible for this. Can frtrace help us
> > here?
> 

-mm's profile-likely-unlikely-macros.patch gives the backtraces you're
looking for.

I agree, probably some particular callsite is doing something silly and
is skewing all the instrumentation.

We have at times identified callsites where kfree(0) is so likely that
"remove the NULL test" was an undesirable change.

Many many many kfree() callsites _know_ that the pointer isn't NULL. 
Having that test in kfree() was always stupid.  What we should do is to
have a kfree_it_isnt_null() for those callsites so they can omit the test
altogether.


