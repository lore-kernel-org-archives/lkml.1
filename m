Return-Path: <linux-kernel-owner+w=401wt.eu-S1761865AbYA1Qt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865AbYA1Qt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYA1QtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:49:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbYA1QtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:49:17 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: fix "kobject_add failed for fw* with -EEXIST"
Date: Mon, 28 Jan 2008 11:48:53 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281148.54017.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 12:20:40 pm Stefan Richter wrote:
> There is a race between shutdown and creation of devices:  fw-core may
> attempt to add a device with the same name of an already existing
> device.  http://bugzilla.kernel.org/show_bug.cgi?id=9828
>
> Impact of the bug:  Happens rarely, forces the user to unplug and replug
> the new device to get it working.

If you're crazy enough to set up a software raid array on two firewire drives 
that end up contending for the fwX device, its much worse than simply having 
to unplug and replug though, since all hell breaks loose at the fs level and 
the array level.

We may have another issue there though, as when this happened to me, the md 
layer apparently never noticed (after ~6 hours) that one of the array members 
had disappeared -- not sure if that's firewire's fault or md's though... This 
will presumably avoid this situation entirely, but worth noting that there 
may still be somewhere we need to better communicate status to an upper 
layer.

> The fix moves deregistration of the minor number and device_unregister()
> into a common rw_sem protected section.
>
> We also move the ref count increment from fw_device_op_open into an
> rw_sem protected section with the lookup of the device, so that the
> device pointer can't become invalid between lookup and usage.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Looks straight-forward enough, and I'll give these a spin shortly and see if I 
can reproduce the situation I was hitting with my raid array...


-- 
Jarod Wilson
jwilson@redhat.com
