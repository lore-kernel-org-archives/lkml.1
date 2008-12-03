Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYLCXrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYLCXrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYLCXr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:47:29 -0500
Received: from ozlabs.org ([203.10.76.45]:44381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbYLCXr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:47:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [RFC 7/8] Call early_param earlier.
Date: Thu, 4 Dec 2008 10:17:23 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812012326.50334.rusty@rustcorp.com.au> <5294.1228311850@redhat.com>
In-Reply-To: <5294.1228311850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812041017.23599.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 00:14:10 David Howells wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> >  	parse_args("Core params", boot_command_line, __start___core_param,
> >  		   __stop___core_param - __start___core_param,
> >  		   unknown_core_ok, true);
> > +	/* All fall through to do_early_param. */
> > +	parse_args("early options", boot_command_line, NULL, 0, do_early_param,
> > +		   true);
>
> Why have two separate lists since they are processed contiguously?

You're right.  I don't think we care about people who have early_param of same
name as core_param; they deserve horrible death anyway.

param: combine core_param and early_param parsing.

David Howells points out that we can now do early_param and core_param
in a single pass of parse_args.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
---
 init/main.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -548,12 +548,10 @@ asmlinkage void __init start_kernel(void
 asmlinkage void __init start_kernel(void)
 {
 	arch_get_boot_command_line();
-	parse_args("Core params", boot_command_line, __start___core_param,
+	parse_args("Core and early params", boot_command_line,
+		   __start___core_param,
 		   __stop___core_param - __start___core_param,
-		   unknown_core_ok, true);
-	/* All fall through to do_early_param. */
-	parse_args("early options", boot_command_line, NULL, 0, do_early_param,
-		   true);
+		   do_early_param, true);
 
 	smp_setup_processor_id();
 

