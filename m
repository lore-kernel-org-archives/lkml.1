Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYHSBKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYHSBKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHSBKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:10:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53795 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYHSBKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:10:31 -0400
Message-ID: <48AA1D5E.5050405@us.ibm.com>
Date: Mon, 18 Aug 2008 20:09:50 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Avi Kivity <avi@qumranet.com>,
       virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] virtio_balloon: fix towards_target when deflating balloon
References: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com> <alpine.LFD.1.10.0808181740500.3324@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808181740500.3324@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> What's wrong with just doing
>
> 	return (s64)v - vb->num_pages;
>
> instead?
>   

Nothing.  It works just fine.  However, I implemented it more verbosely 
because this is the second time we've "fixed" this problem.  See

commit bdc1681cdf1ab6a65fa935a2b3f8fc63b20c54ea
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 17 22:58:15 2008 -0500

    virtio: handle > 2 billion page balloon targets

So I thought I'd rely a little less on the subtleties of promotion and 
make things a bit more clear.  However, I don't feel that strongly about 
it so here you go.


Both v and vb->num_pages are u32 and unsigned int respectively.  If v is 
less
than vb->num_pages (and it is, when deflating the balloon), the result is a
very large 32-bit number.  Since we're returning a s64, instead of 
getting the
small negative number we desire, we get a very large positive number.

This patch explicitly casts v to a s64 in which will cause the whole 
expression
to be promoted resulting in the proper results.

Rusty: please push this for 2.6.27-rc4.  It's probably appropriate for the
stable tree too as it will cause an unexpected OOM when ballooning.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/virtio/virtio_balloon.c 
b/drivers/virtio/virtio_balloon.c
index bfef604..62eab43 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -158,7 +158,7 @@ static inline s64 towards_target(struct 
virtio_balloon *vb)
     vb->vdev->config->get(vb->vdev,
                   offsetof(struct virtio_balloon_config, num_pages),
                   &v, sizeof(v));
-    return v - vb->num_pages;
+    return (s64)v - vb->num_pages;
 }
 
 static void update_balloon_size(struct virtio_balloon *vb)

