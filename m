Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0BVSCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:02:02 -0500
Received: from gw1.transmode.se ([213.115.205.20]:45733 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0BVSCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:02:00 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2010 13:02:00 EST
In-Reply-To: <a9e22dff1002220840x7e86a1a0i3d44cefc1c6a79c0@mail.gmail.com>
References: <a9e22dff1002220826p63209a33n27e84ea10e191a19@mail.gmail.com> <a9e22dff1002220840x7e86a1a0i3d44cefc1c6a79c0@mail.gmail.com>
Subject: Re: [PATCH] jffs2: fix memory leak if the sector was successfully erased
X-KeepSent: B51E93AB:187F855F-C12576D2:00618F62;
 type=4; name=$KeepSent
To: niam <niam.niam@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFB51E93AB.187F855F-ONC12576D2.00618F62-C12576D2.0061DEB5@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 22 Feb 2010 18:49:00 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-02-22 18:53:36
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

niam <niam.niam@gmail.com> wrote on 2010/02/22 17:40:11:
>
> Resending patch to proper people/mailing list.
>
> Memory allocated for erase instruction is not freed if the sector was
> successfully erased.

NAK, jffs2_erase_callback() will free it so
you have added a double free I think. Did you measure a memory leak?

>
> Signed-off-by: Dmytro Milinevskyy <niam.niam@gmail.com>
> ---
>  fs/jffs2/erase.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
> index b47679b..c0a5604 100644
> --- a/fs/jffs2/erase.c
> +++ b/fs/jffs2/erase.c
> @@ -74,8 +74,10 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
>        ((struct erase_priv_struct *)instr->priv)->c = c;
>
>        ret = c->mtd->erase(c->mtd, instr);
> -       if (!ret)
> +       if (!ret) {
> +        kfree(instr);
>                return;
> +    }
>
>        bad_offset = instr->fail_addr;
>        kfree(instr);
>

