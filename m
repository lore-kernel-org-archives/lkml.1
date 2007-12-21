Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbXLUUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbXLUUAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXLUUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:00:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbXLUUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:00:33 -0500
Date: Fri, 21 Dec 2007 12:00:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, "Pavel Machek" <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org, Dave Airlie <airlied@linux.ie>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70 --
 (triggered by "cat /proc/iomem" AFTER suspend-to-disk/resume)
Message-Id: <20071221120000.b319b735.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712210806i7f020a71k8c552953f7aeef4d@mail.gmail.com>
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	<4769F409.6030300@gmail.com>
	<4769FF37.5060308@gmail.com>
	<476A703B.50804@gmail.com>
	<20071220093206.22f319b0.akpm@linux-foundation.org>
	<a44ae5cd0712202158u31c8b4e1lf5b0df89dde20e7e@mail.gmail.com>
	<20071220222913.92a2c19f.akpm@linux-foundation.org>
	<a44ae5cd0712210806i7f020a71k8c552953f7aeef4d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 11:06:49 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> > >
> > > How do I determine what comes next?
> > >
> >
> > By comparing it with the /proc/iomem from prior to suspending the machine.
> >
> 
> The offending information seems to be "90000000-90000fff : Intel Flush Page"

ah-hah.  git-agpgart.patch

> I hope this helps,

It does, thanks.

Dave, a `cat /proc/iomem' crashes after a suspend/resume cycle when it
reaches the intel_private.ifp_resource record.


intel_i915_configure() is called on each resume and it calls
intel_i9xx_setup_flush() which zeroes out the already-registered `struct
resource', causing core kernel to oops over a deref of
parent/sibling/child.

Probably this:

--- a/drivers/char/agp/intel-agp.c~a
+++ a/drivers/char/agp/intel-agp.c
@@ -883,8 +883,6 @@ static void intel_i965_g33_setup_chipset
 static void intel_i9xx_setup_flush(void)
 {
 	/* setup a resource for this object */
-	memset(&intel_private.ifp_resource, 0, sizeof(intel_private.ifp_resource));
-
 	intel_private.ifp_resource.name = "Intel Flush Page";
 	intel_private.ifp_resource.flags = IORESOURCE_MEM;
 
_


will be enough to prevent the crash, but I suspect a bit more than that
will be needed.
