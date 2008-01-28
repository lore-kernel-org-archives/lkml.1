Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbYA1Q1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbYA1Q1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYA1Q1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:27:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbYA1Q1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:27:10 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-sbp2: don't retry login or reconnect after unplug
Date: Mon, 28 Jan 2008 11:26:39 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
References: <tkrat.98202457f6ba93dd@s5r6.in-berlin.de>
In-Reply-To: <tkrat.98202457f6ba93dd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281126.39620.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 01:14:44 pm Stefan Richter wrote:
> If a device is being unplugged while fw-sbp2 had a login or reconnect on
> schedule, it would take about half a minute to shut the fw_unit down:
>
> Jan 27 18:34:54 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0
> retries) <unplug>
> Jan 27 18:34:59 stein firewire_sbp2: sbp2_scsi_abort
> Jan 27 18:34:59 stein scsi 25:0:0:0: Device offlined - not ready after
> error recovery Jan 27 18:35:01 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:06 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:12 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:17 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:22 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:27 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:32 stein firewire_sbp2: orb reply timed out,
> rcode=0x11 Jan 27 18:35:32 stein firewire_sbp2: failed to login to fw2.0
> LUN 0000 Jan 27 18:35:32 stein firewire_sbp2: released fw2.0
>
> After this patch, typically only a few seconds spent in __scsi_add_device
> remain:
>
> Jan 27 19:05:50 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0
> retries) <unplug>
> Jan 27 19:05:56 stein firewire_sbp2: sbp2_scsi_abort
> Jan 27 19:05:56 stein scsi 33:0:0:0: Device offlined - not ready after
> error recovery Jan 27 19:05:56 stein firewire_sbp2: released fw2.0
>
> The benefit of this is negligible on simple setups.  But on buses with
> several devices, we should avoid any unnecessary blockade of fw-sbp2's
> workqueue thread.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Looks good, makes sense to me, I've hit this one a few times myself. Even if 
we do end up still having the workqueue sleep time, nuking all the 
unnecessary spew and saving a few cycles is definitely worth it.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
