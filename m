Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZKIXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZKIXlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZKIXlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:41:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbZKIXlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:41:16 -0500
Date: Mon, 9 Nov 2009 15:40:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, device@lanana.org, rubini@vision.unipv.it,
       gregkh@suse.de, cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
 allocation
Message-Id: <20091109154041.509ab3f1.akpm@linux-foundation.org>
In-Reply-To: <20091109232922.GF12217@vespa.holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
	<20091109132836.6cf7f559.akpm@linux-foundation.org>
	<20091109220257.GD12217@vespa.holoscopio.com>
	<20091109232922.GF12217@vespa.holoscopio.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 21:29:25 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> On Mon, Nov 09, 2009 at 08:02:57PM -0200, Thadeu Lima de Souza Cascardo wrote:
> > > 
> > > Is that a bugfix for the existing code?
> > > 
> > > If so, please split that out into a separate patch which we can review
> > > and apply promptly while we consider the broader problem which you've
> > > identified.
> > 
> > We could consider buggy the caller which asks for the same device name
> > more than once, without unregistering the first device. But better safe
> > than sorry: we should protect the correct drivers from the buggy ones
> > and avoid a depletion of the minor numbers. And, in case the driver core
> > returns another error for another reason (from device_create), we do the
> > right thing.
> > 
> > I will send it right now.
> > 
> > Regards,
> > Cascardo.
> 
> I've just tried to create a single and separate patch, but that would
> let lots of related bugs around.
> 
> First of all, the current code does not use the bitmap idiom. Should I
> use it on my fix and let all the other bitmap manipulations as is, or
> should I use the current and less readable style?

If you think that the fix is needed in 2.6.32 and perhaps -stable then
yes please, something minimal is desired.

If you think that the bug is sufficiently minor that that the fix xcan
be deferred into 2.6.33 then no intermediate patch is needed.  Bear in
mind that others might disagree with your designation of the priority,
and they might want a fix which they can backport into their
2.6.29/2.6.30/etc kernels.

> Second, this single fix would match the same test currently in
> misc_deregister, which is broken, since it does not test for the 0
> minor.

I don't know what that means.

> Thus, I am sending a patch which fixes those two issues using the
> current style, a fix for the style itself, and a change from the current
> range to something that could have its range easily fixed.

Sounds good.

> However,
> regarding that last change, it will still use bitmaps, which may not be
> appropriate for large ranges.
> 
> Perhaps, using a idr instead of the list and bitmap couple, may be
> sensible. What do you think about it?

miscdev registration/deregistration is hardly a high-frequency
operation.  I'd opt for simplicity and compactness over speed here.
