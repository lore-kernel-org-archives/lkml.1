Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbXEUQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbXEUQhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXEUQhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:37:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32990 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbXEUQhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:37:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=jHs2rkGwuAsYls0vUNgniA6Hjt7WErs6L3fp8//dq/OOsHQe3hjEoLmA8CJhFYHHG
	ICU36HADWoNX766R5zmmQ==
Message-ID: <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
Date: Mon, 21 May 2007 09:37:26 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
	 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
	 <1179677799.3311.5.camel@lov.localdomain>
	 <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
	 <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> yes and no. in that commit, I automatically create n+1 device when
> loop device n is created, allergically was tested to be fine with
> casual usage of "losetup" and "mount -o loop".  However, there is a
> bug in that commit when loop.c was compiled as a module.  And when Al
> fixed it, he also removed that magic "n+1" trick.
>
> Nevertheless, yes, I'm guilty of introducing the new behavior.

The easiest way is to reinstate max_loop and create "max_loop" device
up front at module load time.  However, that will lose all the "fancy
on-demand device instantiation feature".

So I propose we do the following:

1. have the module honor "max_loop" parameter and create that many
device upfront on module load (max_loop will also be a hard max) iff
user specify the parameter.
2. if max_loop is not specified, default create 8 loop device.  User
can extent more loop device by create device node themselves and have
kernel automatically instantiate loop device on-demand.

Is this acceptable?  Patch in a bit.
