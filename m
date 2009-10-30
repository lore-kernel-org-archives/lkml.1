Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZJ3QFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZJ3QFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932513AbZJ3QFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:05:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:5546 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbZJ3QFW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;8:2>);
	Fri, 30 Oct 2009 12:05:22 -0400
Message-Id: <4AEB1CD4020000780001CD66@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 30 Oct 2009 16:05:24 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tony Luck" <tony.luck@intel.com>, "Tejun Heo" <tj@kernel.org>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "akpm" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] ia64/sn: fix percpu warnings
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
 <20091014151003.0ef42973.randy.dunlap@oracle.com>
 <4AD67C05.2030201@kernel.org>
 <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com>
 <57C9024A16AD2D4C97DC78E552063EA3E345953E@orsmsx505.amr.corp.intel.com>
 <4AE85D28.90809@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA3E34C0108@orsmsx505.amr.corp.intel.com>
 <4AE87344.6030708@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA3E34C018B@orsmsx505.amr.corp.intel.com>
 <57C9024A16AD2D4C97DC78E552063EA3E34C0629@orsmsx505.amr.corp.intel.com>
 <4AE9AA0E.5070104@kernel.org> <4AE9B812.2080307@kernel.org>
In-Reply-To: <4AE9B812.2080307@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 29.10.09 16:43 >>>
>So, the problem is that genksyms can't understand the following.
>
>  __typeof__(int [10]) my_ar;
>  EXPORT_SYMBOL(my_ar);

In fact almost no use of typeof() works with genksyms: Out of

#include <linux/module.h>

extern int x;

#define export(t, n) typeof(t) export_##n; EXPORT_SYMBOL(export_##n)

export(x, a);
export(&x, b);
export(int, c);
export(int*, d);
export(int**, e);
export(int[4], f);
export(typeof(x), g);
export(typeof(&x), h);
export(typeof(x)*, i);

only c and d get a non-zero CRC. This is clearly due to the naive parsing
scripts/genksyms/parse.y does:

type_specifier:
	simple_type_specifier
	| cvar_qualifier
	| TYPEOF_KEYW '(' decl_specifier_seq '*' ')'
	| TYPEOF_KEYW '(' decl_specifier_seq ')'
	...

>Would it be difficult to teach it how to parse it?

For someone familiar with bison/yacc this would seem not very difficult
a job, but as far as I'm concerned this is not something I would feel
comfortable trying to fix. Of course one could go the simplistic route
and just add the array case here, but imo this wouldn't be the right
way to deal with it.

Jan

