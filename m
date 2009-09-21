Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbZIULAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbZIULAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZIULAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:00:08 -0400
Received: from ozlabs.org ([203.10.76.45]:32905 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZIULAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:00:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix error handling in load_module()
Date: Mon, 21 Sep 2009 20:30:03 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
References: <20090907141558.GA5456@linux.vnet.ibm.com> <20090910141430.a00dcc94.akpm@linux-foundation.org>
In-Reply-To: <20090910141430.a00dcc94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909212030.03648.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 06:44:30 am Andrew Morton wrote:
> On Mon, 7 Sep 2009 19:45:58 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > Once the percpu_modalloc fails, percpu_modfree(mod->refptr) is called on a NULL pointer.
> > We try calling it on a NULL pointer. The following patch fixes the problem by introducing 
> > a check for mod->refptr before calling percpu_modfree.
> 
> Where did it crash and why did it crash?  That trace is pretty unclear.
> 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 2d53718..7f89258 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2379,7 +2379,8 @@ static noinline struct module *load_module(void __user *umod,
> >  	module_unload_free(mod);
> >  #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> >   free_init:
> > -	percpu_modfree(mod->refptr);
> > +	if (mod->refptr)
> > +		percpu_modfree(mod->refptr);
> >  #endif
> >  	module_free(mod, mod->module_init);
> >   free_core:
> 
> My reverse engineering of the secret, undocumented percpu_modfree()
> indicates that its mad inventor intended that percpu_modfree(NULL) be a
> valid thing to do.

Yes, percpu_modfree() should handle NULL.  If it doesn't, that's the bug.

Confused,
Rusty.
