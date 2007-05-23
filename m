Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXEWMz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXEWMz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbXEWMzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:55:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbXEWMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ro9ZGfBNVwM/EUJrbZXFRZqKYIu9/A28B8USFmmgk4S5X1VIxpGN83RVdgZWHpXQbP+lbo9EZ7J6+7Vv/RG8e6u6SsO9UdeCQ73+8cUkAXT2HeT/lPjkj2tOIFrk1iVm6xS/v7yeIm1gyVg2DMmzLQBAHc2gptWDo0kEhO7USog=
Message-ID: <a781481a0705230555j6fcf46eav43cc95f6d1a7ae6f@mail.gmail.com>
Date: Wed, 23 May 2007 18:25:49 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: [PATCH] fix unchecked mutex_lock_interruptible (was Re: use mutex instead of semaphore in RocketPort driver)
Cc: "Simon Arlott" <simon@fire.lp0.eu>,
       "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Simon Arlott napsal(a):
> > On 22/05/07 21:06, Matthias Kaehlcke wrote:
> >> would the following resolve the problem?
> >>
> >> if(mutex_lock_interruptible(&info->write_mtx))         return
> >> -ERESTARTSYS
> >>
> >> thanks for your comments

Hum. I remember suggesting the fix when this came few weeks back,
somehow the older version seems to have made it into Linus' tree.

> > No. At least one user of tty_operations/tty_driver's write function
> > doesn't check the return value so it would never be retried, mutex_lock
> > should be used instead.

Replacing mutex_lock_interruptible() with a mutex_lock() could be a
change in behaviour visible to userspace. Best to continue to use
_interruptible. Returning EINTR would be safe choice because if
Simon's right that this isn't retried, we could end up breaking
userspace that isn't quite ready to see ERESTARTSYS coming out of
a write(2), but ...

> Who? There are some drivers that returns ERESTARTSYS from write function.

Right, several others in drivers/char/ do return ERESTARTSYS. Hope
somebody picks this up -- no email listed in MAINTAINERS for this.

---

Check the return of mutex_lock_interruptible() in drivers/char/rocket.c
and return ERESTARTSYS if we were interrupted.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 drivers/char/rocket.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

diff -ruNp a/drivers/char/rocket.c b/drivers/char/rocket.c
--- a/drivers/char/rocket.c	2007-05-20 04:11:54.000000000 +0530
+++ b/drivers/char/rocket.c	2007-05-23 18:14:35.000000000 +0530
@@ -1702,7 +1702,8 @@ static int rp_write(struct tty_struct *t
 	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
 		return 0;

-	mutex_lock_interruptible(&info->write_mtx);
+	if (mutex_lock_interruptible(&info->write_mtx))
+		return -ERESTARTSYS;

 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_write %d chars...", count);
