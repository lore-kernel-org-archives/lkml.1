Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXCMSty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXCMSty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbXCMSty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:49:54 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:59589 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbXCMStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:49:53 -0400
Message-ID: <45F6F24E.4080600@grupopie.com>
Date: Tue, 13 Mar 2007 18:49:50 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms race vs module unload
References: <20070313181815.GA5580@martell.zuzino.mipt.ru>
In-Reply-To: <20070313181815.GA5580@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> [...]
> What happens is that module_get_kallsym() drops module_mutex,
> returns "struct module *", module unloaded, "struct module *"
> used.

The only use for the "struct module *" is to display the name of the 
module.

This can be solved by adding a "char mod_name[MODULE_NAME_LEN];" field 
to "kallsym_iter" and copy the name of the module over, while still 
holding module_mutex. It would be slightly slower, but safer.

We can even change the function's interface, so that it doesn't return a 
"struct module *" at all, since AFAICS kallsyms is the only user of that 
function.

It will still produce strange artifacts, though. If the iterator is 
already past the removed module symbols, it will skip as many symbols as 
the module symbol count, failing to show some symbols from unrelated 
modules. It won't oops, though.

I'll try to cook up a patch, if no one objects to this approach,

-- 
Paulo Marques - www.grupopie.com

"There cannot be a crisis today; my schedule is already full."
