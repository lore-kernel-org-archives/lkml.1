Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXBSRks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXBSRks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXBSRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:40:48 -0500
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:39539 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932432AbXBSRks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:40:48 -0500
X-YMail-OSG: l5SVnvAVM1kOX.GNHuh_jmcCAipBmCGrvcVnH6bG2PRHHuMvkPh.CCfXVtqCExyC8a2JaT_qObL1Nw1sFm3.A_QbUmooL5DGj3pCIZDPK1y77fK2g1mqlA--
Date: Mon, 19 Feb 2007 11:40:43 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Simon Arlott <0fe037f0d97e4d61cc1him220006i098@thunder.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: security_fixup_ops
Message-ID: <20070219174043.GA28285@vino.hallyn.com>
References: <45D6CD2D.7090705@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D6CD2D.7090705@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Simon Arlott (simon@arlott.org):
> Shouldn't security_fixup_ops be exported?
> 
> Otherwise I have to include the kernel's security/dummy.c to use it
> and there's no other way to fix all the ops for a secondary module

security_fixup_ops() is called automatically by register_security(), as
well as by mod_reg_security() before your own
security_ops->register_security() is called on it.  So you don't need to
call it.

-serge

> without copying a list of all the ops, which may change in future
> kernels, into the module's code.
> 
> Unless of course including kernel source in modules is ok, because the
> module will need to have been compiled with the right version of
> struct security_operations anyway.
> 
> ---
> /* http://redrum.lp0.eu/portac/portac.c */
> 
> #include <../security/dummy.c>
> 
> struct security_operations portac_ops = { 
> 	.register_security = portac_register_security,
> 	.unregister_security = portac_unregister_security,
> 
> 	.socket_bind = portac_socket_bind
> };
> struct security_operations primary_ops;
> struct security_operations *secondary_ops = NULL;
> 
> int portac_register_security(const char *name, struct security_operations *ops)
> {
> 	struct security_operations tmp;
> ...
> 	/* Copy our current ops because they have
> 	 * been fixed with dummy functions.
> 	 *
> 	 * Keep a reference to the secondary ops
> 	 * for later use.
> 	 */
> 	primary_ops = portac_ops;
> 	secondary_ops = ops;
> 
> 	/* Copy the secondary ops, override the
> 	 * functions we use and call security_fixup_ops
> 	 * to add missing dummy functions.
> 	 *
> 	 * Replace our current ops with these ops.
> 	 */
> 	tmp = *ops;
> 	tmp.socket_bind = portac_socket_bind;
> 	tmp.unregister_security = portac_unregister_security;
> 	security_fixup_ops(&tmp); /* from security/dummy.c */
> 	portac_ops = tmp;
> ...
> }
> 
> -- 
> Simon Arlott
> 


