Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXETT6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXETT6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXETT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:58:00 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:46926 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbXETT57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:57:59 -0400
Date: Sun, 20 May 2007 12:57:58 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Satyam Sharma <satyam.sharma@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
In-Reply-To: <465034AA.6030904@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.58.0705201243500.1671@shell4.speakeasy.net>
References: <20070519151523.GA26724@uranus.ravnborg.org> 
 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> 
 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> 
 <20070519230940.GJ6291@stusta.de>  <a781481a0705191617v901ac64nfa7040ff302d2da1@ma
 <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com>
 <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net> <465029F1.6090301@s5r6.in-berlin.de>
 <Pine.LNX.4.58.0705200416370.1671@shell4.speakeasy.net> <465034AA.6030904@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Stefan Richter wrote:
>
> >> Iterating upwards and downwards the dependency graph is the duty of
> >> "make snafuconfig", not of the maintainers.
>
> ...multi-level dependencies are no problem for it.
>
> There is nothing wrong with
>
> 	A... depends on B
>
> 	B... depends on C
>
> 	# CONFIG_C is not set
>
> -> A is unavailable.

select doesn't appear to work quite like this.  For example:

config A
	bool "A"

config B
	bool "B"
	depends on A

config C
	bool "C"
	select B

In this case, it's possible to turn C on and A off.  B will be on, even
though it depends on A and A is off.

The kconfig docs say that "B..  depends on A" sets the maximum value of B
to be that of A.  Since A=0, the max value of B is 0.

The kconfig docs also say that "C..  select B" sets the minimum value of B
to be that of C.  Since C=2, the minimum value of B is 2.

So we have B>=2 and B<=0, which is obviously impossible.  Yet *config has
no problem with this, and will set B=2 even the 'depends' means B must be
0.  It seems like "select" will override any other dependencies.
