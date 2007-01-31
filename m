Return-Path: <linux-kernel-owner+w=401wt.eu-S1030557AbXAaT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030557AbXAaT0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030560AbXAaT0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:26:18 -0500
Received: from smtp6-g19.free.fr ([212.27.42.36]:38333 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030557AbXAaT0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:26:17 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: remove_proc_entry and read_proc
Date: Wed, 31 Jan 2007 20:26:14 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200701311154.35929.duncan.sands@math.u-psud.fr> <20070131184251.GA5544@martell.zuzino.mipt.ru>
In-Reply-To: <20070131184251.GA5544@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701312026.14145.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 January 2007 19:42:51 Alexey Dobriyan wrote:
> On Wed, Jan 31, 2007 at 11:54:35AM +0100, Duncan Sands wrote:
> > Can read_proc still be executing when remove_proc_entry returns?
> >
> > In my driver [*] I allocate some data and create a proc entry using
> > create_proc_entry.  My read method reads from my allocated data.  When
> > shutting down, I call remove_proc_entry and immediately free the data.
> > If some call to read_proc is still executing at this point then it will
> > be accessing freed memory.  Can this happen?  I've been rummaging around
> > in fs/proc to see what prevents it, but didn't find anything yet.
> 
> This should be fixed by the following patch (in -mm currently):
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/fix-rmmod-read-write-races-in-proc-entries.patch
> 
> Tell me if you're unsure it will.

Excellent!  But tell me,

+	atomic_inc(&dp->pde_users);
+	if (!dp->proc_fops)

don't you need a memory barrier between these two?  Also a corresponding
one where proc_fops is set to NULL.


+		/*
+		 * Stop accepting new readers/writers. If you're dynamically
+		 * allocating ->proc_fops, save a pointer somewhere.
+		 */
+		de->proc_fops = NULL;
+		/* Wait until all readers/writers are done. */
+		if (atomic_read(&de->pde_users) > 0) {
+			spin_unlock(&proc_subdir_lock);
+			msleep(1);
+			goto again;
+		}

I don't understand how this is supposed to work.  Consider

CPU1					CPU2

atomic_inc(&dp->pde_users);
if (dp->proc_fops)
					de->proc_fops = NULL;
	use_proc_fops <= BOOM
					if (atomic_read(&de->pde_users) > 0) {

what prevents dereference of a NULL proc_fops value?

Best wishes,

Duncan.
