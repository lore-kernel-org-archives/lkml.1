Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYIIAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYIIAdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYIIAdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:33:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496AbYIIAdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:33:01 -0400
Date: Mon, 8 Sep 2008 17:32:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Peterson <joe@skyrush.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
Message-Id: <20080908173250.2452c5b8.akpm@linux-foundation.org>
In-Reply-To: <48C54EC2.4060901@skyrush.com>
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
	<48AC3A16.4080209@skyrush.com>
	<48B3F9F7.2050503@skyrush.com>
	<48C54EC2.4060901@skyrush.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 10:11:46 -0600
Joe Peterson <joe@skyrush.com> wrote:

> +	spin_lock_irqsave(&tty->echo_lock, flags);
>  	lock_kernel();

Taking a spinlock outside lock_kernel() isn't good, and is quite unusual.

- It might be ab/ba deadlockable (I didn't check) (I trust you always
  test with lockdep enabled?)

- will make Ingo unhappy when he applies his "make lock_kernel use
  mutex_lock" patch (if it's still around).

- will probably give the -rt guys conniptions.


swapping the above two lines would presumably be an easy fix, but one
wonders whether we still need lock_kernel() in there once you've added
this lock.

