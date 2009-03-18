Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZCRXkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZCRXkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 19:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZCRXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 19:39:52 -0400
Received: from ozlabs.org ([203.10.76.45]:59143 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZCRXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 19:39:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: linux-next - request_module_nowait() breaks iptables and iwl3945
Date: Thu, 19 Mar 2009 10:09:44 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
References: <3823.1237168684@turing-police.cc.vt.edu> <200903181442.16570.rusty@rustcorp.com.au> <49C07F96.2070306@linux.intel.com>
In-Reply-To: <49C07F96.2070306@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200903191009.44408.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 15:29:02 Arjan van de Ven wrote:
> Rusty Russell wrote:
> > OK, I think this might fix it.  It's already queued, but was labelled a mere
> > "cleanup".
> 
> I wouldn't understand how it would fix it though;
> the code before my patch passes in a 1, and the code after my patch passes in a variable
> which has the value 1 as well.... using a symbolic name for it instead isn't going
> to impact the generated code afaics...

There's a patch in between which changed it to a bool, but yes, it should do
nothing since we hand "true" (ie. 1): I don't think sign-extending that to -1
is legal.  Yet that would explain his issues.

Anyway, he bisected it down to that original commit.  Hmm...

Valdis, does this give anything in your boot logs?  And what compiler version
and platform are you using?

diff --git a/kernel/kmod.c b/kernel/kmod.c
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -109,6 +109,8 @@ int __request_module(int wait, const cha
 		atomic_dec(&kmod_concurrent);
 		return -ENOMEM;
 	}
+
+	WARN_ON(!wait);
 
 	ret = call_usermodehelper(modprobe_path, argv, envp, wait);
 	atomic_dec(&kmod_concurrent);
