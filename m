Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYEKQin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYEKQin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYEKQie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:38:34 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:41069 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYEKQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:38:33 -0400
Date: Sun, 11 May 2008 18:38:05 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080511163805.GA11175@nibiru.local>
Reply-To: weigelt@metux.de
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com> <Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com> <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com> <alpine.LNX.1.10.0805111229520.19952@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805111229520.19952@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt <jengelh@medozas.de> wrote:

> Iff a process still has the file open, your unlink will succeed immediately
> anyway, and the real deallocation takes place when the last process runs
> close(). Which shows an interesting fact too: not only unlink can block.

Yep, the point is: on *nix there is no delete syscall, but just 
an unlink (decreasing the refcount). The kernel then decides when
to actually remove the file (normally when refcount==0).

So, when refcount==0 the kernel (more precisely: the fs) could
just hand over the inode to some kthread, which does the actual 
space-reclaiming. When properly done, the case of powerfail will
catched by fsck or journal replay, just the same as when several
processes were in the middle of deleting files.

Maybe this could be implemented by an overlaying filesystem,
which essentially moves to some special deleted dir instad of 
real unlink'ing - an separate process (which even could run in 
userland) will do the actual unlinking. So when an user process
calls unlink(), the inodes don't even have to be touched.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
