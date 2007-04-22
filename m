Return-Path: <linux-kernel-owner+w=401wt.eu-S1030863AbXDVN2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863AbXDVN2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030876AbXDVN2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:28:17 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:33549 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030863AbXDVN2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:28:16 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 23:27:29 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
References: <200704221441.48897.kernel@kolivas.org> <200704222218.32754.kernel@kolivas.org> <20070422130725.GA16601@1wt.eu>
In-Reply-To: <20070422130725.GA16601@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222327.29496.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 23:07, Willy Tarreau wrote:
> On Sun, Apr 22, 2007 at 10:18:32PM +1000, Con Kolivas wrote:
> > On Sunday 22 April 2007 21:42, Con Kolivas wrote:
> >
> > Willy I'm still investigating the idle time and fluctuating load as a
> > separate issue.
>
> OK.
>
> > Is it possible the multiple ocbench processes are naturally
> > synchronising and desynchronising and choosing to sleep and/or run at the
> > same time?
>
> I don't think so. They're independant processes, and I insist on reducing
> their X work in order to ensure they don't get perturbated by external
> factor. Their work consist in looping 250 ms and waiting 750 ms, then
> displaying a new progress line.

Well if they always wait 750ms and they always do 250ms of work, they will 
never actually get their 250ms in a continuous stream, and may be waiting on 
a runqueue while working. What I mean then is that scheduling could cause 
that synchronising and desynchronising unwittingly by fluctuating the 
absolute time over which they get their 250ms. The sleep always takes 750ms, 
but the actual physical time over which they get their 250ms fluctuates by 
scheduling aliasing. If instead the code said "500ms has passed while I only 
did 250ms work so I should sleep for 250ms less" this aliasing would go away. 
Of course this is impossible since a fully loaded machine would mean each 
process should never sleep. I'm not arguing this is correct behaviour for the 
scheduler to cause this, mind you, nor am I saying it's wrong behaviour. I'm 
just trying to understand better how it happens and what (if anything) should 
be done about it. Overall their progress and cpu distribution appears 
identical, as you said. The difference is that the CFS design intrinsically 
manages this exact scenario by design with its sleep/run timing mechanism.

> > I can remove the idle time entirely by running ocbench at nice 19
> > which means they are all forced to run at basically the same time by the
> > scheduler.
>
> It may indicate some special handling of nice ?

By running them nice 19 the scheduler has effectively just sequentially 
schedules them, and there is no aliasing.

-- 
-ck
