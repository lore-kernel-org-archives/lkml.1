Return-Path: <linux-kernel-owner+w=401wt.eu-S1423195AbXBBHcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423195AbXBBHcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423193AbXBBHcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:32:10 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:33648 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423195AbXBBHcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:32:09 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: remove_proc_entry and read_proc
Date: Fri, 2 Feb 2007 08:31:57 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
References: <20070201160904.GC6023@localhost.sw.ru>
In-Reply-To: <20070201160904.GC6023@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702020831.58229.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

> I believe, barriers not needed, not now.
> 
> This scheme relies on the fact that remove_proc_entry() will be the only
> place that will clear ->proc_fops and, once cleared, ->proc_fops will
> never be resurrected. Clearing of ->proc_fops will eventually propagate
> to CPU doing first check, thus preveting refcount bumps from this CPU.
> What can be missed is some "rogue" readers or writers¹. Big deal.

I don't understand you.  Without memory barriers, remove_proc_entry will
most of the time, but not all of the time, wait for all readers and writers
to finish before exiting.  Since the whole point of your patch was to ensure
that all readers and writers finish before remove_proc_entry exits, I don't
understand why you don't just put the memory barriers in and make it correct.

Also, I do consider it a big deal:

> ¹ Sigh, modules should do removals of proc entries first. And I should
> check for that.

Modules should of course call remove_proc_entry before exiting.  However
right now, even with your patch, a read or write method can still be
running when remove_proc_entry returns [1], so could still be running when
the module is removed (if they sleep; I guess this applies mostly to
write methods).  This is very bad - why not put in memory barriers and
fix it?  Also, plenty of proc read and write methods access private data
that is allocated before calling create_proc_entry and freed after calling
remove_proc_entry.  If a read or write method is still running after
remove_proc_entry returns, then it can access freed memory - very bad.

Ciao,

Duncan.

[1] proc_get_inode does a try_module_get, so it is possible that module
unloading is not a problem - not sure.
