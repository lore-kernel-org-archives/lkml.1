Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbYBFWfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbYBFWfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYBFWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:35:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757448AbYBFWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:35:42 -0500
Date: Wed, 6 Feb 2008 14:34:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-Id: <20080206143457.03e8741d.akpm@linux-foundation.org>
In-Reply-To: <47AA3126.8090102@redhat.com>
References: <47AA3126.8090102@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 16:13:58 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> do_mount() uses a whopping 616 bytes of stack on x86_64 in 
> 2.6.24-mm1, largely thanks to gcc inlining the various helper 
> functions.

hm, sizeof(nameidata)=136 and I can see about three of them on the stack. 
Must have missed something.

> noinlining these can slim it down a lot; on my box this patch
> gets it down to 168, which is mostly the struct nameidata nd;
> left on the stack.
> 
> These functions are called only as do_mount() helpers;
> none of them should be in any path that would see a performance
> benefit from inlining...
> 

Does the patch actually help?  I mean, if a() calls b() and both use N
bytes of locals, our worst-case stack usage remains ~2N whether or not b()
was inlined in a()?  In fact, uninlining makes things a little worse due to
callframe stuff.

> -static int do_change_type(struct nameidata *nd, int flag)
> +static noinline int do_change_type(struct nameidata *nd, int flag)

There's no way for the reader to work out why this is here, so I do think
it should be commented somewhere.

