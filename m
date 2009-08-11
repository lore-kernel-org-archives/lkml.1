Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZHKSLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZHKSLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZHKSLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:11:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbZHKSLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:11:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Tue, 11 Aug 2009 20:12:13 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
References: <Pine.LNX.4.44L0.0908111148060.2562-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908111148060.2562-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908112012.13361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 August 2009, Alan Stern wrote:
> On Tue, 11 Aug 2009, Rafael J. Wysocki wrote:
> 
> > In fact, we don't need the layers at all.  The only thing we have to assure is
> > that, during resume, the devices given device depends on will be handled
> > before we start to handle this particular device (inversely during suspend).
> > 
> > Please note that we're not even allowed to start executing the device's
> > resume callback before the callbacks of the devices it depends on have
> > returned (the same applies to the suspend callbacks, but the other way around).
> 
> The general algorithm for maximum parallelism goes as follows: Start by
> resuming (in parallel) all the devices which don't depend on anything
> else.  Each time a resume finishes, you go on to resume (in parallel)
> all the devices which depend only on resumed devices and which haven't
> yet started to resume.
> 
> As described, this can require a large number of threads.  It also
> requires detailed knowledge of which devices depend on others, which we
> don't have.

It's even more complicated than that.

Assume we have 7 devices, A-G, such that A is the parent of B and C,
B is the parent of D and E, and C is the parent of F and G.  Assume in addition
that the PM dependencies between the devices are fully reflected by the
device tree structure (ie. there are no dependencies that aren't reflected
parent-child relationships) and that B and G take 0.5 s to resume while the
others take < 1 ms each.  So, the total sequential resume time is
2 s + O(1 ms).

Now, if we used the above algorithm, we'd first resume DEFG which would take
1 s because of G, then we'd resume BC which would take 1 s because of B and
the total resume time is again 2 s + O(1 ms).

However, one can observe that B doesn't need to wait for G to resume, because
they are independent of each other.  So, we can resume BDE in parallel with
CFG, while of course DE have to wait for B and so on, but this way we can
theoretically reduce the total resume time to 1 s + O(1 ms).

The question is how to do that and it seems to me that we can use completions
for this purpose.  Namely, add a completion to each device with the following
rules:
1) all completions are reset before dpm_resume(),
2) before executing the ->resume() callback for device D, we wait for the
   completion of the D's parent,
3) we complete the D's completion after executing its ->resume() callback.
Also, the items executed in parallel are now the "wait for the parent's
completion, run our callback and complete our completion" things.

At first sight I don't see anything fundamentally wrong with this approach.

Thanks,
Rafael
