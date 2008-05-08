Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbYEHKjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbYEHKjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbYEHKj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:39:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36811 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYEHKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:39:24 -0400
Date: Thu, 08 May 2008 19:38:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4822D30E.5010506@goop.org>
References: <20080508012957.c778c8e7.akpm@linux-foundation.org> <4822D30E.5010506@goop.org>
Message-Id: <20080508193224.0EFF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thanks good comment!

> > How many times do we have to make this mistake :(
> >
> > Only the caller knows what allocation mode the callee can use. 
> > call_usermodehelper_setup() should be extended to take a gfp_t argument.
> 
> Yeah, but making the caller need to know about the internal 
> implementation details of the callee (ie, whether it needs to allocate 
> memory or not) leads to pretty warty interfaces.  In this case, you 
> could push the gfp_t up to the call_usermodehelper_setup() level, but 
> pushing it any higher wouldn't make much sense.

No problem :)
almost caller doesn't call call_usermodehelper_setup() directly.

thus, call_usermodehelper_setup() chage is hided in call_usermodehelper().


----------------chunk of my current testing patch-----------------------------

@@ -68,8 +69,9 @@ static inline int
 call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
 	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 	return call_usermodehelper_exec(info, wait);



