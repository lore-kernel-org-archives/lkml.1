Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYDSQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYDSQG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYDSQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:06:49 -0400
Received: from ozlabs.org ([203.10.76.45]:47253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYDSQGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:06:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer interface.
Date: Sun, 20 Apr 2008 02:05:31 +1000
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200804181433.48488.rusty@rustcorp.com.au> <200804181439.49051.rusty@rustcorp.com.au> <20080419102214.GA21952@2ka.mipt.ru>
In-Reply-To: <20080419102214.GA21952@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804200205.31508.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008 20:22:15 Evgeniy Polyakov wrote:
> Hi.
>
> On Fri, Apr 18, 2008 at 02:39:48PM +1000, Rusty Russell 
(rusty@rustcorp.com.au) wrote:
> > +int vring_get_buffer(struct vring_info *vr,
> > +		     struct iovec *in_iov,
> > +		     unsigned int *num_in, unsigned long *in_len,
> > +		     struct iovec *out_iov,
> > +		     unsigned int *num_out, unsigned long *out_len)
> > +{
> > +	unsigned int i, in = 0, out = 0;
> > +	unsigned long dummy;
> > +	u16 avail, last_avail, head;
> > +	struct vring_desc d;
>
> Should this whole function and vring_used_buffer() be protected with
> vr->lock mutex?

No; it's up to the caller to make sure that they are serialized.  In the case 
of tun that happens naturally.

There are two reasons not to grab the lock.  It turns out that if we tried to 
lock here, we'd deadlock, since the callbacks are called under the lock.  
Secondly, it's possible to implement an atomic vring_used_buffer variant, 
which could fail: this would avoid using the thread most of the time.

Hope that helps,
Rusty.
