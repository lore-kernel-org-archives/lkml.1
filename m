Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYKIXHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYKIXHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbYKIXG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:06:58 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:52187 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbYKIXG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:06:57 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2008 18:06:57 EST
Date: Sun, 9 Nov 2008 14:57:59 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
In-Reply-To: <20081109223748.3182e31d@neptune.home>
Message-ID: <Pine.LNX.4.64.0811091439310.22998@t2.domain.actdsltmp>
References: <20081109202537.33ead0a2@neptune.home>
 <20081109113603.d45361ad.akpm@linux-foundation.org> <20081109122515.1deb9ec2@infradead.org>
 <20081109213811.4b85adc6@neptune.home> <20081109125522.b5266352.akpm@linux-foundation.org>
 <20081109223748.3182e31d@neptune.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811584-259581870-1226271479=:22998"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811584-259581870-1226271479=:22998
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 9 Nov 2008, Bruno Pr=C3=A9mont wrote:
> What is preferred, allocating a big block of memory and point various
> variables inside that block or do multiple individual allocations?
>
> e.g.
>  u8 data[CURSOR_SIZE/8]
>  u32 data_bak[CURSOR_SIZE/32]
> =3D>
>  u8 *data =3D kzalloc(...)
>  u32 *data_bak =3D kzalloc(...)
> or
>  u8 *data =3D kzalloc(CURSOR_SIZE/8 + CURSOR_SIZE/32, ...)
>  u32 *data_bak =3D (u32*)(data+CURSOR_SIZE/8);
>
> First option is more readable, second should be more efficient...

I like this method:

foo()
{
 =09/* anonymous struct, you don't need to think of a name */
 =09struct {
 =09=09u8 data[CURSOR_SIZE/8];
 =09=09u32 data_bak[CURSOR_SIZE/32];
 =09} *cursor;

 =09cursor =3D kzalloc(sizeof(*cursor), ...);

 =09/* for remaining code:
 =09 * s/data/cursor->data/
 =09 * s/data_bak/cursor->data_bak/
 =09 */

 =09free(cursor);
}

A number of advantages over multiple allocations:
The alloc code and free code only has to run once.

Likely less memory will be allocated, due to allocation granularity.

Only one pointer is needed to keep track of the allocations instead of two.=
=20
This frees up a pointer's worth of stack space and/or another register for
the compiler to use.

More readable than u32 *data_bak =3D (u32*)(data+CURSOR_SIZE/8) and so on.

If you check for kzalloc failure, you only need code to check once.  And
you can avoid the need for rolling back the first allocation if the second
fails.

The disadvantage is that you can't free just one of the allocations and big
allocations are harder to satisfy than small ones.  When you get up to the
megabyte range, combining allocations into bigger ones becomes a bad idea.
---1463811584-259581870-1226271479=:22998--
