Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462Ab0AIWsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0AIWsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 17:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301Ab0AIWs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 17:48:29 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:65145 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0AIWs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 17:48:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=pFM3B6knvEtz3A96SzZRykTtK6qKPPupT523C0had5JMYReKa02f+YKLhuB7r9r9Aq
         +P2YQOnBRUCU+nA+d23sP/7O1zySkyVP5m6nPOGclEHkdoDRSJ7QAFyOtbh+gDyhK0ZV
         OdWyvwHT1vYImrPkpy8CXEiFTNBnTgPBZ5Ov0=
Date: Sat, 9 Jan 2010 16:48:28 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>,
       Sebastian =?iso-8859-1?Q?Dalfu=DF?= <sd@sedf.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Alek Du <alek.du@intel.com>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kbuild fix for 2.6.33
Message-ID: <20100109224827.GA30610@progeny.tock>
References: <20100105155038.GA20834@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100105155038.GA20834@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Michal Marek wrote:

> please pull this to fix build with /bin/sh -> dash (as used in Ubuntu).

Could you look over this patch and perhaps apply it?  In the
grand scheme of things, it is a small issue, but it has been
offering some Debian and Ubuntu users a lot of annoyance.

The problem is that dash's echo and printf do not support \x...
escapes.  The symptom is a build without errors resulting in a
vmlinuz that cannot boot.

Thanks,
Jonathan

> The following changes since commit 45d28b097280a78893ce25a5d0db41e6a2717853:
>   Linus Torvalds (1):
>         Merge branch 'reiserfs/kill-bkl' of git://git.kernel.org/.../frederic/random-tracing
> 
> are available in the git repository at:
> 
>   git://repo.or.cz/linux-kbuild.git for-33

-- %< --
From: Jonathan Nieder <jrnieder@gmail.com>
Date: Mon, 28 Dec 2009 19:38:27 +0000
Subject: [PATCH] kbuild: really fix bzImage build with non-bash sh

dash's echo and printf do not support \x... escapes.  The symptom
is a build without errors resulting in a vmlinuz that cannot
boot.

Previous commits replaced "echo -ne" first with "/bin/echo -ne",
then "printf" in the hope of improving portability, but none of
these commands is guaranteed to support hexadecimal escapes on
POSIX systems.  Use arithmetic expansion to convert from
hexadecimal to octal to fix this.

You can see what is happening by examining the end of
arch/x86/boot/compressed/vmlinux.bin.lzma after an x86 build with
CONFIG_KERNEL_LZMA enabled and /bin/sh a symlink to dash.
Without this patch, it ends with '\xf0\x7d\x39\x00' (16 bytes)
instead of the 4 bytes intended and the resulting vmlinuz fails
to boot.

With this change, an LZMA-compressed kernel built with dash as sh
boots correctly again.

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14907
Reported-by: Sebastian Dalfuﬂ <sd@sedf.de>
Reported-by: Oliver Hartkopp <oliver@hartkopp.net>
Reported-by: Michael Guntsche <mike@it-loops.com>
Tested-by: Meelis Roos <mroos@linux.ee>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alek Du <alek.du@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 scripts/Makefile.lib |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cd815ac..eabedbb 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -219,8 +219,13 @@ for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x" $$dec_size |						\
-	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
+printf "%08x\n" $$dec_size |						\
+	sed 's/\(..\)/\1 /g' | {					\
+		read ch0 ch1 ch2 ch3;					\
+		for ch in $$ch3 $$ch2 $$ch1 $$ch0; do			\
+			printf '%s%03o' '\\' $$((0x$$ch)); 		\
+		done;							\
+	}								\
 )
 
 quiet_cmd_bzip2 = BZIP2   $@
-- 
1.6.6

