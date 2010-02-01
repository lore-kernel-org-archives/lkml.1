Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0BAP5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:57:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab0BAP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:57:48 -0500
Date: Mon, 1 Feb 2010 07:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Message-Id: <20100201075706.69b1d2c0.akpm@linux-foundation.org>
In-Reply-To: <201002011630.04281.rjw@sisk.pl>
References: <alpine.LFD.2.00.1001221841490.2266@localhost>
	<201001252237.42545.rjw@sisk.pl>
	<alpine.LFD.2.00.1002011527580.5334@localhost>
	<201002011630.04281.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010 16:30:04 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 01 February 2010, Sebastian Ott wrote:
> > Hi Rafael,
> > 
> > since you didn't like the idea of calling the driver callbacks with just
> > one cpu enabled, we gave your patch: "MM / PM: Force GFP_NOIO during
> > suspend/hibernation and resume" a try and i can confirm that this
> > fixes the issue on s390.
> 
> Great, thanks for testing!
> 
> > Will this go in 2.6.33/stable?
> 
> That depends on Andrew, actually.
> 
> Andrew, what do you think of the patch at:
> http://patchwork.kernel.org/patch/74740/mbox/ ?
> 
> It helps people and I don't see any major drawbacks of it.
> 

Seems sane.  A couple of minor things:

- the names mm_force_noio_allocations() and mm_allow_io_allocations()
  are a bit sucky.  Asymmetrical.

- the functions don't nest: if someone calls
  mm_force_noio_allocations() twice in succession then the kernel is
  all mucked up.  Why not:

gfp_t mm_set_gfp_mask(gfp_t mask)
{
	gfp_t ret = gfp_allowed_mask;

	gfp_allowed_mask = mask;
	return ret;
}

which is of course racy :)  Could add a local spinlock if really worried.

All your current callers can easily save the old value in a local.
