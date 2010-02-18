Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0BRSXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:23:11 -0500
Received: from 65-115-68-195.dia.static.qwest.net ([65.115.68.195]:3539 "EHLO
	chronus.3leafnetworks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754435Ab0BRSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:23:09 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 13:23:08 EST
Date: Thu, 18 Feb 2010 10:07:52 -0800
From: Scott Lurndal <scott.lurndal@3leafsystems.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu, mort@sgi.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 08/28] kdb: core for kgdb back end (2 of 2)
Message-ID: <20100218180752.GA11626@pendragon.3leafnetworks.com>
References: <m1zl37xhmm.fsf@fess.ebiederm.org> <4B7D5704.6060504@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7D5704.6060504@windriver.com>
User-Agent: Mutt/1.4.2.2i
X-OriginalArrivalTime: 18 Feb 2010 18:07:53.0444 (UTC) FILETIME=[4A432240:01CAB0C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:04:36AM -0600, Jason Wessel wrote:
> Eric W. Biederman wrote:
> > Jason Wessel <jason.wessel@windriver.com> writes:
> >
> >   
> >> This patch contains the hooks and instrumentation into kernel which
> >> live outside the kernel/debug directory, which the kdb core
> >> will call to run commands like lsmod, dmesg, bt etc...
> >>     
> >
> > You know this dropping the locks from vmalloc_info and swap_info
> > is down right ugly, and I don't believe it is safe.  That code
> > was not designed to run while the write_lock is held.
> >   
> 
> Perhaps we can find some middle ground.  I don't mind simply not
> allowing the information to be queried from kdb if the locks are not
> available. 

IIRC the original KDB would stop all the cpus when entered,
thus locking to avoid concurrent access to data
was not necessary when displaying kernel data structures.  However,
KDB user and developers were assumed to be aware that when KDB was
entered the system context was in an indeterminate state particularly
with respect to linked lists and other non-tabular data structures.

KDB code that displayed data structures which were kept in a non-table
data structure (linked list, tree, etc.) was be required to both
validate each pointer it tries to follow as well as ensure that it
detects loops (either by terminating the list traversal after a certain
number of elements or by allowing the KDB user to terminate the traversal
with e.g. 'q').

> 
> It looks to me like the original kdb took the approach of calling the
> setjmp() longjmp() and if there was any kind of fault, it long jumped
> back to the original context.  Obviously that doesn't solve any kind of
> problem with a list loop.

Yes.   The list loop was expected to be handled either by the display
code terminating after some number of traversal step or by the KDB user
terminating the command via the keyboard (e.g. 'q' at a more-type prompt).

If the new KDB framework allows other cpus to continue to run while kdb
data structure display commands are running, then much more care must
be taken in the display command code to avoid inconsistent data causing
loops or #PF.


scott
