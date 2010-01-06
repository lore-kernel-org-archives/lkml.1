Return-Path: <linux-kernel-owner+w=401wt.eu-S932271Ab0AFQUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab0AFQUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237Ab0AFQUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:20:48 -0500
Received: from mail2.shareable.org ([80.68.89.115]:33092 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab0AFQUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:20:47 -0500
Date: Wed, 6 Jan 2010 16:20:04 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
Message-ID: <20100106162004.GA11773@shareable.org>
References: <20100106065526.GB11368@localhost> <adahbqzvhgn.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahbqzvhgn.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
>  > +	/* please add new bits here to ensure allocation uniqueness */
>  > +	BUG_ON(20 != hweight32(
>  > +		O_RDONLY	| O_WRONLY	| O_RDWR	|
> 
> I wonder if there's a way to make this BUILD_BUG_ON(), so the problem is
> caught at compile time (a change like adding an O_ flag is often compile
> tested only for obscure archs).  One could create a compile-time
> macro-ized version of hweight32() and use that, I guess, although I'm
> not sure it's worth the ugliness.

Not ugly at all:

#define hweight32(x) __builtin_popcount(x)

Checked GCC 3.4.3 / 4.1 / 4.4: It expands as a compile-time constant
if the argument is a compile-time constant, so can be used in
BUILD_BUG_ON() and even for array sizes etc.

If GCC's __builtin_popcount() isn't good enough for non-constant
values, the macro would be more involved:

#define hweight32(x) (__builtin_constant_p(x) ? __builtin_popcount(x) \
                      : hweight32_nonconstant(x))

-- Jamie
