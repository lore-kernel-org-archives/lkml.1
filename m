Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbYD3UZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbYD3UZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYD3UZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:25:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:44481 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbYD3UZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bnVnaVTMd2e/oIaNVt6Svys4Z/n7TTCmu/vqmuqa9v8Ov/nojtFEnMaUoaxkh39s+TuInc+DU6W406B5nAOUmjCSUQaS2NwLZJU4YWFcoEinhGcZNvD/DdMl4cMarvRf0gMp8qUa0eF72sTOAbTMtcnpKbwOs/EpZSEA4TyXGmU=
Date: Thu, 1 May 2008 01:21:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Denis V. Lunev" <den@openvz.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch, -git] isdn: hysdn_procconf.c build fix
Message-ID: <20080430212102.GA17266@martell.zuzino.mipt.ru>
References: <1207653508.7171.18.camel@iris.sw.ru> <1207653576-12640-25-git-send-email-den@openvz.org> <20080430175740.GA26612@elte.hu> <20080430111052.9c0c8974.akpm@linux-foundation.org> <20080430183051.GA3008@elte.hu> <20080430114731.7e71f3d2.akpm@linux-foundation.org> <1209582185.4310.1.camel@iris.sw.ru> <20080430121452.f7735eea.akpm@linux-foundation.org> <1209583487.24729.85.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209583487.24729.85.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 12:24:47PM -0700, Harvey Harrison wrote:
> On Wed, 2008-04-30 at 12:14 -0700, Andrew Morton wrote:
> > On Wed, 30 Apr 2008 23:03:05 +0400
> > "Denis V. Lunev" <den@openvz.org> wrote:
> > > > 
> > > > allmodconfig is for one thing and one thing only: compilation coverage
> > > > testing.  If there is anything which is not compiled after `make
> > > > allmodconfig' then that's a bug.
> > > > 
> > > > But how to fix it?  Perhaps we need to add a CONFIG_ALLFOOCONFIG which can
> > > > be tested at the appropriate places.
> > > 
> > > I think that the same should be applied to allyesconfig
> > 
> > That's what ALLFOOCONFIG refers to ;)
> > 
> > There _might_ be a need to discriminate between allyesconfig and
> > allmodconfig, but usually not, I expect.
> > 
> > Perhaps we should implement CONFIG_ALLYESCONFIG, CONFIG_ALLMODCONFIG and
> > CONFIG_ALLFOOCONFIG, where
> > 
> > 	ALLFOOCONFIG = ALLYESCONFIG || ALLMODCONFIG
> > 	
> > (where FOO is renamed to something sensible, but what?)
> 
> ALLBUILDCONFIG

ALLCRAPCONFIG

Driver wasn't built because of BROKEN_ON_SMP, so both allyes and allmod
wouldn't help.

If one repeats Ingo's trick on e.g. driver that is arch specific from other
arch, compile will die horrible death due to different includes, so the
trick is not universal.

Things that help:
* UP allmodconfig builds

	echo 'CONFIG_SMP=n' >1
	make KCONFIG_ALLCONFIG=1 allmodconfig

  alpha-smp-n-debug-n.log:
    CC [M]  drivers/isdn/hysdn/hysdn_procconf.o
  drivers/isdn/hysdn/hysdn_procconf.c: In function 'hysdn_procconf_init':
  drivers/isdn/hysdn/hysdn_procconf.c:408: error: too few arguments to function 'proc_create'

* double-checking logs that driver indeed was rebuilt
* attention, attention, attention -- code can hide in huge ifdef section
  and config option won't be turned on, so driver compiles, but not
  relevant part.

