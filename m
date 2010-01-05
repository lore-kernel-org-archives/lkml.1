Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237Ab0AEN7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0AEN7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977Ab0AEN7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:59:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab0AEN7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:59:14 -0500
Message-ID: <4B4345AF.9040600@suse.cz>
Date: Tue, 05 Jan 2010 14:59:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [patch] kbuild: improve version string logic
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.1.2010 22:31, David Rientjes wrote:
> The LOCALVERSION= string passed to "make" will now always be appended to
> the kernel version after CONFIG_LOCALVERSION, if it exists, regardless of
> whether CONFIG_LOCALVERSION_AUTO is set or not.  This allows users to
> uniquely identify their kernel builds with a string.
> 
> scripts/setlocalversion will now always be called to determine whether
> the repository is beyond a tagged (release) commit.  When at a tagged
> commit, this script will now suppress all output.
> 
> If CONFIG_LOCALVERSION_AUTO is enabled, the unique SCM tag reported by 
> setlocalversion (or .scmversion) is appended to the kernel version, if it 
> exists.  When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
> to the kernel version to represent that the kernel has been revised since
> the last release unless "make LOCALVERSION=" was used to uniquely identify
> the build.
> 
> The end result is this:
> 
>  - when LOCALVERSION= is passed to "make", it is appended to the kernel
>    version,
> 
>  - when CONFIG_LOCALVERSION_AUTO is enabled, a unique SCM identifier is
>    appended if the respository has been revised beyond a tagged commit,
>    and
> 
>  - when CONFIG_LOCALVERSION_AUTO is disabled, a `+' is appended if the 
>    repository has been revised beyond a tagged commit and LOCALVERSION=
>    was not passed to "make".

I've read the thread from last October where this was discussed
(http://thread.gmane.org/gmane.linux.kernel/897768/focus=898233). I'm
not entirely sure if all people will be happy about the plus sign that
can't be turned off, but from the thread I got the impression that the
plus sign is wanted, so let's add this to linux-next now, so that people
doing automated builds can adjust their scripts if needed. Just in case:
Stephen, won't this break your linux-next scripts in any way? The final
build won't change, because of the next-YYYYMMDD tag, but the builds in
between will have the '+' appended to their version.


Two small comments are below.

> Examples:
> 
> With CONFIG_LOCALVERSION_AUTO: "make" results in
> v2.6.32-rc4-00149-ga3ccf63.  If there are uncommited changes to the
> respository, it results in v2.6.32-rc4-00149-ga3ccf63-dirty.  If
> "make LOCALVERSION=kbuild" were used, it results in
> v2.6.32-rc4-kbuild-00149-ga3ccf63-dirty.
> 
> Without CONFIG_LOCALVERSION_AUTO, "make" results in v2.6.32-rc4+
> unless the repository is at the Linux v2.6.32-rc4 commit (in which
> case the version would be v2.6.32-rc4).  If "make LOCALVERSION=kbuild"
> were used, it results in v2.6.32-rc4-kbuild.
> 
> Also renames variables such as localver-auto and _localver-auto to more 
> accurately describe what they represent: localver-extra and
> scm-identifier, respectively.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Makefile                |   43 +++++++++++++++++++++++++++----------------
>  scripts/setlocalversion |    3 ++-
>  2 files changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> --- a/Makefile
> +++ b/Makefile
> @@ -898,14 +898,19 @@ $(vmlinux-dirs): prepare scripts
>  #	  $(localver)
>  #	    localversion*		(files without backups, containing '~')
>  #	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
> -#	  $(localver-auto)		(only if CONFIG_LOCALVERSION_AUTO is set)
> -#	    ./scripts/setlocalversion	(SCM tag, if one exists)
> -#	    $(LOCALVERSION)		(from make command line if provided)
> +#	    $(LOCALVERSION)		(from make command line, if provided)

$(LOCALVERSION) is no longer part of $(localver), it should be indented
at the same level.


> +#	  $(localver-extra)
> +#	    $(scm-identifier)		(unique SCM tag, if one exists)
> +#	      ./scripts/setlocalversion	(only with CONFIG_LOCALVERSION_AUTO)
> +#	      .scmversion		(only with CONFIG_LOCALVERSION_AUTO)
> +#	    +				(only without CONFIG_LOCALVERSION_AUTO
> +#					 and without LOCALVERSION= and 
> +#					 repository is at non-tagged commit)
>  #
> -#  Note how the final $(localver-auto) string is included *only* if the
> -# kernel config option CONFIG_LOCALVERSION_AUTO is selected.  Also, at the
> -# moment, only git is supported but other SCMs can edit the script
> -# scripts/setlocalversion and add the appropriate checks as needed.
> +# For kernels without CONFIG_LOCALVERSION_AUTO compiled from an SCM that has
> +# been revised beyond a tagged commit, `+' is appended to the version string
> +# when not overridden by using "make LOCALVERSION=".  This indicates that the
> +# kernel is not a vanilla release version and has been modified.
>  
>  pattern = ".*/localversion[^~]*"
>  string  = $(shell cat /dev/null \
> @@ -914,26 +919,32 @@ string  = $(shell cat /dev/null \
>  localver = $(subst $(space),, $(string) \
>  			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
>  
> -# If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called
> -# and if the SCM is know a tag from the SCM is appended.
> -# The appended tag is determined by the SCM used.
> +# scripts/setlocalversion is called to create a unique identifier if the source
> +# is managed by a known SCM and the repository has been revised since the last
> +# tagged (release) commit.  The format of the identifier is determined by the
> +# SCM's implementation.
>  #
>  # .scmversion is used when generating rpm packages so we do not loose
>  # the version information from the SCM when we do the build of the kernel
>  # from the copied source
> -ifdef CONFIG_LOCALVERSION_AUTO
> -
>  ifeq ($(wildcard .scmversion),)
> -        _localver-auto = $(shell $(CONFIG_SHELL) \
> +        scm-identifier = $(shell $(CONFIG_SHELL) \
>                           $(srctree)/scripts/setlocalversion $(srctree))
>  else
> -        _localver-auto = $(shell cat .scmversion 2> /dev/null)
> +        scm-identifier = $(shell cat .scmversion 2> /dev/null)
>  endif
>  
> -	localver-auto  = $(LOCALVERSION)$(_localver-auto)
> +ifdef CONFIG_LOCALVERSION_AUTO
> +	localver-extra = $(scm-identifier)
> +else
> +	ifneq ($scm-identifier,)
> +		ifeq ($(LOCALVERSION),)
> +			localver-extra = +
> +		endif
> +	endif
>  endif
>  
> -localver-full = $(localver)$(localver-auto)
> +localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
>  
>  # Store (new) KERNELRELASE string in include/config/kernel.release
>  kernelrelease = $(KERNELVERSION)$(localver-full)
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -26,7 +26,8 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
>  		# If we are past a tagged commit (like "v2.6.30-rc5-302-g72357d5"),
>  		# we pretty print it.
>  		if atag="`git describe 2>/dev/null`"; then
> -			echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
> +			echo "$atag" | awk -F- 'int($(NF-1)) > 0	\
> +					{printf("-%05d-%s", $(NF-1),$(NF))}'
>
>  		# If we don't have a tag at all we print -g{commitish}.
>  		else

Why is this needed? There is

	# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore it,
	# because this version is defined in the top level Makefile.
	if [ -z "`git describe --exact-match 2>/dev/null`" ]; then

a few lines above and even without your patch ./scripts/setlocalversion
returns nothing when HEAD is tagged. Do you have an old git version that
doesn't undestand --exact-match? In that case, the if around this should
be removed.

thanks,
Michal
