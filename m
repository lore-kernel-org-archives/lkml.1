Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYEAGMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYEAGMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYEAGML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:12:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46805 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYEAGMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:12:09 -0400
Date: Thu, 1 May 2008 08:12:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Andres Salomon <dilinger@queued.net>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080501061240.GA13544@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org> <200805010640.33973.zippel@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805010640.33973.zippel@linux-m68k.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 06:40:29AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Tuesday 29. April 2008, Sam Ravnborg wrote:
> 
> > Recently there has been request for a number of new
> > kconfig related targets.
> >
> > In general it boils down to the following:
> >
> > We need to be flexible in what configuration
> > we start out from and how we apply it.
> >
> > We need to be able to apply it in following ways:
> > 1) automated - select defaults for all new symbols
> >    => It is used for "make defconfig, make *_defconfig" today
> >
> > 2) interactive - asking user for all new symbols
> >    and error out if stdin is redirected
> >
> > 3) list unknown - list all new symbols and do not
> >    create a new config
> 
> A general comment about the intendend design:
> conf.c is primarily meant as interactive tool. defconfig isn't exactly 
> interactive, but is included for historical reasons as it produces the same 
> output.
> The patch I've seen for the last point put it into conf.c, which is the wrong 
> place for it. For this sort of thing we should create a small query tool, 
> which then can export all sorts of information.

Hi Roman.
This is work in progress...
I have created a new frontend: aconf.c that is a trimmed down version
of conf.c. aconf.c are intended to take care of all the automated configurations
such as: all*config, randconfig and the automated defconfig

In this way we have conf.c for all the interactive targets and aconf for
all the automated targets.

This is not exactly what you suggest but I thik a step in the right direction.

Comments?

	Sam

/*
 * Copyright (C) 2002 Roman Zippel <zippel@linux-m68k.org>
 * Copyright (C) 2008 Sam Ravnborg <sam@ravnborg.org>
 * Released under the terms of the GNU GPL v2.0.
 */

/*
 * Generate the automated configs
 */

#include <locale.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/stat.h>

#define LKC_DIRECT_LINK
#include "lkc.h"

static void check_conf(struct menu *menu);
static void conf(struct menu *menu);

enum {
	set_default,
	set_yes,
	set_mod,
	set_no,
	set_random
} input_mode;

static char *defconfig_file;

static int conf_cnt;
static struct menu *rootEntry;

/* Set strig value - it this a nop as it looks like? */
static void conf_string(struct menu *menu)
{
	struct symbol *sym = menu->sym;
	const char *def;


	if (!sym_is_changable(sym))
		return;

	if (sym_has_value(sym) && (input_mode != set_default))
		return;

	def = sym_get_string_value(sym);
	if (def)
		sym_set_string_value(sym, def);
}

static void conf_sym(struct menu *menu)
{
	struct symbol *sym = menu->sym;
	int type;
	tristate val;

	if (!sym_is_changable(sym))
		return;

	if (sym_has_value(sym) && (input_mode != set_default))
		return;

	type = sym_get_type(sym);
	switch (input_mode) {
	case set_yes:
		if (sym_tristate_within_range(sym, yes)) {
			sym_set_tristate_value(sym, yes);
			break;
		}
	/* fallthrough */
	case set_mod:
		if (type == S_TRISTATE) {
			if (sym_tristate_within_range(sym, mod)) {
				sym_set_tristate_value(sym, mod);
				break;
			}
		} else if (sym_tristate_within_range(sym, yes)) {
			sym_set_tristate_value(sym, yes);
			break;
		}
	/* fallthrough */
	case set_no:
		if (sym_tristate_within_range(sym, no)) {
			sym_set_tristate_value(sym, no);
			break;
		}
	/* fallthrough */
	case set_random:
		 do {
			val = (tristate)(rand() % 3);
		} while (!sym_tristate_within_range(sym, val));
		switch (val) {
		case no:  sym_set_tristate_value(sym, no); break;
		case mod: sym_set_tristate_value(sym, mod); break;
		case yes: sym_set_tristate_value(sym, yes); break;
		}
		break;
	/* silence gcc warning */
	case set_default:
		sym_set_tristate_value(sym, sym_get_tristate_value(sym));
		break;
	}
}

static void conf_choice(struct menu *menu)
{
	struct symbol *sym, *def_sym;
	struct menu *child;
	int type;
	bool is_new;
	int cnt, def;

	sym = menu->sym;
	type = sym_get_type(sym);
	is_new = !sym_has_value(sym);
	if (sym_is_changable(sym)) {
		conf_sym(menu);
		sym_calc_value(sym);
	}
	if (sym_get_tristate_value(sym) != yes)
		return;
	def_sym = sym_get_choice_value(sym);
	cnt = def = 0;
	for (child = menu->list; child; child = child->next) {
		if (!child->sym || !menu_is_visible(child))
			continue;
		cnt++;
		if (child->sym == def_sym)
			def = cnt;
	}
	if (cnt == 1)
		goto conf_childs;

	switch (input_mode) {
	case set_random:
		if (is_new)
			def = (rand() % cnt) + 1;
	/* fallthrough */
	case set_default:
	case set_yes:
	case set_mod:
	case set_no:
		cnt = def;
		break;
	}

conf_childs:
	for (child = menu->list; child; child = child->next) {
		if (!child->sym || !menu_is_visible(child))
			continue;
		if (!--cnt)
			break;
	}
	sym_set_choice_value(sym, child->sym);
	for (child = child->list; child; child = child->next)
		conf(child);
}


static void conf(struct menu *menu)
{
	struct symbol *sym;
	struct property *prop;
	struct menu *child;

	if (!menu_is_visible(menu))
		return;

	sym = menu->sym;
	//if (sym)
	//	printf("sym:%s\n", sym->name);
	prop = menu->prompt;
	if (prop && prop->type == P_MENU) {
		if (menu != rootEntry) {
			check_conf(menu);
			return;
		}
	}

	if (!sym)
		goto conf_childs;

	if (sym_is_choice(sym)) {
		conf_choice(menu);
		if (sym->curr.tri != mod)
			return;
		goto conf_childs;
	}

	switch (sym->type) {
	case S_INT:
	case S_HEX:
	case S_STRING:
		conf_string(menu);
		break;
	default:
		conf_sym(menu);
		break;
	}

conf_childs:
	for (child = menu->list; child; child = child->next)
		conf(child);
}

static void check_conf(struct menu *menu)
{
	struct symbol *sym;
	struct menu *child;

	if (!menu_is_visible(menu))
		return;

	sym = menu->sym;
	if (sym && !sym_has_value(sym)) {
		if (sym_is_changable(sym) ||
		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
			conf_cnt++;
			rootEntry = menu_get_parent_menu(menu);
			conf(rootEntry);
		}
	}

	for (child = menu->list; child; child = child->next)
		check_conf(child);
}

int main(int ac, char **av)
{
	int opt;
	const char *name;
	struct stat tmpstat;

	setlocale(LC_ALL, "");
	bindtextdomain(PACKAGE, LOCALEDIR);
	textdomain(PACKAGE);

	while ((opt = getopt(ac, av, "dD:nmyrh")) != -1) {
		switch (opt) {
		case 'd':
			input_mode = set_default;
			break;
		case 'D':
			input_mode = set_default;
			defconfig_file = optarg;
			break;
		case 'n':
			input_mode = set_no;
			break;
		case 'm':
			input_mode = set_mod;
			break;
		case 'y':
			input_mode = set_yes;
			break;
		case 'r':
			input_mode = set_random;
			srand(time(NULL));
			break;
		case 'h':
			printf(_("See README for usage info\n"));
			exit(0);
			break;
		default:
			fprintf(stderr, _("See README for usage info\n"));
			exit(1);
		}
	}
	if (ac == optind) {
		printf(_("%s: Kconfig file missing\n"), av[0]);
		exit(1);
	}
	name = av[optind];
	conf_parse(name);
	//zconfdump(stdout);
	switch (input_mode) {
	case set_default:
		if (!defconfig_file)
			defconfig_file = conf_get_default_confname();
		if (conf_read(defconfig_file)) {
			printf(_("***\n"
				"*** Can't find default configuration \"%s\"!\n"
				"***\n"), defconfig_file);
			exit(1);
		}
		break;
	case set_no:
	case set_mod:
	case set_yes:
	case set_random:
		name = getenv("KCONFIG_ALLCONFIG");
		if (name && !stat(name, &tmpstat)) {
			conf_read_simple(name, S_DEF_USER);
			break;
		}
		switch (input_mode) {
		case set_no:	 name = "allno.config"; break;
		case set_mod:	 name = "allmod.config"; break;
		case set_yes:	 name = "allyes.config"; break;
		case set_random: name = "allrandom.config"; break;
		default: break;
		}
		if (!stat(name, &tmpstat))
			conf_read_simple(name, S_DEF_USER);
		else if (!stat("all.config", &tmpstat))
			conf_read_simple("all.config", S_DEF_USER);
		break;
	default:
		break;
	}

	do {
		conf_cnt = 0;
		check_conf(&rootmenu);
	} while (conf_cnt);
	if (conf_write(NULL)) {
		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
		return 1;
	}

	if (conf_write_autoconf()) {
		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
		return 1;
	}

	return 0;
}
