Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYAQDK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYAQDK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYAQDKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:10:16 -0500
Received: from ozlabs.org ([203.10.76.45]:58086 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYAQDKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:10:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: rmingming <mingming.nk@gmail.com>
Subject: Re: Is try_module_get buggy?
Date: Thu, 17 Jan 2008 14:09:39 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <4cc25cb20801112035x16c69a40rf3103a73b6cda107@mail.gmail.com>
In-Reply-To: <4cc25cb20801112035x16c69a40rf3103a73b6cda107@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171409.39389.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008 15:35:27 rmingming wrote:
> Hi,
>  I have a problem about the try_module_get function, I don't know if
> someone removed the module just AFTER line 372, then what happens? Because
> in this situation, the variable module will be incorrect, and
> module_is_live function will lead to unpredicatable behaviour.
>
> 368 static inline int try_module_get(struct module *module)
> 369 {
> 370         int ret = 1;
> 371
> 372         if (module) {
> 373                 unsigned int cpu = get_cpu();
> 374                 if (likely(module_is_live(module)))
> 375                         local_inc(&module->ref[cpu].count);
> 376                 else
> 377                         ret = 0;
> 378                 put_cpu();
> 379         }
> 380         return ret;
> 381 }

Hi rminming,

try_module_get is designed to ensure that you don't call a function inside a 
module without a reference.  Like any reference function, it cannot handle 
the case where the argument is invalid (or invalidated partway through the 
call).

In this case, the module pointer is usually inside a registered structure.  
The pointer will be valid until the structure is unregistered, which the 
calling code presumably prevents while it's doing a lookup.

Hope that clarifies,
Rusty.
