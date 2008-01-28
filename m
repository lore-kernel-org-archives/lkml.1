Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbYA1Xcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbYA1Xcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYA1Xca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:32:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43871 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763693AbYA1Xc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:32:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479E65E5.4060307@s5r6.in-berlin.de>
Date: Tue, 29 Jan 2008 00:31:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8?= =?ISO-8859-1?Q?gsberg?= 
	<krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: fix "kobject_add failed for fw* with
 -EEXIST"
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de> <200801281148.54017.jwilson@redhat.com> <479E29F2.7020307@s5r6.in-berlin.de>
In-Reply-To: <479E29F2.7020307@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> But the interaction with userspace processes opening /dev/fwX while the
> respective node is being shut down gave me headaches.  I am still not
> entirely sure if I got it right in the patch update, i.e. if it is free
> from deadlocks.  fw_device_shutdown() and fw_device_op_open() can be
> entered at the same time.  Would device_unregister() have to acquire a
> driver core lock which open() already took?  If yes, device_unregister()
> would be blocked on this lock while fw_device_op_open() is blocked on
> idr_rwsem.
> 
> So why did I move device_unregister() into the idr_rwsem protected
> section in the first place?  That's because I wanted to guarantee that
> fw_device_op_open() wouldn't look up a fw_device which is just in the
> process of being unregistered.  But maybe we don't even need this guarantee.

Did some further thinking:  Yes, I have to guarantee that the pointer
which the lookup in the idr tree returned is valid.

But I don't have to shove device_unregister() into the idr_rwsem locked
section.  Instead, I can (and actually should) increment the device's
refcount when I stick the device pointer into the idr tree.  (And of
course I decrease the refcount again when I remove the pointer from the
idr tree.)

Will probably post another update tomorrow.
-- 
Stefan Richter
-=====-==--- ---= ===-=
http://arcgraph.de/sr/
