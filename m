Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZJUGY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZJUGY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZJUGY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:24:26 -0400
Received: from smtp.wp.pl ([212.77.101.1]:24870 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751907AbZJUGYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:24:24 -0400
Date: Wed, 21 Oct 2009 08:24:27 +0200
From: "Krzysztof Helt" <krzysztof.h1@wp.pl>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       jfs-discussion <jfs-discussion@lists.sourceforge.net>
Subject: Re: [Jfs-discussion] [PATCH] jfs: lockdep fix
Message-ID: <4adea91bbfcf65.02080900@wp.pl>
References: <4ade05f0af05a2.00981454@wp.pl> <1256068823.3708.30.camel@norville.austin.ibm.com>
In-reply-to: <4ade05f0af05a2.00981454@wp.pl> <1256068823.3708.30.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: Interfejs WWW nowej poczty Wirtualnej Polski
X-User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.3) Gecko/20090909 Fedora/3.5.3-1.fc11 Firefox/3.5.3
Organization: Nowa Poczta Wirtualnej Polski S.A. http://www.wp.pl/
X-WP-IP: 83.17.101.58
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [sVN0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 20-10-2009 o godz. 22:00 Dave Kleikamp napisa³(a):
> On Tue, 2009-10-20 at 20:48 +0200, Krzysztof Helt wrote:
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > 
> > Release rdwrlock semaphore during memory allocation.
> > This fixes the locked already reported here:
> > 
> > http://www.mail-archive.com/jfs-discussion@lists.sourceforge.net/msg01389.html
> > 
> > The problem here is that memory allocation is done with rdwrlock
> > semaphore taken and the VM can get into the jfs layer taking the
> > rdwrlock again.
> > 
> > Also, the patch fixes the lockdep below. This problem is created because
> > the rdwrlock semaphore acquires the commit_mutex and it is called with
> > interrupts enabled. The interrupt may hit with the commit_mutex taken
> > and take the rdwrlock (again) inside the interrupt context.
> 
> The rdwrlock should never be taken in interrupt context.
> 

Right. It is taken in the RECLAIM_FS context.

> > =========================================================
> > [ INFO: possible irq lock inversion dependency detected ]
> > 2.6.32-rc3 #99
> > ---------------------------------------------------------
> > kswapd0/180 just changed the state of lock:
> >  (&jfs_ip->rdwrlock#2){++++-.}, at: [<c02e2207>] jfs_get_block+0x47/0x280
> > but this lock took another, RECLAIM_FS-unsafe lock in the past:
> >  (&jfs_ip->commit_mutex){+.+.+.}
> > 
> > and interrupts could create inverse lock ordering between them.
> > 
> > 
> > other info that might help us debug this:
> > no locks held by kswapd0/180.
> > 
> > the shortest dependencies between 2nd lock and 1st lock:
> >  -> (&jfs_ip->commit_mutex){+.+.+.} ops: 7937 {
> >     HARDIRQ-ON-W at:
> 
> <snip>
> 
> > ---
> > 
> > I am not sure if this is the right fix to the problem. The heavy use of
> > the jfs volume can lock up a machine (e.g. hit me in Ubuntu 9.04).
> 
> I don't think we can just drop the mutex, since it protects the inode's
> xtree from being modified while another thread is either reading or
> writing it.
> 
> I proposed another fix here:
> http://bugzilla.kernel.org/show_bug.cgi?id=13613
> 
> It seems I haven't followed up and submitted it to the vfs maintainer.
> Could you please give that patch a try and see if it fixes the problem
> for you?
> 

I have tested it a little and I will do some more. At least, there is no 
easy way to trigger the previous lockdep (with rdwrlock only reported to 
the 2.6.30). It seems your fix helps here.

However, I think it does not help with this new lockdep I have reported. 
The new locked is due to the fact that commit_mutex is taken with the 
rdwrlock hold and enabled interrupts. The kswapd may start and create 
the inverse locking order.  The kswapd takes the rdwrlock and some other 
task may hold the commit_mutex. The rdwrlock is taken in jfs_get_block() 
and calls the extAlloc() which takes the commit_mutex. One possible fix 
is to move the commit mutex to the jfs_get_block() before the rdwrlock. 
The extAlloc() is called from the jfs_get_block() only.

Kind regards,
Krzysztof

----------------------------------------------------
WYGRAJ wycieczkê kolejow± po pó³nocnej Hiszpanii!
http://klik.wp.pl/?adr=http%3A%2F%2Fwww.navigeo.pl%2Fcontest%2Fidea_tour&sid=885


