Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbXFXRrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbXFXRrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXFXRre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:47:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43282 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbXFXRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:47:33 -0400
Date: Sun, 24 Jun 2007 18:47:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624174732.GZ21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:05:51AM +0100, Al Viro wrote:
> 
> Hopefully correct handling of integer constant expressions.  Please, review.

Heh...  The first catches are lovely:
                 struct fxsrAlignAssert {
                         int _:!(offsetof(struct task_struct,
                                         thread.i387.fxsave) & 15);
                 };
as an idiotic way to do BUILD_BUG() and
#define _IOC_TYPECHECK(t) \
        ((sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
          sizeof(t) : __invalid_size_argument_for_IOC)
poisoning _IOW() et.al., so those who do something like

static const char *v4l1_ioctls[] = {
        [_IOC_NR(VIDIOCGCAP)]       = "VIDIOCGCAP",

run into trouble.  The former is "tell jbeulich to cut down on crack",
but the latter...  Probably ought to be
#define _IOC_TYPECHECK(t) \
        (sizeof(t) + BUILD_BUG_ON_ZERO(sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)))

Objections?  The only reason that doesn't break gcc to hell and back is
that gcc has unfixed bugs in that area.  It certainly is not a valid C
or even a remotely sane one.
