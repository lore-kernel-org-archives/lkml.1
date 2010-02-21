Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0BUQgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:36:12 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50775
	"EHLO grelber.thyrsus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752870Ab0BUQgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:36:10 -0500
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 11:36:10 EST
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: qemu-devel@nongnu.org
Subject: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
Date: Sun, 21 Feb 2010 10:25:09 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-17-generic; KDE/4.2.2; x86_64; ; )
Cc: Blue Swirl <blauwirbel@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
       Artyom Tarasenko <atar4qemu@googlemail.com>,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, davem@davemloft.net
References: <201002110520.07620.rob@landley.net> <f43fc5581002201359x50aff2b1ofc4f816762bda597@mail.gmail.com> <201002201712.23628.rob@landley.net>
In-Reply-To: <201002201712.23628.rob@landley.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002211025.11588.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 February 2010 17:12:22 Rob Landley wrote:
> On Saturday 20 February 2010 15:59:31 Blue Swirl wrote:
> > > I've got 2.6.32 booting to a command prompt (albeit with serial console
> > > and intentionall restricted set of hardware).  But then it misbehaves.
> > >
> > >  I'll try getting 2.6.18 to build with a known .config, and then bisect
> > > forward if that seems to work...
> >
> > Good plan. Bisecting backwards could be interesting too, to find out
> > which releases are actually working out of the box.
>
> I started by iterating through the release versions.  It's working up
> through 2.6.28, then 2.6.29 has the out of memory error in my init script.
>
> Bisecting now...
>
> Rob

And the commit that broke it bisects to:

085219f79cad89291699bd2bfb21c9fdabafe65f is first bad commit
commit 085219f79cad89291699bd2bfb21c9fdabafe65f
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Fri Jan 2 18:47:34 2009 -0800

    sparc32: use proper types in struct stat
    
    Like sparc64 use proper types in struct stat
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

This commit breaks stat and makes sparc32 essentially unusable.  It changes 
the size of the various types in stat.h, and means that if you "mount -t tmpfs 
/tmp /tmp" and then try to ls /tmp, ls dies with a memory allocation error.

I've confirmed that reverting it fixes the problem.

Looking at the actual diff, here's the hunk that causes problems:

--- a/arch/sparc/include/asm/stat_32.h
+++ b/arch/sparc/include/asm/stat_32.h
        short           st_nlink;
-       unsigned short  st_uid;
-       unsigned short  st_gid;
+       uid_t           st_uid;
+       gid_t           st_gid;

The symptom (in my uClibc+busybox root filesystem) is:

/ # mount -t tmpfs /tmp /tmp
/ # ls -l /tmp
ls: can't open '/tmp': Cannot allocate memory
total 0

The problem is that both uid_t and gid_t are "int" instead of "short".  This 
patch changes the size of those types.  (I note that this is apparently a 
known issue, there's __compat_uid_t and friends in the sparc asm directory...)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
