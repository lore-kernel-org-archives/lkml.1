Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXCNMRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXCNMRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161201AbXCNMRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:17:30 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:40398 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1161200AbXCNMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:17:29 -0400
Message-ID: <45F7E7D6.1000904@grupopie.com>
Date: Wed, 14 Mar 2007 12:17:26 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms race vs module unload
References: <20070313181815.GA5580@martell.zuzino.mipt.ru> <45F6F24E.4080600@grupopie.com> <20070313230753.GB5623@martell.zuzino.mipt.ru>
In-Reply-To: <20070313230753.GB5623@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Tue, Mar 13, 2007 at 06:49:50PM +0000, Paulo Marques wrote:
>> Alexey Dobriyan wrote:
>>> [...]
>>> What happens is that module_get_kallsym() drops module_mutex,
>>> returns "struct module *", module unloaded, "struct module *"
>>> used.
>> The only use for the "struct module *" is to display the name of the
>> module.
> 
> Ehh?
> 
>> This can be solved by adding a "char mod_name[MODULE_NAME_LEN];" field
>> to "kallsym_iter" and copy the name of the module over, while still
>> holding module_mutex. It would be slightly slower, but safer.
> 
> 	iter->owner = module_get_kallsym(iter->pos - kallsyms_num_syms,
> 					 &iter->value, &iter->type,
> 					 iter->name, sizeof(iter->name));
> 	if (iter->owner == NULL)
> 		return 0;
> 
> 	/* Label it "global" if it is exported, "local" if not exported. */
> 	iter->type = is_exported(iter->name, iter->owner)
> 					     ^^^^^^^^^^^

Yes, there is this "is_exported" call, but his can be moved completely 
into "module_get_kallsym" and have the "type" returned be already upper 
/ lower case.

That, together with filling the module name "module_get_kallsym()" would 
make the returned "struct module *" unneeded.

Since kallsyms is the only caller of that function, we can change its 
interface to not return a "struct module *" at all, and return just an 
integer that means "symbol found" or "no more symbols".

I'm still volunteering to do that patch, but you seem more active than 
me at the moment...

-- 
Paulo Marques
Software Development Department - Grupo PIE, S.A.
Phone: +351 252 290600, Fax: +351 252 290601
Web: www.grupopie.com
