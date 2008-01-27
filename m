Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYA0S12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYA0S12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYA0S1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:27:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54301 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYA0S1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:27:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 Jan 2008 19:26:33 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-sbp2: don't retry login or reconnect after
 unplug
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.98202457f6ba93dd@s5r6.in-berlin.de>
Message-ID: <tkrat.b69dbd0ef9978d09@s5r6.in-berlin.de>
References: <tkrat.98202457f6ba93dd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> If a device is being unplugged while fw-sbp2 had a login or reconnect on
> schedule, it would take about half a minute to shut the fw_unit down:
> 
> Jan 27 18:34:54 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0 retries)
> <unplug>
> Jan 27 18:34:59 stein firewire_sbp2: sbp2_scsi_abort
> Jan 27 18:34:59 stein scsi 25:0:0:0: Device offlined - not ready after error recovery
> Jan 27 18:35:01 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:06 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:12 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:17 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:22 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:27 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:32 stein firewire_sbp2: orb reply timed out, rcode=0x11
> Jan 27 18:35:32 stein firewire_sbp2: failed to login to fw2.0 LUN 0000
> Jan 27 18:35:32 stein firewire_sbp2: released fw2.0
> 
> After this patch, typically only a few seconds spent in __scsi_add_device
> remain:
> 
> Jan 27 19:05:50 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0 retries)
> <unplug>
> Jan 27 19:05:56 stein firewire_sbp2: sbp2_scsi_abort
> Jan 27 19:05:56 stein scsi 33:0:0:0: Device offlined - not ready after error recovery
> Jan 27 19:05:56 stein firewire_sbp2: released fw2.0
> 
> The benefit of this is negligible on simple setups.  But on buses with
> several devices, we should avoid any unnecessary blockade of fw-sbp2's
> workqueue thread.

There is an error in the last sentences.  The time spent sleeping in
workqueue jobs is the same before and after.  What this patch only
avoids are a few wasted CPU cycles, irritating log messages, and
needlessly prolonged lifetime of a few driver objects.

However, less noise in the syslog may already be enough justification
for this patch.
-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/

