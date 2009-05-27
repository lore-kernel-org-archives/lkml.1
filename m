Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZE0CVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZE0CVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZE0CV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:21:29 -0400
Received: from ozlabs.org ([203.10.76.45]:36416 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZE0CV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:21:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amerigo Wang <amwang@redhat.com>, linux-alpha@vger.kernel.org
Subject: Re: [Patch 4/4] module: trim exception table in module_free()
Date: Wed, 27 May 2009 11:51:26 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       mingo@elte.hu, sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain> <20090526083751.5050.60959.sendpatchset@localhost.localdomain>
In-Reply-To: <20090526083751.5050.60959.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271151.28045.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 06:05:39 pm Amerigo Wang wrote:
>  void module_free(struct module *mod, void *module_region)
>  {
>  	vfree(module_region);
> -	/* FIXME: If module_region == mod->init_region, trim exception
> -	   table entries. */
> +	if (module_region == mod->module_init)
> +		mod->num_exentries = 0;
>  }

Hi Amerigo,

   This looks wrong.  The extable covers both init and core exception entries.   
We want to remove the ones in the module_init section.  The good news is that 
it's sorted, so they're either at the start or the end (except sparc 32).

  The bad news is that this is really a generic problem, and deserves a 
generic fix.  That's easy for archs which use the generic sort_extable(), but 
alpha, ia64 and sparc(32) will need to define their own trim_extable().

Thanks!
Rusty.
