Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYG3Jop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYG3Jop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbYG3JoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:44:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759951AbYG3JoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:44:10 -0400
Date: Wed, 30 Jul 2008 02:43:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: Keith Owens <kaos@ocs.com.au>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch] IA64: only call up() in salinfo_work_to_do() if
 down_trylock() was successful
Message-Id: <20080730024329.404eccc3.akpm@linux-foundation.org>
In-Reply-To: <20080729130742.GA20158@verge.net.au>
References: <20080729094718.GA5247@verge.net.au>
	<1163.1217335629@ocs10w>
	<20080729130742.GA20158@verge.net.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:07:45 +1000 Simon Horman <horms@verge.net.au> wrote:

> On Tue, Jul 29, 2008 at 10:47:09PM +1000, Keith Owens wrote:
> > Simon Horman (on Tue, 29 Jul 2008 19:47:20 +1000) wrote:
> > >Aesthetic issues aside is it safe to call up() if down_trylock() failed?
> > >
> > >arch/ia64/kernel/salinfo.c: In function `salinfo_work_to_do':
> > >arch/ia64/kernel/salinfo.c:195: warning: ignoring return value of `down_trylock'
> > >
> > >Signed-off-by: Simon Horman <horms@verge.net.au>
> > >
> > >Index: linux-2.6/arch/ia64/kernel/salinfo.c
> > >===================================================================
> > >--- linux-2.6.orig/arch/ia64/kernel/salinfo.c	2008-07-29 19:06:33.000000000 +1000
> > >+++ linux-2.6/arch/ia64/kernel/salinfo.c	2008-07-29 19:40:02.000000000 +1000
> > >@@ -192,8 +192,8 @@ struct salinfo_platform_oemdata_parms {
> > > static void
> > > salinfo_work_to_do(struct salinfo_data *data)
> > > {
> > >-	down_trylock(&data->mutex);
> > >-	up(&data->mutex);
> > >+	if (down_trylock(&data->mutex) == 0)
> > >+		up(&data->mutex);
> > > }
> > > 
> > > static void
> > 
> > NAK.  The whole point of this function is to set the mutex to the up
> > state, irrespective of whether it was already down or not.  Tracking
> > the state of data->mutex in all the possible contexts is just too
> > fragile, especially since it can be modified from NMI context.
> > salinfo_work_to_do() ensures that the mtuex ends in the up state.

boggle.  I daren't look.

> > To remove the warning, just stick '(void)' in front of down_trylock().
> 
> Thanks, will do.
> 

For gawd's sake add a comment there too.
