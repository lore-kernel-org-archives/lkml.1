Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbXDXE2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbXDXE2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXDXE2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:28:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXDXE2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:28:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 03/25] xen: Add nosegneg capability to the vsyscall page
 notes
In-Reply-To: Jeremy Fitzhardinge's message of  Monday, 23 April 2007 18:24:12 -0700 <462D5C3C.4000406@goop.org>
X-Windows: sometimes you fill a vacuum and it still sucks.
Message-Id: <20070424042653.37F421801A4@magilla.sf.frob.com>
Date: Mon, 23 Apr 2007 21:26:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have to admit I still don't really understand all this.  Is it
> documented somewhere?

I have explained it in public more than once, but I don't know off hand
anywhere that was helpfully recorded.

> What does "hwcap 0 nosegneg" actually mean?  What does the "0" mean here?

ldconfig is usually run at library install time.  It reads ld.so.conf (and
its include files, usually found in /etc/ld.so.conf.d/*.conf).  ldconfig
finds libraries on the disk and stores their names in ld.so.cache.  For
libraries in "hwcap directories", it records in ld.so.cache a bitmask of
hwcap bits for each library, based on which hwcap names appeared in the
library file name.  The hard-wired hwcap names are things such as "mmx" and
"sse2", a chosen subset of the AT_HWCAP bits the kernel provides.  

When the dynamic linker is finding a library at runtime, it uses a match
from ld.so.cache unless none was found or LD_LIBRARY_PATH was set.  When
there is no cache hit, it searches a directory path for the library's name.
The subset of hwcap names whose AT_HWCAP bits are set yields a list of
subdirectories to try under each directory in the path.  To see the list:

$ LD_LIBRARY_PATH=/lib:/usr/lib LD_DEBUG=libs /bin/true
     21491:     find library=libc.so.6 [0]; searching
     21491:      search path=/lib/tls/i686/sse2:/lib/tls/i686:/lib/tls/sse2:/lib/tls:/lib/i686/sse2:/lib/i686:/lib/sse2:/lib:/usr/lib/tls/i686/sse2:/usr/lib/tls/i686:/usr/lib/tls/sse2:/usr/lib/tls:/usr/lib/i686/sse2:/usr/lib/i686:/usr/lib/sse2:/usr/lib            (system search path)

(Here you can notice that "tls" is used as a pseudo-hwcap; it is in fact
hard-wired into the list if the dynamic linker supports ELF TLS, which all
recent ones do.  Also you'll notice "i686" is not a hwcap bit, but is the
AT_PLATFORM string, which is treated similarly.)

The hwcap bitmasks in ld.so.cache are intended to make the single cache
file equivalent to this varying search path depending on runtime hwcap bits
set.  A cache entry whose bitmask has bits not set at runtime is ignored.
Running "ldconfig -p | grep hwcap" (read-only, need not be root) will show
you any entries in your ld.so.cache that have an hwcap bitmask set.

The "hwcap" directive in ld.so.conf tells ldconfig to understand a new
hwcap name that is not in the hard-wired set.  There is some number of
extra bits available; "hwcap 0" assigns the first extra bit, "hwcap 1" the
second, and so on.  The name is what to use as a subdirectory name,
analogous to "sse2" et al.

On my system with an ld.so.conf.d file installed doing "hwcap 0 nosegneg":

$ ldconfig -p | grep libc.so.6
        libc.so.6 (libc6, hwcap: 0x0018000000000000, OS ABI: Linux 2.6.9) => /lib/i686/nosegneg/libc.so.6
        libc.so.6 (libc6, OS ABI: Linux 2.6.9) => /lib/libc.so.6

(There are two bits set because the "tls" pseudo-bit is also set.)

With this in ld.so.cache, the libc.so.6 lookup will find
/lib/i686/nosegneg/libc.so.6 first, but only if the hwcap bit set.

> In the ELF note, what does the "nosegneg" string mean?  How is it used? 
> Is it compared to the "nosegneg" in ld.so.conf?  How does this relate to
> the bitfields?

Each bit + string element in the note (there's just the one in what we
have) establishes for the dynamic linker at runtime the association between
the "extra" pseudo-hwcap bit number and the name.  If that pseudo-hwcap is
enabled, then that string will figure into the directory search path as
"sse2" does in the example above.  This string is never consulted when
looking in ld.so.cache.

The mask field in NOTE_KERNELCAP_BEGIN says which "extra" bits are enabled.
If the corresponding bit is not set here, then it's just like a hard-wired
hwcap bit like "sse2" when that bit was not set in AT_HWCAP.  That is, a
cache lookup will ignore entries with that hwcap bit in their bitmask, and
that hwcap name will not be used in constructing the directory search path.
I put this bitmask in so that the kernel has the option of using a single
vDSO image for multiple different runtime configurations.  It can simply
modify the bitmask in the image at setup time to disable some entries.

For example, a Xen-enabled kernel can use a single vDSO image (or a single
pair of int80/sysenter images), containing the "nosegneg" hwcap note.  When
there is no need for it (native or hvm or 64-bit hv or whatever), it just
clears the mask word.  If you actually do this, you'll want to modify the
NOTE_KERNELCAP_BEGIN macro to define a global label you can use with VDSO_SYM.



Thanks,
Roland
