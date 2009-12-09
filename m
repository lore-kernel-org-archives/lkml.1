Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZLIQFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZLIQFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZLIQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:05:29 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:47025 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZLIQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OyvhZwE+yE3IGlI+BJRWhhKUe2No326MFDm9rP4vGnxmHDHcFkdFO8eVy9mWS9bOja
         M8jV+N0YKnrJNoMbC8qbPFl+meS8m9FeoRg9bVHho7Qq1qPpkT3g6JSY1GHfofArzuO5
         W+1KQwYD6/hToJTo3J5YGaOwBOWHbKz2LRZ3o=
Date: Wed, 9 Dec 2009 23:59:03 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modpost: fix asprintf warnings
Message-ID: <20091209155903.GB3247@hack>
References: <1260360143-17093-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260360143-17093-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 07:02:23AM -0500, Mike Frysinger wrote:
>On compilers with security warnings enabled by default, we get:
>
>scripts/mod/modpost.c: In function 'get_markers':
>scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf',
>                                     declared with attribute warn_unused_result
>scripts/mod/modpost.c: In function 'add_marker':
>scripts/mod/modpost.c:1982: warning: ignoring return value of 'asprintf',
>                                     declared with attribute warn_unused_result
>
>So check the return value and abort on errors.
>
>Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>---
> scripts/mod/modpost.c |    6 ++++--
> 1 files changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
>index 801a16a..c4df538 100644
>--- a/scripts/mod/modpost.c
>+++ b/scripts/mod/modpost.c
>@@ -1559,7 +1559,8 @@ static void get_markers(struct elf_info *info, struct module *mod)
> 			const char *name = strings + sym->st_value;
> 			const char *fmt = strchr(name, '\0') + 1;
> 			char *line = NULL;
>-			asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
>+			if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
>+				fatal("asprintf() with %s failed", name);

A '\n' is needed.

> 			NOFAIL(line);
> 			mod->markers[n++] = line;
> 		}
>@@ -1979,7 +1980,8 @@ static void write_dump(const char *fname)
> static void add_marker(struct module *mod, const char *name, const char *fmt)
> {
> 	char *line = NULL;
>-	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
>+	if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
>+		fatal("asprintf() with %s failed", name);
> 	NOFAIL(line);
> 
> 	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
>-- 
>1.6.5.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
