Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYE0Qic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYE0Qic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758007AbYE0QiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:38:06 -0400
Received: from vena.lwn.net ([206.168.112.25]:34632 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbYE0Qh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:37:57 -0400
Date: Tue, 27 May 2008 10:37:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080527103755.1fd67ec1@bike.lwn.net>
In-Reply-To: <20080527133100.6a9302fb@gaivota>
References: <20080522223700.2f103a14@core>
	<20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 13:31:00 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Since the other methods don't explicitly call BKL (and, AFAIK, kernel
> open handler don't call it neither), if a program 1 is opening a
> device and initializing some data, and a program 2 starts doing
> ioctl, interrupting program 1 execution in the middle of a data
> initialization procedure, you may have a race condition, since some
> devices initialize some device global data during open [1].

In fact, 2.6.26 and prior kernels *do* acquire the BKL on open (for
char devices) - that's the behavior that the bkl-removal tree is there
to do away with.  So, for example, I've pushed that acquisition down
into video_open() instead. 

So, for now, open() is serialized against ioctl() in video drivers.  As
soon as you take the BKL out of ioctl(), though, that won't happen,
unless the mutex you use is also acquired in the open path.

jon
