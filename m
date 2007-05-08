Return-Path: <linux-kernel-owner+w=401wt.eu-S967345AbXEHSXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967345AbXEHSXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966894AbXEHSXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:23:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58901 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966725AbXEHSXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:23:33 -0400
Date: Tue, 8 May 2007 20:24:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@outflux.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: complain about missing system calls.
Message-ID: <20070508182424.GA31516@uranus.ravnborg.org>
References: <1178577575.11851.242.camel@pmac.infradead.org> <617E1C2C70743745A92448908E030B2A01719669@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A01719669@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 03:51:49PM -0700, Luck, Tony wrote:
> > You could add them to scripts/checksyscalls.sh itself -- I think it's
> > fairly unlikely that those are syscalls which a new arch port is going
> > to 'forget' :)
> 
> Like this?
> 
> diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> index f98171f..4d49056 100755
> --- a/scripts/checksyscalls.sh
> +++ b/scripts/checksyscalls.sh
> @@ -98,6 +98,14 @@ cat << EOF
>  #define __IGNORE_setgid32
>  #define __IGNORE_setfsuid32
>  #define __IGNORE_setfsgid32
> +/* ... some legacy names not used by ia64 */
> +#define __IGNORE_fork
> +#define __IGNORE_time
> +#define __IGNORE_alarm
> +#define __IGNORE_pause
> +#define __IGNORE_utime
> +#define __IGNORE_getpgrp
> +#define __IGNORE_vfork
>  
>  /* Unmerged syscalls for AFS, STREAMS, etc. */
>  #define __IGNORE_afs_syscall

I would prefer to introduce something in checksyscalls.sh that allows us
to do something arch specific.
I recall that x86_64 had one syscall implemented using VDSO or similar
and therefore got listed.
This is just a quick hack - can be done better by someone that is more
fluent in shell scripting...


diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index f98171f..715ed62 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -107,6 +107,13 @@ cat << EOF
 EOF
 }
 
+ignore_arch_list() {
+	f=include/asm/ignore_syscalls
+	if [ -f $f ]; then
+		source $f
+	fi
+}
+
 syscall_list() {
 sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
@@ -114,5 +121,5 @@ sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#endif/p }' $1
 }
 
-(ignore_list && syscall_list ${srctree}/include/asm-i386/unistd.h) | \
+(ignore_list && ignore_arch_list && syscall_list ${srctree}/include/asm-i386/unistd.h) | \
 $* -E -x c - > /dev/null

Then adding a fie like this to include/asm-x86_64 will allow us to ignore getcpu
for x86_64 only.

# syscalls that are ignored for x86_64
# on top of generic ones specified in scripts/checksyscalls.sh

cat << EOF
#define __IGNORE_getcpu
EOF



Comments?

	Sam
