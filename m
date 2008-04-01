Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYDALdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYDALdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbYDALdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:33:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:2879 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbYDALdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TJjQ0XqkF8tErjpxdzN+ILRoxxP+FLsJH9eHkahQ1Sn3oZrim3tztA/bri6Vga8IkT5sgLLS2jqCtFaw0M/KJ75jrEaRWD6Y4FTvqJEXQcFozKc28izVh8g2wifCINFB7/tiidja9cwD8JlknsftXwNhjvCkOYCK4SsO4a3uZV8=
Message-ID: <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com>
Date: Tue, 1 Apr 2008 14:33:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: Artem.Bityutskiy@nokia.com
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Cc: "Artem Bityutskiy" <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <47F20DEE.7090105@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>
	 <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>
	 <47F1F7A6.5020105@yandex.ru>
	 <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>
	 <47F1FF98.9020809@nokia.com>
	 <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com>
	 <47F20DEE.7090105@nokia.com>
X-Google-Sender-Auth: 670716bc72f7bb6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Pekka Enberg wrote:
> > First and foremost, JFFS2 uses BUG_ON and doesn't invent it's own
> > assert.

On Tue, Apr 1, 2008 at 1:26 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
>  True. But it has checking code which may be enabled or disable.
>  An assert is just a special case of this. You do not say why
>  it hurts. For me it looks like your personal taste.

I don't know how many times I have to say this: you're doing it at the
wrong level! The reason you want to compile them out is because you've
added crap like this all over your code paths:

        ubifs_assert(PageLocked(page));
        ubifs_assert(!PageChecked(page));
        ubifs_assert(!PagePrivate(page));

So instead of arguing about this you really ought to look at what
SLUB, for example, does. It's perfectly okay to have _debugging
checks_ compiled out (stuff like verify_inode and such) but at the
assertion level it makes no sense whatsoever!

Pekka Enberg wrote:
> > But perhaps the problem will go away after you inject some sanity to
> > stuff like this:
> >
> > fs/ubifs/dir.c: dbg_gen("dent '%.*s' to ino %lu (nlink %d) in dir ino %lu",
> > fs/ubifs/dir.c: dbg_gen("dent '%.*s' from ino %lu (nlink %d) in dir ino %lu",
> > fs/ubifs/dir.c: dbg_gen("directory '%.*s', ino %lu in dir ino %lu",
> > dentry->d_name.len,
> > fs/ubifs/dir.c: dbg_gen("dent '%.*s', mode %#x in dir ino %lu",
> > fs/ubifs/dir.c: dbg_gen("dent '%.*s' in dir ino %lu",

On Tue, Apr 1, 2008 at 1:26 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
> This means that when debugging is enabled, you'll have prints like:
> UBIFS DBG (pid 28398): ubifs_create: dent 'file', mode 0x81a4 in dir ino 1
> or
> UBIFS DBG (pid 28398): ubifs_setattr: ino 65, ia_valid 0x70

So what? It's still an ad hoc debugging printout with no particular
meaning whatsoever.

But this discussion is getting nowhere and I have better things to do
than argue about this over and over again. So to reiterate my review
comments on this:

  - Kill your home-grown assert
  - Fix up your logging messages to actually make sense
  - Perhaps introduce a ubifs_error() thingy and convert as much code
to use that
  - Reduce the amount of debug Kconfig options

You can ignore these comments as my personal preferences all you want
in which case I can only wish you good luck with merging this thing
upstream.

                        Pekka
