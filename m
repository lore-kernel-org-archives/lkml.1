Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZCPWuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZCPWuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZCPWuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:50:23 -0400
Received: from mail.fieldses.org ([141.211.133.115]:34516 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZCPWuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:50:22 -0400
Date: Mon, 16 Mar 2009 18:48:48 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Igor Zhbanov <izh1979@gmail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       SELinux <selinux@tycho.nsa.gov>
Subject: Re: =?utf-8?B?0J7RgtCy0LXRgjogVkZTLCBORlMg?=
	=?utf-8?Q?security_bug=3F_Shoul?=
	=?utf-8?Q?d?= CAP_MKNOD and CAP_LINUX_IMMUTABLE be added to
	CAP_FS_MASK?
Message-ID: <20090316224848.GC17738@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com> <20090313190002.GA16025@us.ibm.com> <1237227705.1035.93.camel@localhost.localdomain> <20090316184926.GA6729@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316184926.GA6729@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems this isn't entirely obvious in the general case.  In the specific
case of nfsd, however, this is pretty obvious.  So I'm inclined to
submit the following now (and leave it to be reverted by a later patch
if CAP_FS_MASK ends up including CAP_MKNOD, as seems likely).

--b.

commit 2ec8f8f0c0005ffe3cf93bbf3d9976de76cf4652
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Mon Mar 16 18:34:20 2009 -0400

    nfsd: nfsd should drop CAP_MKNOD for non-root
    
    Since creating a device node is normally an operation requiring special
    privilege, Igor Zhbanov points out that it is surprising (to say the
    least) that a client can, for example, create a device node on a
    filesystem exported with root_squash.
    
    So, make sure CAP_MKNOD is among the capabilities dropped when an nfsd
    thread handles a request from a non-root user.
    
    Reported-by: Igor Zhbanov <izh1979@gmail.com>
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 02bdb76..7824483 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -393,8 +393,10 @@ struct cpu_vfs_cap_data {
 # define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
 # define CAP_INIT_EFF_SET ((kernel_cap_t){{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }})
 # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } })
-# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
-					CAP_FS_MASK_B1 } })
+# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0 \
+					    | CAP_TO_MASK(CAP_SYS_RESOURCE) \
+					    | CAP_TO_MASK(CAP_MKNOD), \
+					    CAP_FS_MASK_B1 } })
 
 #endif /* _KERNEL_CAPABILITY_U32S != 2 */
 
