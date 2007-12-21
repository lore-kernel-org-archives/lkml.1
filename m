Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXLUXPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXLUXPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbXLUXPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:15:43 -0500
Received: from lap75545.ornl.gov ([160.91.210.54]:42806 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXLUXPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:15:43 -0500
X-Greylist: delayed 3399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 18:15:42 EST
Subject: Re: list corruption on ib_srp load in v2.6.24-rc5
From: David Dillow <dave@thedillows.org>
To: linux-kernel@vger.kernel.org
Cc: general@lists.openfabrics.org
In-Reply-To: <1198273973.9979.34.camel@lap75545.ornl.gov>
References: <1198273973.9979.34.camel@lap75545.ornl.gov>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Dec 2007 17:18:52 -0500
Message-Id: <1198275532.9979.43.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 16:52 -0500, David Dillow wrote:
> I'm getting the following oops when doing the following commands:
> 
> modprobe ib_srp
> <add targets(s) to ib_srp using sysfs>
> rmmod ib_srp
> modprobe ib_srp
> <OOPS>
> 
> I'm going to try and track down how the list is getting corrupted; it
> looks like attribute_container_list in
> drivers/base/attribute_container.c is the one getting corrupted.

Ok, found the culprit, now to figure out the motive and fix it.

ib_srp's srp_cleanup_module calls srp_release_transport(), which calls
transport_container_unregister() for the rport_attr_cont member of
struct srp_internal.

That last unregister call is returning -EBUSY, but it gets ignored, and
the list node gets erased (or just reused) when the module's text/memory
is free'd.

Now, to see if ib_srp should be waiting for everything to be destroyed
before calling srp_release_transport(), or if it is just not removing
some attributes properly.

That's a next week thing if no one beats me to it.
