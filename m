Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254Ab0AENTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab0AENTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977Ab0AENTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:19:18 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:45599 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab0AENTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:19:17 -0500
Date: Tue, 5 Jan 2010 14:19:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
 <20100104174308.0790757c@infradead.org>
 <20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
 <201001051347.21309.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001051347.21309.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:47:20PM +0100, Arnd Bergmann wrote:
> On Tuesday 05 January 2010, Heiko Carstens wrote:
> > On Mon, Jan 04, 2010 at 05:43:08PM -0800, Arjan van de Ven wrote:
> > > On Mon, 4 Jan 2010 16:43:45 +0100
> > > Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > x86 and sparc return -EFAULT in copy_from_user instead of the number
> > > > of not copied bytes as it should in case of a detected buffer
> > > > overflow. That might have unwanted side effects. I would guess that
> > > > is a bug.
> > > 
> > > killing the bad guy in case of a real buffer overflow is appropriate..
> > > this should never trigger for legitimate users.
> > 
> > The point I tried to make is that no caller of copy_from_user can assume
> > that it would ever return -EFAULT. And if any caller does so it is broken.
> > But then again it probably doesn't matter in this case as long as something
> > != 0 is returned.
> 
> To quote simple_read_from_buffer():
> 
>         size_t ret;
> 	...
>         ret = copy_to_user(to, from + pos, count);
>         if (ret == count)
>                 return -EFAULT;
>         count -= ret;
>         *ppos = pos + count;
>         return count;
> 
> If copy_from_user() returns a negative value, bad things happen to f_pos
> and to the value returned from the syscall. Many read() file_operations
> do this similarly, and I wouldn't be surprised if this could be turned
> into a security exploit for one of them (not simple_read_from_buffer
> probably).

Thanks Arnd. I was looking for such an example. That's why I was about to
send the patch below (untested).

Subject: [PATCH] x86: copy_from_user() should not return -EFAULT

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Callers of copy_from_user() expect it to return the number of bytes
it could not copy. In no case it is supposed to return -EFAULT.

In case of a detected buffer overflow just return the requested
length. In addition one could think of a memset that would clear
the size of the target object.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/x86/include/asm/uaccess_32.h |    5 ++---
 arch/x86/include/asm/uaccess_64.h |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -205,14 +205,13 @@ static inline unsigned long __must_check
 					  unsigned long n)
 {
 	int sz = __compiletime_object_size(to);
-	int ret = -EFAULT;
 
 	if (likely(sz == -1 || sz >= n))
-		ret = _copy_from_user(to, from, n);
+		n = _copy_from_user(to, from, n);
 	else
 		copy_from_user_overflow();
 
-	return ret;
+	return n;
 }
 
 long __must_check strncpy_from_user(char *dst, const char __user *src,
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -30,16 +30,15 @@ static inline unsigned long __must_check
 					  unsigned long n)
 {
 	int sz = __compiletime_object_size(to);
-	int ret = -EFAULT;
 
 	might_fault();
 	if (likely(sz == -1 || sz >= n))
-		ret = _copy_from_user(to, from, n);
+		n = _copy_from_user(to, from, n);
 #ifdef CONFIG_DEBUG_VM
 	else
 		WARN(1, "Buffer overflow detected!\n");
 #endif
-	return ret;
+	return n;
 }
 
 static __always_inline __must_check
