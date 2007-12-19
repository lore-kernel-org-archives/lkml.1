Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXLSUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXLSUDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbXLSUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:03:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50336 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753671AbXLSUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:02:59 -0500
Date: Wed, 19 Dec 2007 12:02:52 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Walker <dwalker@mvista.com>
cc: Miles Lane <miles.lane@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-hardirq-W} -> {hardirq-on-W}
 usage -- pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1]
In-Reply-To: <1198092200.2716.49.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.64.0712191158140.28180@schroedinger.engr.sgi.com>
References: <a44ae5cd0712190517t7c80e15bv759fa5486dfca234@mail.gmail.com> 
 <47693385.1010901@gmail.com>  <1198089729.2716.45.camel@imap.mvista.com>
 <1198092200.2716.49.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Daniel Walker wrote:

> > It looks like the swsusp_save() calls drain_all_pages() , which calls
> > on_each_cpu() .. On return on_each_cpu() unconditionally enables
> > interrupts so the rest of the resume process has interrupt enable
> > (which , it looks like, shouldn't happen) and then you get the lockdep()
> > warning due to the above..
> > 
> > Not sure if this has been found already, or not?

Hmmm... It will unconditionally enable interrupts regardless how we call 
this. We could explicity save and restore interrrupts in 
swsusp_save() I guess. Why is swsusp_save() disabling interrupts?

> > Should drain_all_pages() really be drain_local_pages() ?
> 
> It looks like it was drain_local_pages, but the following patch
> 
> page-allocator-clean-up-pcp-draining-functions.patch
> 
> Changes that in -mm .. I added Christoph Lameter to the CC since it's
> his patch ..

We could reexport drain_local_pages() again but then I do not understand 
why we would only drain the pages of this processor and not of all other
processors as well. It seems that software suspend intend was to flush 
them all right?


