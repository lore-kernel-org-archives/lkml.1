Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYB0KYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYB0KYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYB0KYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:24:38 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:55012 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYB0KYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FEle4mkRHYG5PVG3jOE2RyyUHJAC2o26V7b6lbhd53MXjEBiZ8hBvCKYDXBTNYxNQF6DPYOU5VyV2tz75lZfkQfYnoKVxhT+qQpOXxOCJuBa55dEDA7V7ZWM2DwTA8KuCX/ehthPM2aFCTbxLtywPKQhCaSAsHxtXhAS/iHZXGw=
Date: Wed, 27 Feb 2008 11:23:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, i2c@lm-sensors.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] video: limit stack usage of ir-kbd-i2c.c
Message-ID: <20080227102309.GA6698@joi>
References: <20080225205055.GA27455@joi> <20080226133222.7af260b2@hyperion.delvare> <20080226210307.GA6085@joi> <20080226232320.2df756d6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226232320.2df756d6@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:23:20PM +0100, Jean Delvare wrote:
> Hi Marcin,
Hi
 
> On Tue, 26 Feb 2008 22:03:16 +0100, Marcin Slusarz wrote:
> > Do you have an idea (or patch :D) how to solve this:
> > 0x00000234 v4l_compat_translate_ioctl [v4l1-compat]:    1376
> > ? That's on top of my make checkstack output
> 
> Random ideas (but I am in no way a specialist of this exercise):
> 
> * You could try moving the structures to the blocks where they are used,
> in the case a given structure is used for only one ioctl. I'm not too
> sure how gcc handles local variables declared inside blocks with
> regards to stack reservation though. I thought it would work but my
> experiments today seem to suggest it doesn't.
That won't work. Variables at beginning of function take only ~600 bytes,
so the rest must be from inner blocks and inlines (probably).

> * You can move the handling of some ioctls to dedicated functions, just
> like I did in i2c-dev:
> http://lists.lm-sensors.org/pipermail/i2c/2008-February/003010.html
> However there is a risk that gcc will inline these functions (that's
> what happened to me...) Not sure how to prevent gcc from inlining.
There's "noinline" attribute in linux/compiler.h (compiler-gcc.h actually)
for these situations.
 
> * You can allocate the structures dynamically, as you originally wanted
> to do for ir-kbd-i2c. However this has a performance penalty and will
> fragment the memory, so it's not ideal.
> 
> * If each ioctl uses only one of the structures, you may define a union
> of all the structures. The size of the union will be the size of the
> biggest structure, so you save a lot of space on the stack.
Nice idea.

I'll try 2nd and 4th approaches.

Marcin Slusarz
