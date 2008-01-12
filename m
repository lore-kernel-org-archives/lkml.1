Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbYALIDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbYALIDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 03:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759542AbYALIDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 03:03:33 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59650 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916AbYALIDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 03:03:32 -0500
Date: Sat, 12 Jan 2008 09:03:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: EGRY Gabor <gaboregry1@t-online.hu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, mikael.starvik@axis.com,
       jesper.nilsson@axis.com
Subject: Re: [PATCH 1/10] kconfig: update-po-config info
Message-ID: <20080112080336.GB30402@uranus.ravnborg.org>
References: <1200091200.10603.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200091200.10603.30.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:40:00PM +0100, EGRY Gabor wrote:
> 
> This patch adds tracking messages.
> 
> Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

To anyone that try out this patch serie just a minor note.
"make update-po-config" will fail if applied
on top of kbuild.git.

This is because cris does some tricks with symlinks to
source the correct Kconfig file.

The Axis' people already fixed this and the fix is in -mm
and so I asked Egry not to workaround this issue in this patchset.

The quick workaround is to just delete the cris directory in
arch/ if you try it out.
When we hit the merge window it will be fixed in a proper
way by the patch from Axis.

At present menuconfig does not support wide chars which
I guess some would like to see. I know Egry has this in
the works and I hope to apply that patch soon.

The full patch serie posted here will apprear in kbuild.git
later today so we hopefully can have it beaten a little in
-mm before the merge window.

It is late in the cycle but the patches are nicely splitted
and easy to review.

	Sam 


> ---
> 
>  kbuild-szilard/scripts/kconfig/Makefile |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff -puN scripts/kconfig/Makefile~kconfig-i18n-02-update-po-fix scripts/kconfig/Makefile
> --- kbuild/scripts/kconfig/Makefile~kconfig-i18n-02-update-po-fix	2008-01-11 22:16:06.000000000 +0100
> +++ kbuild-szilard/scripts/kconfig/Makefile	2008-01-11 22:27:38.000000000 +0100
> @@ -24,22 +24,25 @@ oldconfig: $(obj)/conf
>  silentoldconfig: $(obj)/conf
>  	$< -s $(Kconfig)
>  
> -# Create new linux.po file
> +# Create new linux.pot file
>  # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
>  # The symlink is used to repair a deficiency in arch/um
>  update-po-config: $(obj)/kxgettext
> -	xgettext --default-domain=linux                  \
> +	$(Q)echo "  GEN config"
> +	$(Q)xgettext --default-domain=linux              \
>  	    --add-comments --keyword=_ --keyword=N_      \
>  	    --from-code=UTF-8                            \
>  	    --files-from=scripts/kconfig/POTFILES.in     \
>  	    --output $(obj)/config.pot
>  	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
>  	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
> -	(for i in `ls arch/`;                            \
> -	do                                               \
> -	    $(obj)/kxgettext arch/$$i/Kconfig;           \
> -	done ) >> $(obj)/config.pot
> -	msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
> +	$(Q)(for i in `ls arch/`;                        \
> +	    do                                           \
> +		echo "  GEN $$i";                        \
> +		$(obj)/kxgettext arch/$$i/Kconfig        \
> +		     >> $(obj)/config.pot;               \
> +	    done )
> +	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
>  	    --output $(obj)/linux.pot
>  	$(Q)rm -f arch/um/Kconfig.arch
>  	$(Q)rm -f $(obj)/config.pot
> @@ -138,6 +141,7 @@ endif
>  clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
>  		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c
>  clean-files     += mconf qconf gconf
> +clean-files     += config.pot linux.pot
>  
>  # Check that we have the required ncurses stuff installed for lxdialog (menuconfig)
>  PHONY += $(obj)/dochecklxdialog
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
