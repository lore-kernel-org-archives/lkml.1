Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZAEVll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZAEVll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZAEVld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:41:33 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:33401 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZAEVlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:41:31 -0500
Date: Mon, 5 Jan 2009 22:41:28 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: dm_attr_{name,uuid}_show buffer overflow? (was: Re: linux-next: Tree
 for January 5)
In-Reply-To: <20090105173517.deeff918.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0901052225400.5451@anakin>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

On m68k, you get http://kisskb.ellerman.id.au/kisskb/buildresult/65466/:

| ERROR: "strlen" [drivers/md/dm-mod.ko] undefined!

which triggered my attention.

drivers/md/dm-sysfs.c:

| static ssize_t dm_attr_name_show(struct mapped_device *md, char *buf)
| {
|         if (dm_copy_name_and_uuid(md, buf, NULL))
|                 return -EIO;
| 
|         strncat(buf, "\n", DM_NAME_LEN);
|         return strnlen(buf, DM_NAME_LEN);
| }

is turned into:

|         .type   dm_attr_name_show, @function
| dm_attr_name_show:
|         move.l %a3,-(%sp)
|         move.l 12(%sp),%a3      | buf, buf
|         clr.l -(%sp)    |
|         move.l %a3,-(%sp)       | buf,
|         move.l 16(%sp),-(%sp)   | md,
|         jbsr dm_copy_name_and_uuid      |
|         lea (12,%sp),%sp        |,
|         tst.l %d0       |
|         jeq .L23        |
|         move.w #-5,%a0  |, D.21217
|         jbra .L25       |
| .L23:
|         move.l %a3,-(%sp)       | buf,
|         jbsr strlen     |
|         addq.l #4,%sp   |,
|         move.w #2560,(%a3,%d0.l)        |,* buf
|         moveq #127,%d0  |, tmp43
|         not.b %d0       | tmp43
|         move.l %a3,%a0  | buf, sc.399
| #APP
| 
| 1:     subq.l  #1,%d0   | count
|        jcs     2f
|        tst.b   (%a0)+   | sc.399
|        jne     1b
|        subq.l  #1,%a0   | sc.399
| 2:
| #NO_APP
|         sub.l %a3,%a0   | buf, D.21217
| .L25:
|         move.l %a0,%d0  | D.21217, <result>
|         move.l (%sp)+,%a3
|         rts
|         .size   dm_attr_name_show, .-dm_attr_name_show

So gcc (version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21) in my case) is
smart and turns the strncat into a strlen() (without obeying our override of
strlen() in <{linux,asm}/string.h>) followed by an _unconditional_ store.

And I think that's the real bug: `strncat(buf, "\n", DM_NAME_LEN);' copies at
most DM_NAME_LEN characters from source "\n", which has the known size 2,
which is always smaller than DM_NAME_LEN. Hence the check is optimized away,
and the "\n" is _always_ appended!

Probably the intention was to limit the string in _buf_ (not the source string
"\n") to DM_NAME_LEN? If yes, this may cause a buffer overflow.

The same bug is present in dm_attr_uuid_show().

Fixing it will probably get rid of the undefined reference, too (I hope :-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
