Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbXJaTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbXJaTib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXJaTiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:38:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32889 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXJaTiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:38:23 -0400
Subject: Re: fix marker warnings
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20071031020830.GA1176@Krystal>
References: <1193774725.24087.303.camel@localhost>
	 <20071031020830.GA1176@Krystal>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 12:38:15 -0700
Message-Id: <1193859495.6271.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 22:08 -0400, Mathieu Desnoyers wrote:
> * Dave Hansen (haveblue@us.ibm.com) wrote:
> > I'm seeing these in the latest git:
> > 
> > kernel/marker.c: In function `marker_probe_unregister':
> > kernel/marker.c:355: warning: `probe_module' might be used uninitialized in this function
> > kernel/marker.c: In function `marker_probe_unregister_private_data':
> > kernel/marker.c:389: warning: `probe_module' might be used uninitialized in this function
> > kernel/marker.c:392: warning: `entry' might be used uninitialized in this function
> > 
> > It's due to gcc not detecting that the need_update condition is actually
> > constant, and will never call marker_update_probes() on an uninitialized
> > probe_module.
> > 
> > However, that need_update bit is all due to dropping the mutex before
> > calling marker_update_probes().  As far as I can tell, every call to
> > marker_update_probes() has this lock dropping behavior just before
> > calling it.  So, let's just hold the locks over the
> > marker_update_probes() and document that it needs to have a lock taken
> > instead.  
> > 
> > This removes code overall.  Untested except for a quick compile.
> > Consider it just a style suggestion. :)
> > 
> 
> Ok, just ran it and it seems good. It did not appear as trivial during
> development because locking was is a different order until recently.
> 
> I wonder what gcc version you are using though, because mine does not
> warn about anything. I wonder if it is really necessary to "fix" false
> gcc warnings like this. Let's take it as a cleanup.

dave@kernel:~$ gcc -v
Reading specs from /usr/lib/gcc-lib/x86_64-linux-gnu/3.3.6/specs
Configured with: ../src/configure -v --enable-languages=c,c++
--prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
--with-gxx-include-dir=/usr/include/c++/3.3 --enable-shared
--enable-__cxa_atexit --with-system-zlib --enable-nls
--without-included-gettext --enable-clocale=gnu --enable-debug
--disable-multilib x86_64-linux-gnu
Thread model: posix
gcc version 3.3.6 (Ubuntu 1:3.3.6-15ubuntu1)


> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Do you have any other patches with which you would like to forward this
one?  Or, shall I send it upstream on its own?

-- Dave

