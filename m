Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZDTVLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZDTVLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZDTVLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:11:24 -0400
Received: from solo.fdn.fr ([80.67.169.19]:41904 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZDTVLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:11:23 -0400
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 17:11:23 EDT
Date: Mon, 20 Apr 2009 22:37:48 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: [console] CSI (128+27) vs BIG5 (and possibly others)
Message-ID: <20090420203748.GK5253@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-console@vger.kernel.org
References: <20090418210638.GU21409@const> <20090420112937.78ec67d5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090420112937.78ec67d5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Cox, le Mon 20 Apr 2009 11:29:37 +0100, a écrit :
> On Sat, 18 Apr 2009 23:06:38 +0200
> Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > A chinese user reported that some characters don't show up fine on
> > its console.  This happens to be because character 128+27 is handled
> > specially by the linux Console.  I believe the same issues can happen
> > with other characters sets.  Since linux' terminfo makes applications
> > use \E[ anyway, would it be ok to add an option to disable the 128+27
> > handling?
> 
> I'm reluctant to do so because its extra complication we don't need (at
> least nobody has needed for over fifteen years),

This has been unseen for years because there haven't been chinese blind
users reporting it sofar, there's only one who has showed up relatively
recently on the brltty mailing list.

Let me explain a bit more: sighted chinese users wouldn't use the plain
linux console, as the 512-glyphs limitation doesn't permit to display
kanjis, so they use things like zhcon or just Xorg, which do not use
vt.c's code.  Blind chinese users, however, need their screen reader
to be able to know what's on the screen.  What zhcon displays on the
screen is however not available to the reader as it's just an matrix
internal to zhcon, so these user have to either use Xorg (which is far
from easy), or just use the plain console in 1:1 mapping mode and not
care about the glyphs that get rendered by the video board, while the
screen reader, however, can in that case correctly interpret BIG5.

> it's bound to confuse some other application,

Well, concerning _displaying_ text on the screen, applications don't
care, only the kernel does.  And as I raised, because of the linux
terminfo entry, applications are not supposed to emit CSI through
128+\E, but \E[.  Concerning typing text, yes that might confuse layers
that would interpret 128+\E as being CSI.  These would need the same
kind of option (which could be automatically enabled in BIG5 locales).
The fact that zh_TW BIG5 is in my /etc/locale.gen actually tells me that
for now we really have a bug that chinese people just haven't taken the
time to raise.

> and given almost everyone has already gone UTF-8 it's really debating
> a corner case only relevant to the past anyway.

I would tend to agree, except that in the case at stake (a blind chinese
user), UTF-8 just can not be used, because /dev/vcsa does not provide
the unicode characters that the linux kernel tries to show on the screen
when the font doesn't have enough glyphs to actually show it. That's not
a problem for most languages which can cope with the 512 glyphs limit,
but it's one for chinese.  On the other hand, using the 8bit 1:1 mapping
just works, except the CSI issue.

Yes, the /dev/vcsa interface should ideally be rethought, but it's more
than just defining a new interface, since the kernel itself uses the VGA
representation... I haven't been able to take the time to fix that yet
of course...

Samuel
