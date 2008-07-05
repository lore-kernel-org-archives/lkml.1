Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYGEXv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYGEXv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYGEXvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:51:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35318 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYGEXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:51:50 -0400
Date: Sun, 6 Jul 2008 00:51:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080705235148.GW28946@ZenIV.linux.org.uk>
References: <20080705131924.GA2083@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705131924.GA2083@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 03:21:06PM +0200, Marcin Slusarz wrote:
> ppdev (which provides support for user-space parallel port device drivers)
> is slightly different from other parallel port drivers. It allows to open
> the device by more than one process, but locks the device on ioctl (PPCLAIM).
> Unfortunately registration of sysctl entries were done before locking
> the device, so 2 processes could open it and try to register sysctl
> (it ignored error on registration, so it didn't block access to port).
> 
> So move registration of sysctl after locking (parport_claim_or_block).

I don't believe that it's right.  Note that if you *do* race there, you
are fucked regardless of sysctls - ppdev.c::register_device() racing
with itself will do tons of fun things all by itself (starting with two
threads allocating different pdev and both setting pp->pdev).

IOW, *if* that's what we are hitting here, you've only papered over the
visible symptom.
