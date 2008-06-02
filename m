Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYFBRmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYFBRmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYFBRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:41:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:20997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYFBRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oIUanymDbgxa19m4ilkmYR/DTjwTOOqUTuBVRb48Ho82X888U/K7b6ILf2mhl1/6+R4pE9J50EkObC2bMPzQ6l5wvaEzGZej7qiLO4ZLdiutY4enWRzN8qDFbTvgOtRR5GdLlDTXfrsvcKQ8h1i7xTi7p3n+gtmvmbFZ3oWdXss=
Message-ID: <19f34abd0806021041m20858599x8d35c9684efe8977@mail.gmail.com>
Date: Mon, 2 Jun 2008 19:41:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: [PATCH] quota: Remove use of info_any_dirty()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <12124266712838-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12124266712214-git-send-email-jack@suse.cz>
	 <12124266711334-git-send-email-jack@suse.cz>
	 <12124266712838-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 2, 2008 at 7:11 PM, Jan Kara <jack@suse.cz> wrote:
> Since there is only a single place which uses info_any_dirty() and that
> is a trivial macro, just remove the use of this macro completely.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/quota.c            |    7 +++++--
>  include/linux/quota.h |    2 --
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/quota.c b/fs/quota.c
> index db1cc9f..f0702f4 100644
> --- a/fs/quota.c
> +++ b/fs/quota.c
> @@ -199,8 +199,11 @@ restart:
>        list_for_each_entry(sb, &super_blocks, s_list) {
>                /* This test just improves performance so it needn't be reliable... */
>                for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
> -                       if ((type == cnt || type == -1) && sb_has_quota_enabled(sb, cnt)
> -                           && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
> +                       if ((type == cnt || type == -1)
> +                           && sb_has_quota_enabled(sb, cnt)
> +                           && (info_dirty(&sb_dqopt(sb)->info[cnt])
> +                               || !list_empty(&sb_dqopt(sb)->
> +                                       info[cnt].dqi_dirty_list)))
>                                dirty = 1;

This is really too hideous in my opinion and looks like a candidate
for its own static inline function.

Or you can try to rewrite the boolean expression on multiple lines
using continue, something like:

-               for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++)
-                       if ((type == cnt || type == -1) && sb_has_quota_enabled(
-                           && info_any_dirty(&sb_dqopt(sb)->info[cnt]))
-                               dirty = 1;
+               for (cnt = 0, dirty = 0; cnt < MAXQUOTAS; cnt++) {
+                       if (type != cnt && type != -1)
+                               continue;
+                       if (!sb_has_quota_enabled(sb, cnt))
+                               continue;
+                       if (!info_any_dirty(&sb_dqopt(sb)->info[cnt]))
+                               continue;
+                       dirty = 1;
+               }

(This uses the original macro, I know. How about moving that from the
header to a new inline function just above this function?)

What do you think?


Vegard

PS: This is a really good clean-up effort. Good work!

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
