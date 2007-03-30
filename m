Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbXC3QLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbXC3QLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXC3QLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:11:03 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39038 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbXC3QLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:11:01 -0400
Date: Fri, 30 Mar 2007 09:10:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: David Howells <dhowells@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump
 routine
Message-Id: <20070330091028.cf884d4c.akpm@linux-foundation.org>
In-Reply-To: <460CE683.700@hitachi.com>
References: <20070329104936.GC5138@ucw.cz>
	<45E7AAFA.4070402@hitachi.com>
	<45E7AC6F.8080704@hitachi.com>
	<20070302093419.GA2001@elf.ucw.cz>
	<4607C47B.2030909@hitachi.com>
	<11911.1175195819@redhat.com>
	<20070329141715.71a6abae.akpm@linux-foundation.org>
	<460CE683.700@hitachi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 19:29:23 +0900 "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com> wrote:

> > core_pattern:
> >   ...
> > . If the first character of the pattern is a '|', the kernel will treat
> >   the rest of the pattern as a command to run.  The core dump will be
> >   written to the standard input of that program instead of to a file.
> 
> I think dumping core over a pipe is almost good.  Filtering and writing
> out a core by a separete userspace program can be reliable because it is
> independent of the failed user process.  But I have one concern; data
> transfer over a pipe is slow.  It took 7 seconds to transfer 2GB
> anonymous shared memory (detailed at the last of this mail).
> 
> In the case of dumping hundreds processes which share giga bytes memory,
> it will take a few minutes even if the huge shared memory is not written
> to a disk.  If a user wants to restart the failed application as soon
> as possible to keep downtime to a minimum, this extra transfer time will
> be a barrier.  So I think in-kernel filtering is still needed.

Yes, I agree - I don't think we presently have a way of avoiding having
to send all of that uninteresting data down the pipe.

One may, however, be able to play tricks with /proc/<pid>/mem from within
the corefile-generating program: select the vmas which are to be dumped,
read only those ones.  I don't know how practical that would be.
