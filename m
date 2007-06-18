Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbXFRB2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbXFRB2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXFRB2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:28:13 -0400
Received: from gateway-b.fh-trier.de ([143.93.54.182]:53783 "EHLO
	gateway-b.fh-trier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXFRB2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:28:12 -0400
Message-ID: <4675DFA8.6060703@gentoo.org>
Date: Mon, 18 Jun 2007 03:28:08 +0200
From: Alexander Gabert <pappy@gentoo.org>
Organization: Hardened Gentoo Linux
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, hardened@gentoo.org
Subject: Re: AT_ENTROPY1 and AT_ENTROPY2 values for include/linux/auxvec.h
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org>
In-Reply-To: <1182128803.22999.9.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven schrieb:
> On Mon, 2007-06-18 at 01:40 +0200, Alexander Gabert wrote:
>   
>> Hello glibc and kernel maintainers,
>>
>> could you please add two AT_ entries to include/linux/auxvec.h in the 
>> upstream kernel and the respective elf/elf.h definitions in glibc.
>>     
>
>
> while I'm not per se against adding such aux vectors, I think it's a bad
> mistake to make them a config option (and 2 options at that!!)
>   
Well our glibc patch (still under development, here comes a snippet) 
will conditionally check for the auxv and if not "fall back" to normal 
SSP entropy:

-  /* Set up the stack checker's canary.  */
-  uintptr_t stack_chk_guard = _dl_setup_stack_chk_guard ();
+  /* Set up the stack checker's canary, optional kernel entropy  */
+  uintptr_t stack_chk_guard;
+
+  if (GLRO(dl_entropy) != 0) {
+    stack_chk_guard = GLRO(dl_entropy);
+  }
+  else {
+    stack_chk_guard = _dl_setup_stack_chk_guard ();
+  }

Hence the config option for the kernel- it's philosophy at Gentoo to 
make choices available to users how they want their systems to behave, 
even on the expense of added complexity and need to "understand" how 
things work in the first place.

If you add the aux vector behaviour as a default, there would surely be 
a backport of the default behaviour to the more "Gentoo flavoured" 
choice-based system of activating/deactivating it to your own needs.

For your second question, why two config options: entropy is a precious 
resource and many critical apps rely on it.
Until SSPx (http://dev.gentoo.org/~pappy/sspx/ssxp.pdf) is not 
available, we don't want to force users to have two vector entries with 
one containing unneeded (wasted?) entropy.  SSP already works good, so 
if this stuff makes it's way into the kernel or kernel and glibc folks 
tell me which numbers i can use, i can make my patches and add the logic 
to Gentoo kernel sources and glibc.

Sincere thanks,


Alex
