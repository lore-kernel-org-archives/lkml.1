Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0CAWTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:19:17 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52213 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0CAWTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AMuoJh9b5q1BgW4N8DeLI60i5rN8nb1nTzXS/cCCBYajpECtdQXAzoIUHVxkFkwUB4
         6FVK3bPvvHHfatQyPyqnULDX4opnk/FSbEgnb/wLsZVVNX8ByHwa9z1TjE7MxMBjaRlQ
         uPS7gCSeYT8sXzuTKSNixZOTuFyfx+j/jnEhE=
MIME-Version: 1.0
In-Reply-To: <tip-98059e3463383b18fd79181179cd539b74846b47@git.kernel.org>
References: <40101cc30910010811v5d15ff4cx9dd57c9cc9b4b045@mail.gmail.com> 
	<tip-98059e3463383b18fd79181179cd539b74846b47@git.kernel.org>
From: Matteo Croce <technoboy85@gmail.com>
Date: Mon, 1 Mar 2010 23:18:53 +0100
Message-ID: <40101cc31003011418r3ea15f1bg285ddda7681cf8f9@mail.gmail.com>
Subject: Re: [tip:x86/cpu] x86: AMD Geode LX optimizations
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, technoboy85@gmail.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 7:27 PM, tip-bot for Matteo Croce
<technoboy85@gmail.com> wrote:
> Commit-ID:  98059e3463383b18fd79181179cd539b74846b47
> Gitweb:     http://git.kernel.org/tip/98059e3463383b18fd79181179cd539b74846b47
> Author:     Matteo Croce <technoboy85@gmail.com>
> AuthorDate: Thu, 1 Oct 2009 17:11:10 +0200
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 2 Oct 2009 11:24:28 -0700
>
> x86: AMD Geode LX optimizations
>
> Add CPU optimizations for AMD Geode LX.
>
> Signed-off-by: Matteo Croce <technoboy85@gmail.com>
> LKML-Reference: <40101cc30910010811v5d15ff4cx9dd57c9cc9b4b045@mail.gmail.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>
>
> ---
>  arch/x86/Kconfig.cpu     |    2 +-
>  arch/x86/Makefile_32.cpu |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index 527519b..979de29 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -406,7 +406,7 @@ config X86_CMPXCHG64
>  # generates cmov.
>  config X86_CMOV
>        def_bool y
> -       depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM)
> +       depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
>
>  config X86_MINIMUM_CPU_FAMILY
>        int
> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> index 30e9a26..cbf0776 100644
> --- a/arch/x86/Makefile_32.cpu
> +++ b/arch/x86/Makefile_32.cpu
> @@ -41,7 +41,7 @@ cflags-$(CONFIG_X86_ELAN)     += -march=i486
>
>  # Geode GX1 support
>  cflags-$(CONFIG_MGEODEGX1)     += -march=pentium-mmx
> -
> +cflags-$(CONFIG_MGEODE_LX)     += $(call cc-option,-march=geode,-march=pentium-mmx)
>  # add at the end to overwrite eventual tuning options from earlier
>  # cpu entries
>  cflags-$(CONFIG_X86_GENERIC)   += $(call tune,generic,$(call tune,i686))
>

Unfortunately it seems that GCC produces slower code with -march=geode
and that the fastest code is generated with -march=i686:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=41989

We have two possible solutions: revert the flags or wait for the GCC
folks to fix the compiler.
In the meantime I discovered that even the older Geode GX does have
CMOV and MMX so
have a look at this new patch

Signed-off-by: Matteo Croce <technoboy85@gmail.com>

--- a/arch/x86/Kconfig.cpu	2010-03-01 00:45:39.484611338 +0100
+++ b/arch/x86/Kconfig.cpu	2010-03-01 00:46:08.776560999 +0100
@@ -402,7 +402,7 @@
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM ||
MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE ||
MEFFICEON || X86_64 || MATOM || MGEODE_LX)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM ||
MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE ||
MEFFICEON || X86_64 || MATOM || MGEODEGX1 || MGEODE_LX)

 config X86_MINIMUM_CPU_FAMILY
 	int
--- a/arch/x86/Makefile_32.cpu	2010-03-01 00:44:07.948526792 +0100
+++ b/arch/x86/Makefile_32.cpu	2010-03-01 23:15:48.503698008 +0100
@@ -40,7 +40,7 @@
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486

 # Geode GX1 support
-cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
+cflags-$(CONFIG_MGEODEGX1)	+= $(call cc-option,-march=geode,-march=pentium-mmx)
 cflags-$(CONFIG_MGEODE_LX)	+= $(call cc-option,-march=geode,-march=pentium-mmx)
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
