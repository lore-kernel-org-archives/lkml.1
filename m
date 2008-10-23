Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYJWPJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYJWPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYJWPJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:09:48 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56346 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYJWPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:09:48 -0400
Message-ID: <49009375.1070209@s5r6.in-berlin.de>
Date: Thu, 23 Oct 2008 17:08:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>, Dave Jones <davej@redhat.com>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: lockdep splat from ioctl and mmap fops sharing lock
References: <87ljwgj8p1.fsf@saeurebad.de> <87ej27jtvx.fsf@saeurebad.de>
In-Reply-To: <87ej27jtvx.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Johannes Weiner <hannes@saeurebad.de> writes:
> 
>> Hi,
>>
>> fb_mmap() is called under mmap_sem and acquires fb_info->lock.
>>
>> Since 3e680aae4e53ab "fb: convert lock/unlock_kernel() into local fb
>> mutex", fb_ioctl() takes fb_info->lock and does copy_to/from_user()
>> under it, which in turn might acquire mmap_sem.
> 
> More affected drivers:
> 
> agp_ioctl() doing usercopy under agp_fe.agp_mutex
> agp_mmap() taking agp_fe.agp_mutex under mmap_sem
> 
> dv1394_write() doing usercopy under video->mtx
> dv1394_mmap() taking video->mtx under mmap_sem

OK, it doesn't surprise me that I didn't notice this one myself:  The
video->mtx usage is old, but dv1394 is not frequently used anymore; I
for one don't test anything of it beyond loading and unloading.

> raw1394_ioctl() doing usercopy under fi->state_mutex
> raw1394_mmap() taking fi->state_mutex under mmap_sem

The state_mutex in raw1394 however was introduced by me in patches
written against 2.6.26 and 2.6.27-rcs.  And I tested the ioctls and I'd
like to think that I also tested mmaps.  But maybe I didn't.  Of course
I ahve all sorts of lockdep options enabled.

So, was the usage of mmap_sem changed after 2.6.27 or were my tests
insufficient?
-- 
Stefan Richter
-=====-==--- =-=- =-===
http://arcgraph.de/sr/
