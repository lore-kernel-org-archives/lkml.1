Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbXIPAgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbXIPAgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 20:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXIPAga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 20:36:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14335 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXIPAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 20:36:29 -0400
Date: Sat, 15 Sep 2007 17:34:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matej Laitl <strohel@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another
 options and comments
Message-Id: <20070915173413.f952706a.randy.dunlap@oracle.com>
In-Reply-To: <200709152004.11930.strohel@gmail.com>
References: <200709152004.11930.strohel@gmail.com>
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

On Sat, 15 Sep 2007 20:04:10 +0200 Matej Laitl wrote:

> menuconfig currently represents options implied by another option ('select'
> directive in Kconfig) by prefixing them with '---'. Unfortunately the same
> notation is used for comments.
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
> ---
> Changes since v1:
> * introduce sym_get_minimal_value(), so that access to struct symbol is 
> abstracted.
> * change also menuconfig's window header text to reflect the change. I'm still 
> not sure if the wording is optimal.

I don't see any problems with the wording other than I'm not very
strongly in favor of the word "implied".  I don't have a better
word to use other than "selected", but that's just an implementation
detail, not especially user friendly.


> v1 was acked by Randy Dunlap, I'm not sure if it's appropriate to keep 
> Acked-by when patch changes. (teach me please)

Good question.  I think you did it correctly.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

>  scripts/kconfig/lkc_proto.h |    1 +
>  scripts/kconfig/mconf.c     |   21 +++++++++++++--------
>  scripts/kconfig/symbol.c    |    5 +++++
>  3 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
> index 4d09f6d..98642bc 100644
> --- a/scripts/kconfig/lkc_proto.h
> +++ b/scripts/kconfig/lkc_proto.h
> @@ -34,6 +34,7 @@ P(sym_string_valid,bool,(struct symbol *sym, const char 
> *newval));
>  P(sym_string_within_range,bool,(struct symbol *sym, const char *str));
>  P(sym_set_string_value,bool,(struct symbol *sym, const char *newval));
>  P(sym_is_changable,bool,(struct symbol *sym));
> +P(sym_get_minimal_value,tristate,(struct symbol *sym));
>  P(sym_get_choice_prop,struct property *,(struct symbol *sym));
>  P(sym_get_default_prop,struct property *,(struct symbol *sym));
>  P(sym_get_string_value,const char *,(struct symbol *sym));
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index bc5854e..77ab552 100644
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
> @@ -178,9 +182,9 @@ menu_instructions[] = N_(
>  	"Arrow keys navigate the menu.  "
>  	"<Enter> selects submenus --->.  "
>  	"Highlighted letters are hotkeys.  "
> -	"Pressing <Y> includes, <N> excludes, <M> modularizes features.  "
> +	"Pressing <Y> includes (*), <M> modularizes (M), <N> excludes features 
> ( ).  "
>  	"Press <Esc><Esc> to exit, <?> for Help, </> for Search.  "
> -	"Legend: [*] built-in  [ ] excluded  <M> module  < > module capable"),
> +	"Legend: [*] built-in, < > module capable, { } implied, -*- forced."),
>  radiolist_instructions[] = N_(
>  	"Use the arrow keys to navigate this window or "
>  	"press the hotkey of the item you wish to select "
> @@ -560,7 +564,7 @@ static void build_conf(struct menu *menu)
>  				if (sym_is_changable(sym))
>  					item_make("[%c]", val == no ? ' ' : '*');
>  				else
> -					item_make("---");
> +					item_make("-%c-", val == no ? ' ' : '*');
>  				item_set_tag('t');
>  				item_set_data(menu);
>  				break;
> @@ -571,9 +575,10 @@ static void build_conf(struct menu *menu)
>  				default:  ch = ' '; break;
>  				}
>  				if (sym_is_changable(sym))
> -					item_make("<%c>", ch);
> +					item_make((sym_get_minimal_value(sym) == mod) ?
> +					          "{%c}" : "<%c>", ch);
>  				else
> -					item_make("---");
> +					item_make("-%c-", ch);
>  				item_set_tag('t');
>  				item_set_data(menu);
>  				break;
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index c35dcc5..b9832d0 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -643,6 +643,11 @@ bool sym_is_changable(struct symbol *sym)
>  	return sym->visible > sym->rev_dep.tri;
>  }
>  
> +tristate sym_get_minimal_value(struct symbol *sym)
> +{
> +	return sym->rev_dep.tri;
> +}
> +
>  struct symbol *sym_lookup(const char *name, int isconst)
>  {
>  	struct symbol *symbol;
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
