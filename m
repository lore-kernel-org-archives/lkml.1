Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZBBIwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZBBIwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZBBIwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:52:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:36586 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750765AbZBBIwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:52:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19niTRXAGNnEQ8Pmz11DIRUepbP7Ot/cjL3IJJIPW
	hlhHnFMV7/jE72
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
	synchronizing threads on different cores
From: Mike Galbraith <efault@gmx.de>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233563600.3669.36.camel@localhost.localdomain>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
	 <1233560635.4126.18.camel@localhost.localdomain>
	 <1233562763.4787.71.camel@laptop>
	 <1233563600.3669.36.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 09:52:11 +0100
Message-Id: <1233564731.21378.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:33 +0100, Thomas Pilarski wrote:
> Am Montag, den 02.02.2009, 09:19 +0100 schrieb Peter Zijlstra:
> > I suppose you'll have to go bug the glibc people about their random()
> > implementation.
> 
> Yes, I will.

Finding the below was easy enough...

/* POSIX.1c requires that there is mutual exclusion for the `rand' and
   `srand' functions to prevent concurrent calls from modifying common
   data.  */
__libc_lock_define_initialized (static, lock)

...

long int
__random ()
{
  int32_t retval;

  __libc_lock_lock (lock);

  (void) __random_r (&unsafe_state, &retval);

  __libc_lock_unlock (lock);

  return retval;
}

...but finding the plumbing leading to __lll_lock_wait_private()
over-taxed my attention span.

	-Mike

