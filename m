Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYJTNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYJTNCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYJTNCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:02:06 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:62727 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYJTNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:02:05 -0400
X-Greylist: delayed 1957 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 09:02:05 EDT
Message-ID: <48FC7938.1070906@cs.columbia.edu>
Date: Mon, 20 Oct 2008 08:27:36 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Kentaro Takeda <takedakn@nttdata.co.jp>
CC: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       Crispin Cowan <crispin@crispincowan.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [TOMOYO #11 (linux-next) 01/11] Introduce new LSM hooks where
 vfsmount is available.
References: <20081020073423.024299308@nttdata.co.jp> <20081020073643.986810046@nttdata.co.jp>
In-Reply-To: <20081020073643.986810046@nttdata.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kentaro Takeda wrote:
> ----- What is this patch for? -----
> 
> There are security_inode_*() LSM hooks for attribute-based MAC, but they are not
> suitable for pathname-based MAC because they don't receive "struct vfsmount"
> information.
> 
> ----- How this patch was developed? -----
> 
> Two pathname-based MACs, AppArmor and TOMOYO Linux, are trying to merge
> upstream. But because of "struct vfsmount" problem, they have been unable to
e> merge upstream.
> 
> Here are the list of approaches and the reasons of denial.

I know I'm late to the game in this, but as I recently asked about this 
and didn't get an answer, I'll re-ask my approach.

Why can't you do this

in lookup()

- resolve rules (not for single process, but for all processes) for said 
path and tag dentry (seem to already have a hook)

in permission()

- check tag based on current security context

in rename(),....

- drop dentry tag and force a lookup next time its used (invalidate dentry)

you then don't have to jump through hoops to handle things like symbolic 
links as they are handled implicitly.

the only place I can see this approach "failing" (as in different 
semantics than your approach) is

- hard links within a single namespace and bind mounts shared between 
namespaces (in that different rules would be resolved for different path 
names for the same file).

But from a security perspective, both would seem like a very bad idea in 
general that one would ant to prevent.  or to rephrase, why would you 
want to allow that?  What's the benefit in allowing that?
