Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZGWSmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZGWSmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZGWSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:42:50 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42533 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZGWSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:42:49 -0400
Date: Thu, 23 Jul 2009 11:42:49 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] ceph: ioctls
In-Reply-To: <20090723062412.GA19207@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0907231133450.2930@cobra.newdream.net>
References: <1248292313-31326-11-git-send-email-sage@newdream.net>
 <1248292313-31326-12-git-send-email-sage@newdream.net>
 <1248292313-31326-13-git-send-email-sage@newdream.net>
 <1248292313-31326-14-git-send-email-sage@newdream.net>
 <1248292313-31326-15-git-send-email-sage@newdream.net>
 <1248292313-31326-16-git-send-email-sage@newdream.net>
 <1248292313-31326-17-git-send-email-sage@newdream.net>
 <1248292313-31326-18-git-send-email-sage@newdream.net> <878wig2vhe.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907221636260.8312@cobra.newdream.net> <20090723062412.GA19207@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Andi Kleen wrote:
> What I find more suspicious is that it's the direct network
> data structure. Presumably that's in a defined endian?
> So that means the application would already need to 
> change to network endian order at the ioctl level?
> 
> That seems wrong if true. I think defining
> a ioctl directly based on a network protocol header is 
> likely a bad idea.

That's a good point.  I've defined an ioctl-specific struct, so the entire 
interface is defined in the header:

---
#include <linux/ioctl.h>
#include <linux/types.h>

#define CEPH_IOCTL_MAGIC 0x97

/* just use u64 to align sanely on all archs */
struct ceph_ioctl_layout {
	__u64 stripe_unit, stripe_count, object_size;
	__u64 data_pool;
};

#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1,		\
				   struct ceph_ioctl_layout)
#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2,		\
				   struct ceph_ioctl_layout)
---

The remaining issues are:
- this isn't complete.  I haven't made up my mind how to list, describe, 
  and choose the data pool to store a file in; for now it's ignored.
- where the header should go.  I don't see any other file system ioctls in 
  include/linux other than ext[23]; the rest are all in fs/*.

sage
