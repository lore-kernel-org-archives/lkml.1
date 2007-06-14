Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXFNPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXFNPXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXFNPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:23:00 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:55244 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbXFNPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:23:00 -0400
Date: Thu, 14 Jun 2007 17:22:34 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/loop* devices not appearing in /dev (at least since
 2.6.22-rc3*)
Message-ID: <20070614172234.7f636307@localhost>
In-Reply-To: <e85b9d30706140710x5671fa12n5845172d4ce32a10@mail.gmail.com>
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
	<20070614145206.58fdec91@localhost>
	<e85b9d30706140710x5671fa12n5845172d4ce32a10@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 16:10:44 +0200
Matthew <jackdachef@gmail.com> wrote:

> I just tried out
> 
> modprobe loop max_loop=32
> 
> output of dmesg is:
> 
> [  457.607575] loop: the max_loop option is obsolete and will be
> removed in March 2008
> [  457.607578] loop: module loaded
> 
> but there are NO loop devices in /dev:
> 
> ls -l /dev/ | grep loop
> still shows nothing, strange ...

it's not strange, with your kernel version "max_loop" will just limit
the max number of loop devices at most.

This is what happens with the mentioned patch (-rc5 and later):

+	/*
+	 * loop module now has a feature to instantiate underlying device
+	 * structure on-demand, provided that there is an access dev node.
+	 * However, this will not work well with user space tool that doesn't
+	 * know about such "feature".  In order to not break any existing
+	 * tool, we do the following:
+	 *
+	 * (1) if max_loop is specified, create that many upfront, and this
+	 *     also becomes a hard limit.
+	 * (2) if max_loop is not specified, create 8 loop device on module
+	 *     load, user can further extend loop device by create dev node
+	 *     themselves and have kernel automatically instantiate actual
+	 *     device on-demand.
+	 */


So with this patch "max_loop=32" will create 32 loop devices... but
then it doesn't allow more of them.

Without options it creates 8 and you (or some userspace tool) can add
more dynamically.

-- 
	Paolo Ornati
	Linux 2.6.22-rc4-cfs-v16-g47932c49 on x86_64
