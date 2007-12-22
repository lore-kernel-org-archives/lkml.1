Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXLVPZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXLVPZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 10:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXLVPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 10:25:04 -0500
Received: from marge.padd.com ([66.127.62.138]:55616 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbXLVPZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 10:25:03 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 10:25:03 EST
Date: Sat, 22 Dec 2007 10:15:59 -0500
From: Pete Wyckoff <pw@osc.edu>
To: David Dillow <dave@thedillows.org>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: list corruption on ib_srp load in v2.6.24-rc5
Message-ID: <20071222151559.GB10085@osc.edu>
References: <1198273973.9979.34.camel@lap75545.ornl.gov> <1198275532.9979.43.camel@lap75545.ornl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198275532.9979.43.camel@lap75545.ornl.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dave@thedillows.org wrote on Fri, 21 Dec 2007 17:18 -0500:
> On Fri, 2007-12-21 at 16:52 -0500, David Dillow wrote:
> > I'm getting the following oops when doing the following commands:
> > 
> > modprobe ib_srp
> > <add targets(s) to ib_srp using sysfs>
> > rmmod ib_srp
> > modprobe ib_srp
> > <OOPS>
> > 
> > I'm going to try and track down how the list is getting corrupted; it
> > looks like attribute_container_list in
> > drivers/base/attribute_container.c is the one getting corrupted.
> 
> Ok, found the culprit, now to figure out the motive and fix it.
> 
> ib_srp's srp_cleanup_module calls srp_release_transport(), which calls
> transport_container_unregister() for the rport_attr_cont member of
> struct srp_internal.
> 
> That last unregister call is returning -EBUSY, but it gets ignored, and
> the list node gets erased (or just reused) when the module's text/memory
> is free'd.
> 
> Now, to see if ib_srp should be waiting for everything to be destroyed
> before calling srp_release_transport(), or if it is just not removing
> some attributes properly.

I don't see where srp_cleanup_module() is calling srp_remove_host().
That is the likely way that transport devices should be made to go
away.  Something on the order of srp_remove_work().

Or srp_remove_one() except with a call to srp_remove_host() may be
necessary.  In fact, maybe just adding that call will fix it, as
ib_unregister_client should drive the remove function.  Guesses, all
this.

		-- Pete
