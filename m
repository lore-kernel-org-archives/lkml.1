Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbXFAHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbXFAHqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXFAHqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:46:45 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:60216
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756379AbXFAHqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:46:44 -0400
Date: Fri, 1 Jun 2007 09:48:21 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070601074821.GS14284@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
References: <20070425154934.GP6798@traven> <20070425191359.GA13241@infradead.org> <20070425194633.GA3280@traven> <20070425194550.GA18914@infradead.org> <20070531134226.GO14284@traven> <20070531153712.de2f8a68.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531153712.de2f8a68.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, May 31, 2007 at 03:37:12PM -0700 Andrew Morton ha dit:

> On Thu, 31 May 2007 15:42:26 +0200
> Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> 
> > drivers/char/tty_io.c: Use spinlock instead of a (binary) semaphore
> > 
> 
> hm.
> 
> > 
> 
> We end up with this:
> 
> 	/* find a device that is not in use. */
> 	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL))
> 		return -ENOMEM;
> 
> 	spin_lock(&allocated_ptys_lock);
> 
> 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
> 	if (idr_ret < 0) {
> 		spin_unlock(&allocated_ptys_lock);
> 		if (idr_ret == -EAGAIN)
> 			return -ENOMEM;
> 		return -EIO;
> 	}
> 	if (index >= pty_limit) {
> 		idr_remove(&allocated_ptys, index);
> 		spin_unlock(&allocated_ptys_lock);
> 		return -EIO;
> 	}
> 	spin_unlock(&allocated_ptys_lock);
> 
> this leaves a small window in which another thread can come in and steal
> away the idr tree's reserves, causing the idr_get_new() to fail.  It's
> highly improbable, but it's real.

i agree, thanks for pointing it out
 
> Hence I think a straight semaphore->mutex conversion would be better.

that leads us back to the initial patch. christoph: is that ok for
you or do you have another proposal?

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     The assumption that what currently exists must necessarily
      exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
