Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZHKS7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZHKS7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZHKS7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:59:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39922 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751288AbZHKS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:59:54 -0400
Date: Tue, 11 Aug 2009 14:59:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
In-Reply-To: <200908112012.13361.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908111438230.5845-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009, Rafael J. Wysocki wrote:

> > The general algorithm for maximum parallelism goes as follows: Start by
> > resuming (in parallel) all the devices which don't depend on anything
> > else.  Each time a resume finishes, you go on to resume (in parallel)
> > all the devices which depend only on resumed devices and which haven't
> > yet started to resume.
> > 
> > As described, this can require a large number of threads.  It also
> > requires detailed knowledge of which devices depend on others, which we
> > don't have.
> 
> It's even more complicated than that.
> 
> Assume we have 7 devices, A-G, such that A is the parent of B and C,
> B is the parent of D and E, and C is the parent of F and G.  Assume in addition
> that the PM dependencies between the devices are fully reflected by the
> device tree structure (ie. there are no dependencies that aren't reflected
> parent-child relationships) and that B and G take 0.5 s to resume while the
> others take < 1 ms each.  So, the total sequential resume time is
> 2 s + O(1 ms).
> 
> Now, if we used the above algorithm, we'd first resume DEFG which would take
> 1 s because of G, then we'd resume BC which would take 1 s because of B and
> the total resume time is again 2 s + O(1 ms).

(You probably mean "suspend" instead of "resume".)

No, you misunderstood my description.  We'd start out by suspending
DEFG.  DEF will finish quickly, at which time we would start suspending 
B because all its dependencies are satisfied.  When G finishes we would 
start suspending C.  When B and C are both finished, we would suspend 
A.  Total time would be about 1 s because B would be started shortly 
after G.

> However, one can observe that B doesn't need to wait for G to resume, because
> they are independent of each other.  So, we can resume BDE in parallel with
> CFG, while of course DE have to wait for B and so on, but this way we can
> theoretically reduce the total resume time to 1 s + O(1 ms).
> 
> The question is how to do that and it seems to me that we can use completions
> for this purpose.  Namely, add a completion to each device with the following
> rules:
> 1) all completions are reset before dpm_resume(),
> 2) before executing the ->resume() callback for device D, we wait for the
>    completion of the D's parent,
> 3) we complete the D's completion after executing its ->resume() callback.
> Also, the items executed in parallel are now the "wait for the parent's
> completion, run our callback and complete our completion" things.

Yes, that's essentially what I described.

> At first sight I don't see anything fundamentally wrong with this approach.

Nothing fundamentally wrong.  The problems come in the details.  Most
notably, the dependencies that are not reflected in the tree structure.

In practice, rather than completions I'd recommend using a pool of
threads together with a single wait queue and a list of devices which
_might_ be ready.  Initially this list can contain every device.

Each time a thread wakes up it scans the list, removing devices that
aren't actually ready yet (i.e., the dependencies aren't satisfied).  
If it doesn't find any devices that are ready, it goes back to sleep.  
When it finds a device that _is_ ready, it wakes up another thread and
invokes the callback.  When the callback is done, the thread adds to
the list all devices that depend on the one just finished.  Then it
goes back to scanning the list.

Alan Stern

