Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbXGQHBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbXGQHBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXGQHAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:00:55 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:52991 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbXGQHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:00:54 -0400
Date: Tue, 17 Jul 2007 12:30:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul =?utf-8?B?KOWuneeRoCk=?= Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@sw.ru>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com
Subject: Re: Containers: css_put() dilemma
Message-ID: <20070717070031.GA22410@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <469BBE00.8000709@linux.vnet.ibm.com> <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com> <469C2792.6050009@linux.vnet.ibm.com> <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 07:35:01PM -0700, Paul (宝瑠) Menage wrote:
> On 7/16/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> >-       if (notify_on_release(cont)) {
> >+       if (atomic_dec_and_test(&css->refcnt) && notify_on_release(cont)) {
> 
> This seems like a good idea, as long as atomic_dec_and_test() isn't
> noticeably more expensive than atomic_dec(). I assume it shouldn't
> need to be, since the bus locking operations are presumably the same
> in each case.
> 
> >                mutex_lock(&container_mutex);
> >                set_bit(CONT_RELEASABLE, &cont->flags);
> >-               if (atomic_dec_and_test(&css->refcnt)) {
> >-                       check_for_release(cont);
> >-               }
> >+               check_for_release(cont);
> >                mutex_unlock(&container_mutex);
> >
> >That way we set the CONT_RELEASABLE bit only when the ref count drops
> >to zero.
> >
> 
> That's probably a good idea, in conjunction with another part of my
> patch for this that frees container objects under RCU - as soon as you
> do the atomic_dec_and_test(), then in theory some other thread could
> delete the container (since we're no longer going to be taking
> container_mutex in this function). But as long as the container object
> remains valid until synchronize_rcu() completes, then we can safely
> set the CONT_RELEASABLE bit on it.
> 
> >
> >Yes, that is correct, the advantage is that with can_destroy() we
> >don't need to go through release synchronization each time we do
> >a css_put().
> 
> I think the amount of release synchronization *needed* is going to be
> the same whether you have the refcounting done in the subsystem or in
> the framework. But I agree that right now we're doing one more atomic
> op than we strictly need to, and can remove it.
> 
> Paul

Hi, Paul/Andrew

Would you accept this fix, while we wait for the complete solution.
It worked for me quite well.


Description

Stop checking if the container can be released every time we do css_put().
A better solution that avoids container_mutex has been suggested by
Paul, but meanwhile, to get containers working correctly, this fix
would be very useful.

Signed-off-by: <balbir@linux.vnet.ibm.com>
---

 kernel/container.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/container.c~container-css-put-on-refcount-zero kernel/container.c
--- linux-2.6.22-rc6/kernel/container.c~container-css-put-on-refcount-zero	2007-07-17 12:18:52.000000000 +0530
+++ linux-2.6.22-rc6-balbir/kernel/container.c	2007-07-17 12:23:29.000000000 +0530
@@ -2515,15 +2515,11 @@ static void check_for_release(struct con
 void css_put(struct container_subsys_state *css)
 {
 	struct container *cont = css->container;
-	if (notify_on_release(cont)) {
+	if (atomic_dec_and_test(&css->refcnt) && notify_on_release(cont)) {
 		mutex_lock(&container_mutex);
 		set_bit(CONT_RELEASABLE, &cont->flags);
-		if (atomic_dec_and_test(&css->refcnt)) {
-			check_for_release(cont);
-		}
+		check_for_release(cont);
 		mutex_unlock(&container_mutex);
-	} else {
-		atomic_dec(&css->refcnt);
 	}
 }
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
