Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbZD0St4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbZD0St4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZD0Str
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:49:47 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34353 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZD0Stq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:49:46 -0400
Date: Mon, 27 Apr 2009 20:51:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 8/8] Remove unused support code for refok sections.
Message-ID: <20090427185156.GH12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <1240855347-19316-5-git-send-email-tabbott@mit.edu> <1240855347-19316-6-git-send-email-tabbott@mit.edu> <1240855347-19316-7-git-send-email-tabbott@mit.edu> <1240855347-19316-8-git-send-email-tabbott@mit.edu> <1240855347-19316-9-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-9-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:27PM -0400, Tim Abbott wrote:
> The old refok sections
> 
>   .text.init.refok
>   .data.init.refok
>   .exit.text.refok
> 
> have been deprecated since commit
> 312b1485fb509c9bc32eda28ad29537896658cb8.  After the other patches in
> this patch series nothing is put in these sections, so clean things up
> by eliminating all the remaining references to them.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Sam Ravnborg <sam@ravnborg.org>

I like this cleanup!
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  include/asm-generic/vmlinux.lds.h |    3 ---
>  include/linux/init.h              |    8 --------
>  scripts/mod/modpost.c             |   18 ------------------
>  3 files changed, 0 insertions(+), 29 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index eaa06ef..89853bc 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -90,7 +90,6 @@
>  /* .data section */
>  #define DATA_DATA							\
>  	*(.data)							\
> -	*(.data.init.refok)						\
>  	*(.ref.data)							\
>  	DEV_KEEP(init.data)						\
>  	DEV_KEEP(exit.data)						\
> @@ -289,8 +288,6 @@
>  		*(.text.hot)						\
>  		*(.text)						\
>  		*(.ref.text)						\
> -		*(.text.init.refok)					\
> -		*(.exit.text.refok)					\
>  	DEV_KEEP(init.text)						\
>  	DEV_KEEP(exit.text)						\
>  	CPU_KEEP(init.text)						\
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 20a1334..0e06c17 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -62,14 +62,6 @@
>  #define __refdata        __section(.ref.data)
>  #define __refconst       __section(.ref.rodata)
>  
> -/* backward compatibility note
> - *  A few places hardcode the old section names:
> - *  .text.init.refok
> - *  .data.init.refok
> - *  .exit.text.refok
> - *  They should be converted to use the defines from this file
> - */
> -
>  /* compatibility defines */
>  #define __init_refok     __ref
>  #define __initdata_refok __refdata
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index df6e628..8d46ea7 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -794,15 +794,6 @@ static const char *init_exit_sections[] =
>  /* data section */
>  static const char *data_sections[] = { DATA_SECTIONS, NULL };
>  
> -/* sections that may refer to an init/exit section with no warning */
> -static const char *initref_sections[] =
> -{
> -	".text.init.refok*",
> -	".exit.text.refok*",
> -	".data.init.refok*",
> -	NULL
> -};
> -
>  
>  /* symbols in .data that may refer to init/exit sections */
>  static const char *symbol_white_list[] =
> @@ -915,11 +906,6 @@ static int section_mismatch(const char *fromsec, const char *tosec)
>  /**
>   * Whitelist to allow certain references to pass with no warning.
>   *
> - * Pattern 0:
> - *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
> - *   The pattern is identified by:
> - *   fromsec = .text.init.refok* | .data.init.refok*
> - *
>   * Pattern 1:
>   *   If a module parameter is declared __initdata and permissions=0
>   *   then this is legal despite the warning generated.
> @@ -958,10 +944,6 @@ static int section_mismatch(const char *fromsec, const char *tosec)
>  static int secref_whitelist(const char *fromsec, const char *fromsym,
>  			    const char *tosec, const char *tosym)
>  {
> -	/* Check for pattern 0 */
> -	if (match(fromsec, initref_sections))
> -		return 0;
> -
>  	/* Check for pattern 1 */
>  	if (match(tosec, init_data_sections) &&
>  	    match(fromsec, data_sections) &&
> -- 
> 1.6.2.1
> 
