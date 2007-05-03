Return-Path: <linux-kernel-owner+w=401wt.eu-S376230AbXECRLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376230AbXECRLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376231AbXECRLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:11:41 -0400
Received: from hera.cwi.nl ([192.16.191.8]:45675 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376230AbXECRLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:11:40 -0400
Date: Thu, 3 May 2007 19:11:36 +0200
From: Andries Brouwer <Andries.Brouwer@cwi.nl>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andries.Brouwer@cwi.nl,
       hpa@zytor.com
Subject: Re: console font limits
Message-ID: <20070503171136.GA16023@apps.cwi.nl>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:09:46AM -0400, Albert Cahalan wrote:
> I'm having problems with a font I just created. It's a rather big one,
> intended for a framebuffer console in UTF-8 mode. The strace program
> reports that /bin/setfont fails on a KDFONTOP ioctl with EINVAL.
> In reading the kernel code, I find this:
> 
> vt.c:static int con_font_set(struct vc_data *vc, struct console_font_op *op)
> vt.c-{
> vt.c-   struct console_font font;
> vt.c-   int rc = -EINVAL;
> vt.c-   int size;
> vt.c-
> vt.c-   if (vc->vc_mode != KD_TEXT)
> vt.c-           return -EINVAL;
> vt.c-   if (!op->data)
> vt.c-           return -EINVAL;
> vt.c-   if (op->charcount > 512)
> vt.c-           return -EINVAL;
> 
> Ouch. Why is the old VGA limit being applied to the framebuffer console?

This is common code, for both framebuffer and vga.
If you want you can push this check into the individual foo->con_font_set
routines. Have some check here that the total size is not ridiculous.

(There is a loop
	for (i = 0; i < op->charcount; i++)
that must have some bounded length. Easiest is to test against the total
font size some lines later:
	size = (op->width+7)/8 * 32 * op->charcount;
        if (size > max_font_size)
                return -ENOSPC;
E.g., move this up so that it becomes
	if (op->width <= 0 || op->width > 32)
		return -EINVAL;
	if (op->charcount > max_font_size / 32 / ((op->width+7)/8))
		return -ENOSPC;
.)

> I nearly hit the 32-pixel height limit as well, yet another relic from
> the VGA hardware. I also nearly hit the 64 KB font size limit.

Of course you can make everything more general if you want to and need to.
Some of this code was written when average machines had 4 or 8 MB of memory.
On the other hand, for VGA some of the limits are hardware restrictions.

> Currently I'm doing a 15x30 font with 870 glyphs to represent 978
> different Unicode code points. This is for a 200 DPI display with
> an anti-aliasing filter, so fonts need to be big. I'm considering 15x36
> so that I'll have more room for double-accented letters, but clearly
> the kernel would block that too.

In case you generalize stuff in such a way that also the kbd package
needs an update, write.

> BTW, the PSF font format documentation seems to suggest that
> there is a way to make the kernel handle combining accents:
> http://www.win.tue.nl/~aeb/linux/kbd/font-formats-1.html
> Does anybody know if that really works? I could sure use that.

Well, the PSF font format documentation shows that there is a way
to document in a font that some font position represents a
sequence of Unicode values. Whether the kernel is able to
use such information depends on the kernel version - maybe vanilla
kernels cannot.

[Very long ago I wrote Yiddish songs on the console, German on the left,
Yiddish on the right, and made a bidirectional console for this purpose.
Long ago I wrote Tibetan on the console and added enough input- and
output stuff to make that work. Only a small part of this has ended up
in the vanilla kernel. Adding features to the console is not a popular idea.]

Get the kbd package and read kdmapop.c for the docs on the kbd ioctls.
Tell me if these docs are outdated. I read

/*
 * Linux pre-0.96 defined GIO_SCRNMAP, PIO_SCRNMAP:
        typedef char scrnmap_t;
        #define E_TABSZ         256
        #define GIO_SCRNMAP     0x4B40
        #define PIO_SCRNMAP     0x4B41
 * and Linux 0.99.14y first implemented them.
 * Usage:
        scrnmap_t map[E_TABSZ];
        ioctl(fd,GIO_SCRNMAP,map);
        ioctl(fd,PIO_SCRNMAP,map);
 * to read or write the kernel translation table that is
 * applied to user application output before displaying.
 *
 * Before 1.3.1, the character set was completely undetermined,
 * and if the font was in an order different from the character
 * set in use, the user screen map was used to map application
 * codes to font indices. (To be more precise: there were four
 * translation tables, and this ioctl would get/set the fourth
 * table, while the other three tables are built-in and constant.)
 */

/*
 * Linux 1.3.1 introduces GIO_UNISCRNMAP, PIO_UNISCRNMAP:
        #define GIO_UNISCRNMAP  0x4B69
        #define PIO_UNISCRNMAP  0x4B6A
 * Usage:
        unsigned short umap[E_TABSZ];
        ioctl(fd,GIO_UNISCRNMAP,umap);
        ioctl(fd,PIO_UNISCRNMAP,umap);
 * to read or write the kernel translation table that is
 * applied to user application output before displaying.
 * (When the console is not in utf8 mode.)
 *
 * The idea is that the umap values are 16-bit unicode (ucs2)
 * values, and that the fonts will have an index giving the
 * unicode value for each glyph, so that the kernel can match up
 * application codes to font positions.
        #define UNI_DIRECT_BASE 0xF000
        #define UNI_DIRECT_MASK 0x01FF
 * For compatibility, and for fonts without table, the unicode
 * values 0xF000+n, 0 <= n <= 0x01FF, acts as direct font indices.
 * In the new scheme, the old PIO_SCRNMAP fills the kernel umap
 * table with such direct-to-font values.
 */

/*
 * Linux 1.1.63 introduces GIO_UNIMAP, PIO_UNIMAP, PIO_UNIMAPCLR:
        #define GIO_UNIMAP     0x4B66
        #define PIO_UNIMAP     0x4B67
        #define PIO_UNIMAPCLR  0x4B68
 * And Linux 1.1.92 implements them.
 * Usage:
        struct unimapinit {
                unsigned short advised_hashsize;
                unsigned short advised_hashstep;
                unsigned short advised_hashlevel;
        } ui;
        ioctl(fd, PIO_UNIMAPCLR, &ui);
 * to clear the unimap table and advise about the kind of
 * hash setup appropriate to what one is going to load
 * (with 0 for "don't care").
        struct unipair {
                unsigned short unicode;
                unsigned short fontpos;
        };
        struct unimapdesc {
                unsigned short entry_ct;
                struct unipair *entries;
        } ud;
        ioctl(fd, PIO_UNIMAP, &ud);
        ioctl(fd, GIO_UNIMAP, &ud);
 * to add the indicated pairs to the kernel unimap table
 * or to read the kernel unimap table, where in the latter case
 * ud.entry_ct indicated the room available.
 *
 * In Linux 1.3.28 the hash table was replaced by a 3-level
 * paged table, so the contents of a struct unimapinit are
 * no longer meaningful.
 *
 * Linux 2.6.1 makes GIO_UNIMAP, PIO_UNIMAP, PIO_UNIMAPCLR per-vt
 * so that fd no longer is random.
 */

Andries

[There is also a file with kbd docs I once wrote, under kernel/people/aeb.
Should probably be moved to Documentation, but it will be outdated today.]
