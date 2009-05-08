Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZEHHkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZEHHkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZEHHkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:40:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49368 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZEHHkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:40:23 -0400
Date: Fri, 8 May 2009 09:42:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/14] kbuild: allow compressors (gzip, bzip2, lzma) to take multiple inputs
Message-ID: <20090508074234.GD12808@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-6-git-send-email-hpa@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241735222-6640-6-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 03:26:53PM -0700, H. Peter Anvin wrote:
> From: H. Peter Anvin <hpa@zytor.com>
> 
> Allow the compression commands in Kbuild (i.e. gzip, bzip2, lzma) to
> take multiple input files and emit the concatenated compressed
> output.  This avoids an intermediate step when a kernel image is built
> from multiple components, such as the relocatable x86-32 kernel.
> 
> [ Impact: new build feature, not yet used ]
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  scripts/Makefile.lib |   11 ++++++++---
>  scripts/bin_size     |    8 ++++++--
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 9796195..35dfdf6 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -183,7 +183,8 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
>  # ---------------------------------------------------------------------------
>  
>  quiet_cmd_gzip = GZIP    $@
> -cmd_gzip = gzip -f -9 < $< > $@
> +cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
> +	(rm -f $@ ; false)
>  
>  
>  # Bzip2
> @@ -193,10 +194,14 @@ cmd_gzip = gzip -f -9 < $< > $@
>  size_append=$(CONFIG_SHELL) $(srctree)/scripts/bin_size
>  
>  quiet_cmd_bzip2 = BZIP2    $@
> -cmd_bzip2 = (bzip2 -9 < $< && $(size_append) $<) > $@ || (rm -f $@ ; false)
> +cmd_bzip2 = (cat $(filter-out FORCE,$^) | \
> +	bzip2 -9 && $(size_append) $(filter-out FORCE,$^)) > $@ || \
> +	(rm -f $@ ; false)
>  
>  # Lzma
>  # ---------------------------------------------------------------------------
>  
>  quiet_cmd_lzma = LZMA    $@
> -cmd_lzma = (lzma -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
> +cmd_lzma = (cat $(filter-out FORCE,$^) | \
> +	lzma -9 && $(size_append) $(filter-out FORCE,$^)) > $@ || \
> +	(rm -f $@ ; false)
> diff --git a/scripts/bin_size b/scripts/bin_size
> index 43e1b36..55f2161 100644
> --- a/scripts/bin_size
> +++ b/scripts/bin_size
> @@ -1,10 +1,14 @@
>  #!/bin/sh
>  
>  if [ $# = 0 ] ; then
> -   echo Usage: $0 file
> +   echo Usage: $0 file...
>  fi
>  
> -size_dec=`stat -c "%s" $1`
> +size_dec=0
> +for file; do
> +  fsize=`stat -c "%s" $file`
> +  size_dec=`expr $size_dec + $fsize`
> +done
>  size_hex_echo_string=`printf "%08x" $size_dec |
>       sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'`
>  /bin/echo -ne $size_hex_echo_string

But I would rather have had this inside makefile.lib...

	Sam
