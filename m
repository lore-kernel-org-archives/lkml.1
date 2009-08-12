Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZHLRDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZHLRDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZHLRDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:03:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZHLRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:03:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Wed, 12 Aug 2009 19:03:22 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <20090810185340.GC13924@redhat.com>
In-Reply-To: <20090810185340.GC13924@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121903.22325.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+roL5IJOaSoIHAedRUmR+YNXXIujYN5Unb7ZT
 InczmH4Fykw21Hb2gHy3KNRWTMyJnYpbTSZc2qwPdc3NBsFNIh
 9sY7YrT484x85KH5YRLJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Michael S. Tsirkin wrote:

> +struct workqueue_struct *vhost_workqueue;

[nitpicking] This could be static. 

> +/* The virtqueue structure describes a queue attached to a device. */
> +struct vhost_virtqueue {
> +	struct vhost_dev *dev;
> +
> +	/* The actual ring of buffers. */
> +	struct mutex mutex;
> +	unsigned int num;
> +	struct vring_desc __user *desc;
> +	struct vring_avail __user *avail;
> +	struct vring_used __user *used;
> +	struct file *kick;
> +	struct file *call;
> +	struct file *error;
> +	struct eventfd_ctx *call_ctx;
> +	struct eventfd_ctx *error_ctx;
> +
> +	struct vhost_poll poll;
> +
> +	/* The routine to call when the Guest pings us, or timeout. */
> +	work_func_t handle_kick;
> +
> +	/* Last available index we saw. */
> +	u16 last_avail_idx;
> +
> +	/* Last index we used. */
> +	u16 last_used_idx;
> +
> +	/* Outstanding buffers */
> +	unsigned int inflight;
> +
> +	/* Is this blocked? */
> +	bool blocked;
> +
> +	struct iovec iov[VHOST_NET_MAX_SG];
> +
> +} ____cacheline_aligned;

We discussed this before, and I still think this could be directly derived
from struct virtqueue, in the same way that vring_virtqueue is derived from
struct virtqueue. That would make it possible for simple device drivers
to use the same driver in both host and guest, similar to how Ira Snyder
used virtqueues to make virtio_net run between two hosts running the
same code [1].

Ideally, I guess you should be able to even make virtio_net work in the
host if you do that, but that could bring other complexities.

	Arnd <><

[1] http://lkml.org/lkml/2009/2/23/353
