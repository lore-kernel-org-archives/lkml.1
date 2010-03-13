Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab0CMLUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:20:52 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58497 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab0CMLUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:20:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=DZSG1M0ml0TGBg6dM6be/yfN98ywG/IUkfMDqSB8+XGkqNp1w7Z2EDmdbX9jWV2yld
         qtEqIXseC18EWOYd4DsDZC8z3Ix3Rhm54B85bLndbcoFM97pqIpz5X5agZjtTbr0u+RT
         OOovAAozYLU8+U3l+/4UhS8XlLjPHw28lGeO8=
Date: Sat, 13 Mar 2010 14:14:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       James Morris <jmorris@namei.org>, Serge Hallyn <serue@us.ibm.com>,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] tomoyo: fix potential use after free
Message-ID: <20100313111422.GA2594@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	James Morris <jmorris@namei.org>, Serge Hallyn <serue@us.ibm.com>,
	Toshiharu Harada <haradats@nttdata.co.jp>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code returns a freed pointer.  This function is expected to 
return NULL on errors.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index ff51f10..ef89947 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -886,6 +886,7 @@ static struct tomoyo_profile *tomoyo_find_or_assign_new_profile(const unsigned
 	ptr = kmalloc(sizeof(*ptr), GFP_KERNEL);
 	if (!tomoyo_memory_ok(ptr)) {
 		kfree(ptr);
+		ptr = NULL;
 		goto ok;
 	}
 	for (i = 0; i < TOMOYO_MAX_CONTROL_INDEX; i++)
