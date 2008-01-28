Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbYA1TRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbYA1TRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbYA1TQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:16:05 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59679 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762552AbYA1TQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:16:04 -0500
Message-ID: <479E29F2.7020307@s5r6.in-berlin.de>
Date: Mon, 28 Jan 2008 20:16:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8?= =?ISO-8859-1?Q?gsberg?= 
	<krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: fix "kobject_add failed for fw* with
 -EEXIST"
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de> <200801281148.54017.jwilson@redhat.com>
In-Reply-To: <200801281148.54017.jwilson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Looks straight-forward enough, and I'll give these a spin shortly and see if I 
> can reproduce the situation I was hitting with my raid array...

As far as the naming of devices is concerned, the bug and the necessary
fix are entirely obvious.

But the interaction with userspace processes opening /dev/fwX while the
respective node is being shut down gave me headaches.  I am still not
entirely sure if I got it right in the patch update, i.e. if it is free
from deadlocks.  fw_device_shutdown() and fw_device_op_open() can be
entered at the same time.  Would device_unregister() have to acquire a
driver core lock which open() already took?  If yes, device_unregister()
would be blocked on this lock while fw_device_op_open() is blocked on
idr_rwsem.

So why did I move device_unregister() into the idr_rwsem protected
section in the first place?  That's because I wanted to guarantee that
fw_device_op_open() wouldn't look up a fw_device which is just in the
process of being unregistered.  But maybe we don't even need this guarantee.

It would all be so easy if I knew how the driver core works.  :-/
-- 
Stefan Richter
-=====-==--- ---= ===--
http://arcgraph.de/sr/
