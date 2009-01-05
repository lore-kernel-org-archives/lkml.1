Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZAEWT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZAEWT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZAEWSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:18:47 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:41087 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZAEWSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:18:45 -0500
Date: Mon, 5 Jan 2009 23:18:38 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Jaya Kumar <jayakumar.video@gmail.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Gene Sally <Gene.Sally@timesys.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: strncat() misuse (was: Re: dm_attr_{name,uuid}_show buffer overflow?
 (was: Re: linux-next: Tree for January 5))
In-Reply-To: <Pine.LNX.4.64.0901052225400.5451@anakin>
Message-ID: <Pine.LNX.4.64.0901052259420.5451@anakin>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0901052225400.5451@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Geert Uytterhoeven wrote:
> On Mon, 5 Jan 2009, Stephen Rothwell wrote:
> > Status of my local build tests will be at
> > http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> > advice about cross compilers/configs that work, we are always open to add
> > more builds.
> 
> On m68k, you get http://kisskb.ellerman.id.au/kisskb/buildresult/65466/:
> 
> | ERROR: "strlen" [drivers/md/dm-mod.ko] undefined!
> 
> which triggered my attention.
> 
> drivers/md/dm-sysfs.c:
> 
> | static ssize_t dm_attr_name_show(struct mapped_device *md, char *buf)
> | {
> |         if (dm_copy_name_and_uuid(md, buf, NULL))
> |                 return -EIO;
> | 
> |         strncat(buf, "\n", DM_NAME_LEN);
> |         return strnlen(buf, DM_NAME_LEN);
> | }

    [...]

> And I think that's the real bug: `strncat(buf, "\n", DM_NAME_LEN);' copies at
> most DM_NAME_LEN characters from source "\n", which has the known size 2,
> which is always smaller than DM_NAME_LEN. Hence the check is optimized away,
> and the "\n" is _always_ appended!
> 
> Probably the intention was to limit the string in _buf_ (not the source string
> "\n") to DM_NAME_LEN? If yes, this may cause a buffer overflow.
> 
> The same bug is present in dm_attr_uuid_show().

A quick `git grep strncat' shows a few more misusers of strncat() that may
cause buffer overflows and should be converted to strlcat():

| drivers/media/video/usbvideo/konicawc.c:	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
| drivers/media/video/usbvideo/quickcam_messenger.c:	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
| drivers/media/video/uvc/uvc_driver.c:		strncat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
| usr/gen_init_cpio.c:                       strncat(expanded, getenv(env_var), PATH_MAX);
| usr/gen_init_cpio.c:                       strncat(expanded, end + 1, PATH_MAX);

Let's hope I didn't miss any. Good night! ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
