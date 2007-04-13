Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXDMBJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXDMBJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXDMBJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:09:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbXDMBJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:09:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=H4heur5FqD/ut1MHVDKG/r16srpGe6qSbYNLKg6IO8U9JPp25LNoLdgKJoSTVJ464
	8iAC/4atvXwNe0OK9aUhQ==
Message-ID: <b040c32a0704121808u63dd169bhecba2a0596a546eb@mail.gmail.com>
Date: Thu, 12 Apr 2007 18:08:56 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Cc: "Zach Brown" <zach.brown@oracle.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <b040c32a0704121757p728654cdte652c2a900e4c2d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410235353.325A7346F64@localhost>
	 <20070411180038.GN28322@mami.zabbo.net>
	 <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
	 <b040c32a0704120029u423bfd39pfa0479c3c678ebe2@mail.gmail.com>
	 <x49ejmp3igr.fsf@segfault.boston.devel.redhat.com>
	 <b040c32a0704121757p728654cdte652c2a900e4c2d4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, Ken Chen <kenchen@google.com> wrote:
> On 4/12/07, Jeff Moyer <jmoyer@redhat.com> wrote:
> > I didn't see any response to Zach's request for code that actually
> > tests out the shared ring buffer.  Do you have such code?
>
> Yes, I do.  I was stress testing the code since last night.  After 20+
> hours of stress run with fio and aio-stress, now I'm posting it with
> confidence.
>
> I modified libaio's io_getevents to take advantage of new user level
> reap function. The feature is exported out via ring->compat_features.
> btw, is compat_feature suppose to be a version number or a bit mask?
> I think bitmask make more sense and more flexible.

Additional patch on the kernel side to export the new features.  On
top of patch posted at:
http://marc.info/?l=linux-kernel&m=117636401818057&w=2

--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -138,8 +138,11 @@ #define init_sync_kiocb(x, filp)			\
 		init_wait((&(x)->ki_wait));             \
 	} while (0)

+#define AIO_RING_BASE		1
+#define AIO_RING_USER_REAP	2
+
 #define AIO_RING_MAGIC			0xa10a10a1
-#define AIO_RING_COMPAT_FEATURES	1
+#define AIO_RING_COMPAT_FEATURES	(AIO_RING_BASE | AIO_RING_USER_REAP)
 #define AIO_RING_INCOMPAT_FEATURES	0
 struct aio_ring {
 	unsigned	id;	/* kernel internal index number */
