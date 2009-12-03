Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZLCI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZLCI43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZLCI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:56:29 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:37933 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZLCI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OFBNtCOJ5rZxunQDwoTcReAdbaHqX9jfZonkeNPLj6f0PIex1fmFAlqsKNRydBnwWe
         ndL6m+P3v6q7qlrFiGr+BEnTeKAjBgaBRHk3mRnDK40ZCD6lMOjCfnfYh8lY85y9BRTK
         7A4r2SuwMcnsQUwq075LITH7QQnbXoMrl9oB4=
Date: Thu, 3 Dec 2009 00:56:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] DMI: allow omitting ident strings in DMI tables
Message-ID: <20091203085629.GN9121@core.coreip.homeip.net>
References: <20091203031240.GB9121@core.coreip.homeip.net> <20091203093009.059197a6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203093009.059197a6@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Thu, Dec 03, 2009 at 09:30:09AM +0100, Jean Delvare wrote:
> Hi Dmitry,
> 
> On Wed, 2 Dec 2009 19:12:40 -0800, Dmitry Torokhov wrote:
> > The purpose of dmi->ident is twofold - it may be used by DMI callback
> > functions when composing log messages; it is also used to determine
> > end of DMI table in dmi_check_system() and dmi_first_match(). However,
> > in case when callbacks are not interested in using ident at all it just
> > wastes memory. Let's consider entries with empty ident but initialized
> > first match slot as a valid entry and not as end-of-table marker.
> 
> You are free to use an empty string ("") as the ident. This will use
> 1 byte of memory, I'm sure you can afford it. struct dmi_system_id is
> 332 bytes large on 32-bit systems (344 on 64-bit systems), and we use
> such an empty structure as the list terminator. So I really doubt we
> care about the extra few bytes used by the ident strings.
> 

Almost all instances of DMI tables are maked __initdata. Because we use
arrays instead of pointers for match slots they all get discarded once
kernel is up and running so the cost of the terminator is not that bit.

The indent is different - since it is a pointer to string the string
ends up in constant data section and (as far as I understand) is kept
even though we discarded the pointer to it. We could work around it by
decaring 'char blah_ident[] = "This is blah";' and setting up pointer
but this is ugly. Setting ident to "" ugly as well (IMHO and admittedly
not as ugly as screwing with an array) but the most clean and concise
way (especially for large tables) is omit ident altogether.

> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> > 
> > CCed a few random people since they touched dmi code in the last few
> > months...
> > 
> >  drivers/firmware/dmi_scan.c |   13 +++++++++++--
> >  1 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > index 938100f..9116aa7 100644
> > --- a/drivers/firmware/dmi_scan.c
> > +++ b/drivers/firmware/dmi_scan.c
> > @@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
> >  }
> >  
> >  /**
> > + *	dmi_is_end_of_table - check for end-of-table marker
> > + *	@dmi: pointer to the dmi_system_id structure to check
> > + */
> > +static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
> > +{
> > +	return dmi->ident == NULL && dmi->matches[0].slot == DMI_NONE;
> 
> If you really want to allow for dmi->ident == NULL, then I guess you can
> _only_ check for dmi->matches[0].slot == DMI_NONE. I can't think of any
> legitimate use of DMI_NONE for a used slot.

Current behavior is that entry with ident and empty match table matches
everything. If we only check on the first slot then it will not match. I
wanted to preserve the current behavior.

> The only thing you have to
> do then is to ensure that DMI_NONE = 0 in <linux/mod_devicetable.h>
> (I'm not sure if any C standard guarantees that enums starts at 0.)

I believe it does. Otherwise we'd be comparing with 0 strings all the
time.

> 
> There's a possible optimization in dmi_matches(), BTW: DMI_NONE should
> break, not continue.

I agree.

-- 
Dmitry
