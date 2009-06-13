Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbZFMUw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbZFMUw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZFMUwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:52:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34547 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756361AbZFMUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:52:20 -0400
Date: Sat, 13 Jun 2009 21:53:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <JBottomley@Novell.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in pty_chars_in_buffer with 2.6.30 git head using ssh
Message-ID: <20090613215333.0e8a440e@lxorguk.ukuu.org.uk>
In-Reply-To: <1244909374.5323.23.camel@mulgrave.site>
References: <1244909374.5323.23.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009 11:09:34 -0500
James Bottomley <JBottomley@Novell.com> wrote:

> This is a really odd one.  I've used ssh into this box with this same
> kernel several times before, I got this (actually logged out as me over
> ssh then logged back in as root):

Its an ancient long standing bug but from the trace its inadvertently
become a NULL pointer deref rather than calling functions unsafely.

Change the if (!to ...) to if (!to || !to->ldisc || ...

and you'll get a race window thats rather like the one before.

The underlying problem is that the tty layer calls one tty ldisc from
under the locks of another but without holding the locks it needs. It
can't take both locks without deadlocking.

It's one I'm currently working on fixing.
