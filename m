Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbZJSWBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbZJSWBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZJSWBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:01:32 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59575 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZJSWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SfsMsBVwbcCXVSYOCxl/sPUnFU+/dO2Ea1syB6dzbO6G47AfS7tkCgvHQ5eZXhAM/U
         n2hIk1uqP9ZzZ6osNHNoWpI0xGkE9FmQHZDeJ+eJwsFW+PSViLGQ9ui2pZM5NiCxWggf
         5LxOhkEQ/TTzuIaBJ+ux+Tq7evIenSiAA57Ro=
Date: Tue, 20 Oct 2009 00:01:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] PPC-BRIQ_PANEL: Remove BKL and replace with atomic
	variable.
Message-ID: <20091019220129.GE4880@nowhere>
References: <alpine.LFD.2.00.0910182137470.3462@localhost.localdomain> <alpine.LFD.2.00.0910190658070.4975@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910190658070.4975@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 07:04:02AM +0200, Thomas Gleixner wrote:
> B1;2005;0cOn Sun, 18 Oct 2009, John Kacur wrote:
> 
> > >From b64c7d0f11eab96cb253b23c7264c999746116c0 Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Sun, 18 Oct 2009 21:29:21 +0200
> > Subject: [PATCH] PPC-BRIQ_PANEL: Remove BKL and replace with atomic variable.
> > 
> > There are no locks here except the bkl in briq_panel_open. It's only
> > purpose is to ensure single access. Remove the bkl and ensure single access
> > by making vfd_is_open an atomic_variable.
> 
> And again, can you please look more carefully at the init
> vs. read/write functions ?
> 
> The BKL is not only protecting the single user variable it's also
> serializing write against the access to the display in init.
> 
> Thanks,
> 
> 	tglx


That could be solved by statically initializing vfd_is_open to -1
and then set it to 0 once briq_panel_init has finished initializing
the device.

Another thing, I really don't see the point in this check in
briq_panel_read() and briq_panel_write():

	if (!vfd_is_open)
		return -ENODEV;


You can't read/write if vfd_is_open hasn't been set to 1 (open set)
and you're not racing against the release callback since it is called
after the file is closed.

I guess this check can disappear from read/write callbacks.

