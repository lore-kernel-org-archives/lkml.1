Return-Path: <linux-kernel-owner+w=401wt.eu-S1030411AbXFHOMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030411AbXFHOMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968685AbXFHOMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:12:25 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57978
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968350AbXFHOMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:12:24 -0400
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070607201604.726094fc.akpm@linux-foundation.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
	 <1179098742.7322.5.camel@rousalka.dyndns.org>
	 <1179396003.31796.4.camel@rousalka.dyndns.org>
	 <20070517094557.c96f7e54.randy.dunlap@oracle.com>
	 <1179421196.5000.5.camel@rousalka.dyndns.org>
	 <1180206615.3430.8.camel@rousalka.dyndns.org>
	 <20070608030629.GA18493@atjola.homenet>
	 <20070607201604.726094fc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 08 Jun 2007 09:10:57 -0500
Message-Id: <1181311857.3985.7.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 20:16 -0700, Andrew Morton wrote:
> On Fri, 8 Jun 2007 05:06:29 +0200 Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> > This is do_tty_hangup() exchanging the fops while we're waiting for the
> > lock. The new fops (hung_up_tty_fops) only have the unlocked variant and
> > thus we Oops our way.
> 
> ah, yes, that explains it, thanks.  Culprit:
> 
> commit e10cc1df1d2014f68a4bdcf73f6dd122c4561f94
> Author: Paul Fulghum <paulkf@microgate.com>
> Date:   Thu May 10 22:22:50 2007 -0700
> 
>     tty: add compat_ioctl
>     
>     Add compat_ioctl method for tty code to allow processing of 32 bit ioctl
>     calls on 64 bit systems by tty core, tty drivers, and line disciplines.

OK, the change of hung_up_tty_ioctl() from locked to unlocked
is not necessary for this patch. On the surface it seemed a clever
way of not needing two different functions to do the same simple:

return cmd == TIOCSPGRP ? -ENOTTY : -EIO;

which does not need any locking for its own sake. But clearly
the hangup behavior requires the locked version.

I'll redo the patch with hung_up_tty_ioctl remaining locked.

That will separate the compat ioctl stuff from this issue.

-- 
Paul Fulghum
Microgate Systems, Ltd

