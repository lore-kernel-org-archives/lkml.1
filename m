Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXLCPDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXLCPDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbXLCPDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:03:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54806 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbXLCPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:03:40 -0500
Date: Mon, 3 Dec 2007 09:03:08 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morgan <morgan@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 - add-64-bit-capability-support-to-the-kernel
Message-ID: <20071203150308.GD9008@sergelap.austin.ibm.com>
References: <14896.1196497105@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14896.1196497105@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
> Question:
> 
> The patch does the semantic equivalent of:
> 
> -#define cap_clear(c)         do { cap_t(c) =  0; } while(0)
> -#define cap_set_full(c)      do { cap_t(c) = ~0; } while(0)
> 
> +# define cap_clear(c)         do { (c) = __cap_empty_set; } while (0)
> +# define cap_set_full(c)      do { (c) = __cap_full_set; } while (0)
> +# define cap_set_init_eff(c)  do { (c) = __cap_init_eff_set; } while (0)
> 
> Was it intentional, or an oversight, that this blows chunks in modules
> that try to use cap_clear() or cap_set_full() because the __cap_*
> symbols don't get an EXPORT_SYMBOL() attached to them?

I think that's one big oops, and the following is needed.

>From 9c217a6280b559cca28edab621d2d22288ce0ac6 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Mon, 3 Dec 2007 09:59:50 -0500
Subject: [PATCH 1/1] capabilities: export __cap_ symbols

Export __cap_empty_set and friends so that the cap_clear(),
cap_set_full() and cap_set_init_eff() defines can be used
by modules.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/capability.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 9f2db55..064eb8a 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -29,6 +29,10 @@ const kernel_cap_t __cap_empty_set = CAP_EMPTY_SET;
 const kernel_cap_t __cap_full_set = CAP_FULL_SET;
 const kernel_cap_t __cap_init_eff_set = CAP_INIT_EFF_SET;
 
+EXPORT_SYMBOL(__cap_empty_set);
+EXPORT_SYMBOL(__cap_full_set);
+EXPORT_SYMBOL(__cap_init_eff_set);
+
 /*
  * For sys_getproccap() and sys_setproccap(), any of the three
  * capability set pointers may be NULL -- indicating that that set is
-- 
1.5.1.1.GIT


