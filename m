Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYJ0Nip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYJ0Nip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYJ0Nih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:38:37 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38970 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYJ0Nig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:38:36 -0400
Message-ID: <4905C40F.8080809@s5r6.in-berlin.de>
Date: Mon, 27 Oct 2008 14:37:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux1394-devel@lists.sourceforge.net, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, Dan Dennedy <dan@dennedy.org>,
       Johannes Weiner <hannes@saeurebad.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug 11824][PATCH] ieee1394: raw1394: fix possible deadlock in
 multithreaded clients
References: <bug-11824-4803@http.bugzilla.kernel.org/> <4902F41E.5070306@s5r6.in-berlin.de> <tkrat.94e673551b87c230@s5r6.in-berlin.de> <20081027101303.GI8116@elte.hu>
In-Reply-To: <20081027101303.GI8116@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> Regression in 2.6.28-rc1:  When I added the new state_mutex which
>> prevents corruption of raw1394's internal state when accessed by
>> multithreaded client applications, the following possible though
>> highly unlikely deadlock slipped in:
>> 
>> Thread A:                  Thread B:
>>  - acquire mmap_sem         - raw1394_write() or raw1394_ioctl()
>>  - raw1394_mmap()           - acquire state_mutex
>>  - acquire state_mutex      - copy_to/from_user(), possible page fault:
>>                               acquire mmap_sem
>> 
>> The simplest fix is to use mutex_trylock() instead of mutex_lock() in
>> raw1394_mmap().
[...]
>> Since we have to use mutex_trylock() in raw1394_mmap() regardless
>> whether /dev/raw1394 was opened with O_NONBLOCK or not, we now use
>> mutex_trylock() unconditionally everywhere for state_mutex, just to have
>> consistent behavior.
[...]
>> Background:  That new state_mutex went only in because raw1394_ioctl()
>> already head some weak protection by the Big Kernel Lock, which I
>> removed for the general reasons pro BKL removal (get better performance
>> with local locks; make the locking clearer, easier to debug, more
>> reliable).
>> 
>>  drivers/ieee1394/raw1394.c |    9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>> 
>> Index: linux/drivers/ieee1394/raw1394.c
>> ===================================================================
>> --- linux.orig/drivers/ieee1394/raw1394.c
>> +++ linux/drivers/ieee1394/raw1394.c
>> @@ -2268,7 +2268,8 @@ static ssize_t raw1394_write(struct file
>>  		return -EFAULT;
>>  	}
>>  
>> -	mutex_lock(&fi->state_mutex);
>> +	if (!mutex_trylock(&fi->state_mutex))
>> +		return -EAGAIN;
>>  
>>  	switch (fi->state) {
>>  	case opened:
>> @@ -2548,7 +2549,8 @@ static int raw1394_mmap(struct file *fil
>>  	struct file_info *fi = file->private_data;
>>  	int ret;
>>  
>> -	mutex_lock(&fi->state_mutex);
>> +	if (!mutex_trylock(&fi->state_mutex))
>> +		return -EAGAIN;
>>  
>>  	if (fi->iso_state == RAW1394_ISO_INACTIVE)
>>  		ret = -EINVAL;
>> @@ -2669,7 +2671,8 @@ static long raw1394_ioctl(struct file *f
>>  		break;
>>  	}
>>  
>> -	mutex_lock(&fi->state_mutex);
>> +	if (!mutex_trylock(&fi->state_mutex))
>> +		return -EAGAIN;
> 
> So we can return a spurious -EAGAIN to user-space, if the state_mutex 
> is taken briefly by some other context?

.write() and .mmap() were not serialized against each other and against
.ioctl() at all in raw1394 before 2.6.28-rc1.  Only .ioctl() was
(somewhat) serialized against itself due to traditionally being
implemented as .ioctl() instead of .unlocked_ioctl().  If there were
ever concurrent userspace contexts accessing the same file handle, they
would have corrupted raw1394's internal state eventually.

Application developers have been advised all the time to access the file
handle only from a single thread, ever.

So, before:  Concurrent access resulted in hard to debug driver
malfunction, without clear error indication.

After:  Concurrent access results in -EAGAIN.

I.e. since concurrent access was so broken before that hopefully no
raw1394/libraw1394 client exists which did use a single handle in more
than one thread, we are quite free how we fix that.

Or at least that's how I understand the situation.  Would be good to
hear opinions from those who are more involved with libraw1394.
-- 
Stefan Richter
-=====-==--- =-=- ==-=-
http://arcgraph.de/sr/
