Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXGQCWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXGQCWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 22:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXGQCWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 22:22:43 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:45427 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXGQCWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 22:22:42 -0400
Message-ID: <469C2792.6050009@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2007 07:51:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: =?windows-1252?Q?=22Paul_=28=3F=3F=29_Menage=22?= 
	<menage@google.com>
CC: Pavel Emelianov <xemul@sw.ru>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Containers: css_put() dilemma
References: <469BBE00.8000709@linux.vnet.ibm.com> <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
In-Reply-To: <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul (??) Menage wrote:
> On 7/16/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Hi, Paul,
>>
>> I've run into a strange problem with css_put(). After the changes for
>> notify_on_release(), the css_put() routine can now block and it blocks on
>> the container_mutex. This implies that css_put() cannot be called if
>>
>> 1. We cannot block
>> 2. We already hold the container_mutex
>>
>> The problem I have is that of preventing the destruction of my container
>> (when the user does rmdir). If the user migrates away all tasks and does
>> an rmdir, the only way to prevent the container from going away is
>> through
>> css_get() references. In my case, some pages have been allocated from the
>> container and hence I do not want it to go away, until all the pages
>> charged to it are freed. When I use css_get/put() to prevent destruction
>> I am blocked by the limitations of css_put() listed above.
>>
>> Do you have any recommendations for a cleaner solution? I suspect we'll
>> need can_destroy() callbacks (similar to can_attach()).
> 
> I think moving the release_list synchronization inside a separate
> spinlock, and thus not requiring container_mutex to be held for
> check_for_release(), is the simplest solution. I'll do that. I'm
> hoping to get a new set of patches to Andrew today or tomorrow.
> 

That sounds good to me. But I worry about having to do release synchronization
on every css_put(). The current patch I have, but does not work 100%
does the following (WARNING: white spaces ahead, do not use the patch
directly)

-       if (notify_on_release(cont)) {
+       if (atomic_dec_and_test(&css->refcnt) && notify_on_release(cont)) {
                mutex_lock(&container_mutex);
                set_bit(CONT_RELEASABLE, &cont->flags);
-               if (atomic_dec_and_test(&css->refcnt)) {
-                       check_for_release(cont);
-               }
+               check_for_release(cont);
                mutex_unlock(&container_mutex);

That way we set the CONT_RELEASABLE bit only when the ref count drops
to zero.


> Adding a can_destroy() callback is possible, but since I envisage that
> most subsystems that would want to implement it would basically be
> doing reference counting anyway, it seems worth having a generic
> reference counting mechanism in the framework. In particular, since
> once the container does become releasable due to all the
> subsystem-specific refcounts being released, we want to be able to
> invoke the release agent, we'll end up with the same synchronization
> problems that we have now if we just pushed everything into a
> can_destroy() method. (Unless the framework polled all can_destroy()
> methods for potentially-removable containers, which seems a bit
> nasty).
> 
> We can add can_destroy() if we encounter a situation that can't be
> handled by generic reference counting.
> 

Yes, that is correct, the advantage is that with can_destroy() we
don't need to go through release synchronization each time we do
a css_put(). May be the patch above will fix the problem along
with your release locking proposal.


> Paul
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
