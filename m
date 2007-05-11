Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbXEKGLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbXEKGLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbXEKGK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:10:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbXEKGK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:10:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=C5nohhEP6KhGkI4z0CdWwrK6DvTlYkvnlJXF2L0zoz18Q2Ml1wyj5CmyilAxNJJai
	UsRFXvitcOTEGu+eAk3wA==
Message-ID: <b040c32a0705102310m5ec647an2b3aa9f74e2ed450@mail.gmail.com>
Date: Thu, 10 May 2007 23:10:28 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-git11: BUG in loop.ko
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alexey Dobriyan" <adobriyan@sw.ru>
In-Reply-To: <20070509170521.ec2c9ae7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46425EC9.5070209@goop.org>
	 <20070509170521.ec2c9ae7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 09 May 2007 16:52:41 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> > Seems to be getting a 0 refcount.  I don't see anything in the recent
> > changes which might cause this, but this is relatively new behaviour.
> > It was working for me in the 2.6.21-pre time period, but I haven't tried
> > this since 2.6.21 was released.
> >
> > The BUG is actually triggered by the __module_get(THIS_MODULE) in
> > loop_set_fd.
>
> A few people have been playing with module refcounting lately.  Did you
> work out a reproduce-it recipe?

Ah, it's a mis-understanding on what kobj_probe_t function is suppose
to return on success.  When we open loop device that has not been
initialized, we probe it via:

do_open
  get_gendisk
    kobj_lookup
      loop_probe

Notice that in kobj_lookup(), when p->probe() returns non-zero value
(I presume it is an -ERRNO), it breaks out of the loop and propagate
the return value, otherwise, loops back to the beginning of the for
loop and retry, and in there get_disk() will be called via p->lock()
to get a ref against the module.

kobj_look_up(...) {
retry:
        mutex_lock(domain->lock);
        for (p = domain->probes[MAJOR(dev) % 255]; p; p = p->next) {
        ...
        if (kobj)
                return kobj;
        goto retry;
}

So loop_probe() mistakenly returned wrong status and leads to future
oops on inconsistent module ref count.  The following patch fixes the
issue.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 18cdd8c..40f7bc2 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1460,6 +1460,7 @@ static void loop_del_one(struct loop_device *lo)
 	kfree(lo);
 }

+/* return NULL for success, or return non-zero value if there are error */
 static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 {
 	unsigned int number = dev & MINORMASK;
@@ -1474,8 +1475,8 @@ static struct kobject *loop_probe
 	*part = 0;
 	if (IS_ERR(lo))
 		return (void *)lo;
-	else
-		return &lo->lo_disk->kobj;
+
+	return NULL;
 }

 static int __init loop_init(void)
