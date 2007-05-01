Return-Path: <linux-kernel-owner+w=401wt.eu-S1423790AbXEAELZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423790AbXEAELZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423791AbXEAEKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:10:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:22634 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423778AbXEAEJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PG1Up+AsOng8WJgRxqtn3cK+Br6btIThTDZaSUmOamyVMFwS8MBWUajg2n/moMzddWzM5Gr9A1nyjQFZF+NuV1dWLt3fkRAhj4Ofk3UPv3xNcFmkJ/s9gMHnpfulV5RSJt/HPYJb69ATm2hO7jbVBx77J6ylKz0Fasdd71zme3g=
Message-ID: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
Date: Tue, 1 May 2007 00:09:46 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl, hpa@zytor.com
Subject: console font limits
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having problems with a font I just created. It's a rather big one,
intended for a framebuffer console in UTF-8 mode. The strace program
reports that /bin/setfont fails on a KDFONTOP ioctl with EINVAL.
In reading the kernel code, I find this:

vt.c:static int con_font_set(struct vc_data *vc, struct console_font_op *op)
vt.c-{
vt.c-   struct console_font font;
vt.c-   int rc = -EINVAL;
vt.c-   int size;
vt.c-
vt.c-   if (vc->vc_mode != KD_TEXT)
vt.c-           return -EINVAL;
vt.c-   if (!op->data)
vt.c-           return -EINVAL;
vt.c-   if (op->charcount > 512)
vt.c-           return -EINVAL;

Ouch. Why is the old VGA limit being applied to the framebuffer console?
Could this just get removed? I dearly hope we aren't still storing the
framebuffer data as two bytes per character+attribute pair.

I nearly hit the 32-pixel height limit as well, yet another relic from
the VGA hardware. I also nearly hit the 64 KB font size limit.

Currently I'm doing a 15x30 font with 870 glyphs to represent 978
different Unicode code points. This is for a 200 DPI display with
an anti-aliasing filter, so fonts need to be big. I'm considering 15x36
so that I'll have more room for double-accented letters, but clearly
the kernel would block that too.

BTW, the PSF font format documentation seems to suggest that
there is a way to make the kernel handle combining accents:
http://www.win.tue.nl/~aeb/linux/kbd/font-formats-1.html
Does anybody know if that really works? I could sure use that.
