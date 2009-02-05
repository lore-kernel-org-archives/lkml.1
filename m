Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZBEWlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZBEWlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZBEWlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:41:37 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:35622 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZBEWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bJOC36H4OqLo8dgoBangSEHuekTizH3xeZUjsR7VXWTTS4D4CZfh/IWPTzzdxKT8rQ
         hDD392261vQhWWmhZdDvWbCshQOgjzUXU7rixIdvyLfI1yCD8JQ9by2J1cNUtMD3rBJd
         rb8ZydQm7raT5OakGVR85wtxmnVu26571dCqE=
MIME-Version: 1.0
In-Reply-To: <adak584jzw3.fsf@cisco.com>
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
	 <adak584jzw3.fsf@cisco.com>
Date: Thu, 5 Feb 2009 23:41:34 +0100
Message-ID: <56e1b5710902051441g69b2df61n6f6b77a3dc59ac42@mail.gmail.com>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when 
	compiling with -Wformat-security
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 11:13 PM, Roland Dreier <rdreier@cisco.com> wrote:
>
> I would strongly prefer to do this with a little more care.  For example
> the b43/main.c change:
>
>  > --- a/drivers/net/wireless/b43/main.c
>  > +++ b/drivers/net/wireless/b43/main.c
>  > @@ -2005,9 +2005,9 @@ static void b43_print_fw_helptext(struct b43_wl
>  > *wl, bool error)
>  >             "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
>  >             "and download the latest firmware (version 4).\n";
>  >      if (error)
>  > -            b43err(wl, text);
>  > +            b43err(wl, "%s", text);
>  >      else
>  > -            b43warn(wl, text);
>  > +            b43warn(wl, "%s", text);
>  >  }
> would probably be better solved by doing
>
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -1999,11 +1999,11 @@ static void b43_release_firmware(struct b43_wldev *dev)
>
>  static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
>  {
> -       const char *text;
> +       static const char text[] =
> +               "You must go to "
> +               "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> +               "and download the latest firmware (version 4).\n";
>
> -       text = "You must go to "
> -              "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> -              "and download the latest firmware (version 4).\n";
>        if (error)
>                b43err(wl, text);
>        else
>

Fair enough. I'm going to have to break this down into categories of
bugs probably anyway. - "trivial just makes the compiler stops
whining" vs "omg security hole" and the shades in between. From what
I've seen so far the vast majority of this falls into the first
category though ;-)

> and in any case I'm not totally convinced that we want to add the bloat
> for trivial cases like
>
>        char *safe = "foo";
>        printk(safe);
>
> Would be nice to think of a cleverer way to handle that...
>

It would help if GCC was a little smarter in the detection, right now
it gives a lot of false positives even on code like that.
When I was playing around with coccinelle tonight in a (probably
misguided) attempt to automate this I found a few new possible cases
where macro wrappers around printk() seem to make avoiding this check
possible. Haven't looked deeply yet, I'm doing this on my spare time
which I don't have tons of ;-)

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
