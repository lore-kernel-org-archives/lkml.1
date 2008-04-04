Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYDDCA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYDDCA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 22:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYDDCAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 22:00:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48675 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYDDCAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 22:00:16 -0400
Date: Fri, 4 Apr 2008 03:00:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Triplett <josh@freedesktop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080404020013.GD9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403024117.GZ9785@ZenIV.linux.org.uk> <47F53E84.8080607@freedesktop.org> <20080404011951.GC9785@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404011951.GC9785@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 02:19:51AM +0100, Al Viro wrote:
> 	* no functions returning variably-modified type.

Note: *pointer* to function returning a variably-modified type is possible,
is variably-modified itself and as such can appear only in function and
the same "compiler will consider VLA compatible with any array that has
as compatible element, but if the size doesn't match it's on your head"
applies.  IOW,

int a[2][2] = {{1, 2}, {3, 4}};

int (*f(void))[2] /* return a pointer to two-element array of int */
{
        return &a[0];
}

int h(int n)
{
	/* pointer to function that returns a pointer to n-element VLA of int */
        int (*(*p)(void))[n];
	/* OK if n is 2, undefined otherwise */
        p = f;
        return p()[1][1];
}

is fine and h(2) will give you 4, but if you ever do e.g. h(1), you are in
nasal daemon country.  In reality h(1) will _probably_ give a[1][0], but
compiler has every right to silently produce a binary that'll wipe your disk
or do the same itself...
