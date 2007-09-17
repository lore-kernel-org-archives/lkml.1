Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbXIQJK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbXIQJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbXIQIsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:48:25 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:53458
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757369AbXIQIsY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:48:24 -0400
Message-Id: <46EE5BAB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 17 Sep 2007 09:49:15 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tristate choices with mixed tristate and boolean
	values
References: <46E55B7A.76E4.0078.0@novell.com>
 <Pine.LNX.4.64.0709161919350.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0709161919350.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Roman Zippel <zippel@linux-m68k.org> 16.09.07 19:29 >>>
>On Mon, 10 Sep 2007, Jan Beulich wrote:
>
>> --- linux-2.6.23-rc5/scripts/kconfig/menu.c	2007-09-07 16:48:23.000000000 +0200
>> +++ 2.6.23-rc5-tristate-choices/scripts/kconfig/menu.c	2007-09-03 10:29:41.000000000 +0200
>> @@ -235,16 +235,23 @@ void menu_finalize(struct menu *parent)
>>  	sym = parent->sym;
>>  	if (parent->list) {
>>  		if (sym && sym_is_choice(sym)) {
>> -			/* find the first choice value and find out choice type */
>> +			/* find out choice type */
>> +			enum symbol_type type = S_UNKNOWN;
>> +
>>  			for (menu = parent->list; menu; menu = menu->next) {
>> -				if (menu->sym) {
>> -					current_entry = parent;
>> -					menu_set_type(menu->sym->type);
>> -					current_entry = menu;
>> -					menu_set_type(sym->type);
>> -					break;
>> +				if (menu->sym && menu->sym->type != S_UNKNOWN) {
>> +					if (type == S_UNKNOWN)
>> +						type = menu->sym->type;
>> +					if (type != S_BOOLEAN)
>> +						break;
>> +					if (menu->sym->type == S_TRISTATE) {
>> +						type = S_TRISTATE;
>> +						break;
>> +					}
>>  				}
>>  			}
>> +			current_entry = parent;
>> +			menu_set_type(type);
>>  			parentdep = expr_alloc_symbol(sym);
>>  		} else if (parent->prompt)
>>  			parentdep = parent->prompt->visible.expr;
>
>If I understand it correctly this makes possible to override the type of 
>choice symbol, so this loop should only be done if the type is not 
>S_UNKNOWN.

I think it is better to do it this way, as it results in a (correct) warning from
menu_set_type() if the choice type is inconsistently being overridden.

>> @@ -253,7 +260,16 @@ void menu_finalize(struct menu *parent)
>>  
>>  		for (menu = parent->list; menu; menu = menu->next) {
>>  			basedep = expr_transform(menu->dep);
>> -			basedep = expr_alloc_and(expr_copy(parentdep), basedep);
>> +			dep = parentdep;
>> +			if (sym && sym_is_choice(sym) && menu->sym) {
>> +				enum symbol_type type = menu->sym->type;
>> +
>> +				if (type == S_UNKNOWN)
>> +					type = sym->type;
>> +			     if (type != S_TRISTATE)
>> +					dep = expr_alloc_comp(E_EQUAL, sym, &symbol_yes);
>> +			}
>> +			basedep = expr_alloc_and(expr_copy(dep), basedep);
>>  			basedep = expr_eliminate_dups(basedep);
>>  			menu->dep = basedep;
>>  			if (menu->sym)
>
>Hmm, if you want to do it this way, I'd prefer you add a parentdep_bool 
>and simply do:
>
>	dep = (menu->sym && menu->sym->type != S_TRISTATE) ? 
>		parentdep_bool : parentdep;

That would lose the S_UNKNOWN compare (menu->sym->type may not be set
at this point, yet, and would later get defaulted to tristate if the choice is such).

>Otherwise it looks ok.

Jan

