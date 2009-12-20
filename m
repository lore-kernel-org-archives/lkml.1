Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZLTLTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZLTLTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 06:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZLTLTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 06:19:44 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:57743 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZLTLTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 06:19:43 -0500
Message-ID: <4B2E084D.6080105@msgid.tls.msk.ru>
Date: Sun, 20 Dec 2009 14:19:41 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michal Marek <mmarek@suse.cz>, Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org>
In-Reply-To: <20091220100344.GA6614@merkur.ravnborg.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> We use ... printf \x ... when calculating the size of the
> compressed kernel.
> Unfortunately dash built-in printf does not support this notation
> resulting in a non-bootable kernel.
> 
> Fix this by always using the external version of printf.
> 
> The commit that introduced this bug was:
> 4a2ff67c88211026afcbdbc190c13f705dae1b59: "kbuild: fix bzImage
> build for x86"

It's not that simple Sam.  This commit is a part of the game.
It works neither with printf as after my commit above, nor with
original fix with `/bin/echo -ne'.  In neither case the fix is
complete or robust.  Because there are two places in the few lines,
around this, both affected and both are non-POSIX-conformant.

> Reported-by: Michael Guntsche <mike@it-loops.com>
> Cc: Oliver Hartkopp <oliver@hartkopp.net>
> Cc: Johannes Stezenbach <js@sig21.net>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
> This should fix it but it would be great if it is tested.
> Michal Marek, I think this needs to go upstream pretty quickly.

This whole issue only affects debian and ubuntu for now.
But the bug is very difficult to track down, since the prob
happens on early boot.

For now, I think, the best is to ensure we're building with
bash not dash.  Ie, SHELL=/bin/bash make ... will work.
Because even with this second fix, it still does not work
correctly with dash's echo and printf behaving differently
than bash's (but still conforming to POSIX).  It produces
good kernel, or at least I don't see any obvious probs with
the resulting kernel, but at least `make V=1' output looks
all wrong in this area (since dash's echo interpret \nnn
by default and make uses echo to print commands as they're
executed).

The right fix is to eliminate all this hack altogether.
Imho anyway.

/mjt

> 	Sam
> 
>  scripts/Makefile.lib |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index cd815ac..bd201d9 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -213,13 +213,14 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
>  
>  # Bzip2 and LZMA do not include size in file... so we have to fake that;
>  # append the size as a 32-bit littleendian number as gzip does.
> +# Note: dash built-in printf does not support \x so use /usr/bin version
>  size_append = printf $(shell						\
>  dec_size=0;								\
>  for F in $1; do								\
>  	fsize=$$(stat -c "%s" $$F);					\
>  	dec_size=$$(expr $$dec_size + $$fsize);				\
>  done;									\
> -printf "%08x" $$dec_size |						\
> +/usr/bin/printf "%08x" $$dec_size |						\
>  	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
>  )
>  

