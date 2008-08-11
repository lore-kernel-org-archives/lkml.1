Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYHKOOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYHKOOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYHKOOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:14:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYHKOOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:14:35 -0400
Date: Mon, 11 Aug 2008 10:12:34 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080811141231.GA6103@redhat.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080809010741.GA26036@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809010741.GA26036@kroah.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 06:07:41PM -0700, Greg KH wrote:
> > Few notes...there is still one control file: <debugfs>/dynamic_printk/modules
> > We can split this up now or later, but I kind of like being able to see all
> > the controls in one file. Also, i've used a djb2 hash function in the code,
> > which i'm not sure is under the correct license/copyright, so i just wanted
> > to point that out as well. see: scripts/basic/hash.c. If its an issue, i can
> > find another hash function. 
> 
> Why use that hash function?  Actually, it looks like you are using 2
> different ones, right?  Why?
> 

The hash functions are used to map between the calling module name, 
KBUILD_MODNAME, and whether or not debugging is enabled. In the 'fast' case a
bitmask is used to represent each hash bucket. One bit per bucket. Thus, if
all the modules in a bucket are disabled the bitmask is simply 0. Two
hashes are used in order to reduce the probability of collisions, used in this
way it is similar to a bloom filter. The code that implements this is:

#define __dynamic_dbg_enabled(module, type, value, level, hash)  ({          \
        int ret = 0;                                                         \
        if (unlikely((dynamic_printk_enabled & (1LL << DEBUG_HASH)) &&       \
                        (dynamic_printk_enabled2 & (1LL << DEBUG_HASH2))))   \
                        ret = __dynamic_dbg_enabled_helper(module, type,     \
                                                                value, hash);\
        ret; })

where DEBUG_HASH and DEBUG_HASH2 are computed at compile time. Thus, in the
'fast' case where debugging is off, we have two extra intructions, a test and
a jmp. Further, if we enable debugging for a single module, we will at most
do two 'tests' and a jump for disabled modules. If the module is enabled, we
would call through to __dynamic_dbg_enabled_helper(), which verifies whether
or not debugging is enabled for the module. I believe if we are then calling
'printk()' the cost of this function call is 'in the noise'. Thus, i've tried
to optimize the disabled case.

> > --- /dev/null
> > +++ b/include/linux/dynamic_printk.h
> > @@ -0,0 +1,94 @@
> > +#ifndef _DYNAMIC_PRINTK_H
> > +#define _DYNAMIC_PRINTK_H
> > +
> > +#ifdef __KERNEL__
> 
> Shouldn't be needed.
> 

ok

> > +#include <linux/string.h>
> > +#include <linux/hash.h>
> > +
> > +#define DYNAMIC_DEBUG_HASH_BITS 6
> > +#define DEBUG_HASH_TABLE_SIZE (1 << DYNAMIC_DEBUG_HASH_BITS)
> > +
> > +#define TYPE_BOOLEAN 1
> 
> What's this for?
> 

This is really in anticipation of more 'involved' dynamic debugging. That is,
'TYPE_BOOLEAN', just means the debugging is either off/on. The other types
are 'TYPE_FLAG', where you can control debugging for a module via a bitmask,
or 'TYPE_LEVEL', where you control the debugging for a module via a level 
control like printk levels. These different types were implemented in the
orginal patchset.


> > +#define DYNAMIC_ENABLED_ALL 0
> > +#define DYNAMIC_ENABLED_NONE 1
> > +#define DYNAMIC_ENABLED_SOME 2
> > +
> > +extern int dynamic_enabled;
> > +extern long long dynamic_printk_enabled;
> > +extern long long dynamic_printk_enabled2;
> 
> What's up with the "2" versions?
> 

"2" here is the second bitmask as explained previously.

thanks,

-Jason
