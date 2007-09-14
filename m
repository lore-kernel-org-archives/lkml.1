Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbXINRIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbXINRIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXINRHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:07:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39435 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbXINRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:07:54 -0400
Date: Fri, 14 Sep 2007 10:07:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matej Laitl <strohel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: RFC [PATCH] menuconfig: distinguish between selected-by-another
 options and comments (resend)
Message-Id: <20070914100717.8900b29b.randy.dunlap@oracle.com>
In-Reply-To: <200709141316.31841.strohel@gmail.com>
References: <200709141316.31841.strohel@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 13:16:31 +0200 Matej Laitl wrote:

> menuconfig currently represents options implied by another option ('select'
> directive in Kconfig) by prefixing them with '---'. Unfortunately the same
> notation is used for comments. If the implied option is module capable,
> user can still switch between Y and M, all without any feedback until she
> visits option's help. (try saying M to MAC80211 and then toggling CFG80211)
> 
> This patch changes notation of selected-by-another items by introducing 2 new
> representations for implied options:
> {*} or {M} for options selected by another modularized one, thus builtin or
> module capable,
> -*- or -M- for options that cannot be at the moment changed by user.
> 
> The idea is to represent actual capability of the option by braces (dashes)
> around and to always report actual state by * or M inside.
> 
> Signed-off-by: Matěj Laitl <strohel@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> Hi list,
> after being a little annoyed by menuconfig not showing me current state of 
> selected-by-another options (which were looking as comments), I made up a 
> little patch to help users tell these 2 things apart.
> 
> I'd like to hear your comments especially concerning the following:
>  * English grammar and style in new menuconfig README (I'm non-native english 
> speaker)
>  * the way to present the new combinations to user (currently I use "{ }" 
> and "- -", which may be replaced by something more sexy and clear)
>  * the use of "if (sym->rev_dep.tri == mod)". It seems inappropriate to use 
> something from struct symbol directly, as all other uses of it are 
> abstracted.
> 
> TODO is to also change legend text in menuconfig's window header.

Yes, that would be helpful.

> Regards,
>          Matěj Latil
> 
>  scripts/kconfig/mconf.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index bc5854e..5cf99dd 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -35,9 +35,13 @@ static const char mconf_readme[] = N_(
>  "kernel parameters which are not really features, but must be\n"
>  "entered in as decimal or hexadecimal numbers or possibly text.\n"
>  "\n"
> -"Menu items beginning with [*], <M> or [ ] represent features\n"
> -"configured to be built in, modularized or removed respectively.\n"
> -"Pointed brackets <> represent module capable features.\n"
> +"Menu items beginning with following braces represent features that\n"
> +"  [ ] can be built in or removed\n"
> +"  < > can be built in, modularized or removed\n"
> +"  { } can be built in or modularized (selected by other feature)\n"
> +"  - - are selected by other feature,\n"
> +"while *, M or whitespace inside braces means to build in, build as\n"
> +"a module or to exclude the feature respectively.\n"
>  "\n"
>  "To change any of these features, highlight it with the cursor\n"
>  "keys and press <Y> to build it in, <M> to make it a module or\n"
> @@ -560,7 +564,7 @@ static void build_conf(struct menu *menu)
>  				if (sym_is_changable(sym))
>  					item_make("[%c]", val == no ? ' ' : '*');
>  				else
> -					item_make("---");
> +					item_make("-%c-", val == no ? ' ' : '*');
>  				item_set_tag('t');
>  				item_set_data(menu);
>  				break;
> @@ -570,10 +574,13 @@ static void build_conf(struct menu *menu)
>  				case mod: ch = 'M'; break;
>  				default:  ch = ' '; break;
>  				}
> -				if (sym_is_changable(sym))
> -					item_make("<%c>", ch);
> -				else
> -					item_make("---");
> +				if (sym_is_changable(sym)) {
> +					if (sym->rev_dep.tri == mod)
> +						item_make("{%c}", ch);
> +					else
> +						item_make("<%c>", ch);
> +				} else
> +					item_make("-%c-", ch);
>  				item_set_tag('t');
>  				item_set_data(menu);
>  				break;
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
