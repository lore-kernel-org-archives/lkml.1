Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbYDHCEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbYDHCEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYDHCEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:04:13 -0400
Received: from ozlabs.org ([203.10.76.45]:36574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYDHCEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:04:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH RFC 1/5] vringfd syscall
Date: Tue, 8 Apr 2008 08:34:55 +1000
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
References: <12555.1207590874@vena.lwn.net>
In-Reply-To: <12555.1207590874@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080834.56943.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008 03:54:34 Jonathan Corbet wrote:
> Hey, Rusty,
>
> > For virtualization, we've developed virtio_ring for efficient
> > communication. This would also work well for userspace-kernel
> > communication, particularly for things like the tun device.  By using the
> > same ABI, we can join guests to the host kernel trivially.
>
> I'm *sure* you meant to document that somewhat non-trivial proposed new
> kernel API as soon as you got a moment.

Actually, yes.  But I wanted to get it out there before I start the treck 
across to the virtualization summit.

A few points:
'The page alignment for the used array is important - that array might be 
mapped separately into kernel space.'
   Well, the used array is written by one side only, so it's possible to split 
the ring here and make each part r/o to the other side.  More importantly, a 
page boundary is almost certainly a cacheline boundary, and we already have a 
userspace interface for it.

'Note that the flags fields in the vring_avail and vring_used structures 
appear to be unused.'
   virtio uses these for wakeup/interrupt suppression.  It's a cheap way to 
avoid hypercalls, and we can use them the same way to avoid system calls (you 
set the suppression bit while you're actually looking at the ring).

The need for the kmap (and hence the atomic horror) has now been alleviated: I 
changed the shinfo destructor code to allow the destructor to hold onto the 
skb data so it can queue it and free it later.

BTW, the only place currently where both output and input buffers are used is 
the virtio_blk driver doing a read, where the header describes the operation, 
and the other buffers are overwritten with the data.

Thanks!
Rusty.
