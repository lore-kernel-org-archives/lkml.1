Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXJaLvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXJaLvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXJaLvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:51:47 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:36055 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbXJaLvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:51:46 -0400
Date: Wed, 31 Oct 2007 04:51:45 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] bttv build error (CONFIG_NET=n)
In-Reply-To: <20071030221508.3139ea5c.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.58.0710310345160.19072@shell4.speakeasy.net>
References: <20071030221508.3139ea5c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Randy Dunlap wrote:
> drivers/media/video/bt8xx/bttv-cards.c calls ip_compute_csum().
> However, when CONFIG_NET=n, that produces:
>
> ERROR: "ip_compute_csum" [drivers/media/video/bt8xx/bttv.ko] undefined!
>
> Config symbol VIDEO_BT848 can be made to depend on NET, or the
> osprey_eeprom() function can be built depending on some new config
> symbol, or bttv could have its own checksum function...

The real problem here is that ip_compute_csum is part of lib-y, but is also
exported for modules.  This problem has come up before, for instance your
patch for csum_partial()
http://lkml.org/lkml/2007/4/3/209

Or the problem with kasprintf and the lg module:
http://lkml.org/lkml/2007/9/24/15

The general lib-y vs EXPORT_SYMBOL problem:
http://lkml.org/lkml/2007/9/25/17

The only reason the net stuff works, is because CONFIG_NET includes igmp.c,
which can't be compiled as a module.  That means ip_compute_csum() will get
pulled out of the lib.a file for igmp, and thus be present for the net modules
that use it too.  If igmp could be turned off, made a module, or stopped using
ip_compute_csum(), then the users of ip_compute_csum() that do depend on
CONFIG_NET would have the same problem as bttv does.

It seems a shame to create a new ip checksum function in the bttv driver when
a perfectly good one already exists and will already be present in just about
every kernel out there.  Honestly, how common is NET=n and VIDEO_BT848=m
outside of randconfig?
