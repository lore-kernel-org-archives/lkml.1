Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYDPFR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYDPFR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYDPFRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:17:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYDPFRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:17:17 -0400
Date: Tue, 15 Apr 2008 22:17:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thiago Galesi <thiagogalesi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: Remove use of lock_kernel /
 unlock_kernel in fbmem
Message-Id: <20080415221707.82da3d42.akpm@linux-foundation.org>
In-Reply-To: <200804131150.07601.thiagogalesi@gmail.com>
References: <200804131150.07601.thiagogalesi@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 11:50:07 -0300 Thiago Galesi <thiagogalesi@gmail.com> wrote:

> This patch removes lock_kernel(), unlock_kernel() usage in fbmem.c and replaces it with a mutex

It isn't that simple, alas.

vfs_ioctl() runs lock_kernel() prior to calling fb_ioctl(), so the
lock_kernel()s in fb_compat_ioctl() are actually providing exclusion against
fb_ioctl().  Your patch would break that.

A suitable fix might be to do

__fb_ioctl(...)
{
	<copy fb_ioctl() into here>
}

fb_ioctl(...)
{
	mutex_lock(&info->hwlock);
	__fb_ioctl(...);
	mutex_unlock(&info->hwlock);
}

and then change fb_compat_ioctl() to call __fb_ioctl().  All the other
callers of fb_ioctl() would need to be reviewed - see if they need to take
the mutex then call __fb_ioctl(), or they might be OK as they are, calling
fb_ioctl().

Then we can switch fb_fops over to

	.ioctl	= NULL,
	.unlocked_ioctl = fb_ioctl,


