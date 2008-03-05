Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbYCEMQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbYCEMQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbYCEMP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:15:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:5367 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbYCEMP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:15:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=pcTO10JklS8+obhZE9d6V0bDM52nQTkkTz7jInlSS19mPwuH/ElwdMny7qdox0k477F1ng7Ym8UN9bYu8PdWsm2XehPtsk5U8hcMKiyKBxzFTLjj5k2iIE0cSFlFqGwy69n1yupZcuU0NuDO3F73jNFdD+5QC62YPmVVM6cnQpw=
Date: Wed, 5 Mar 2008 14:12:45 +0200
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
	loaded
Message-ID: <20080305121245.GA18152@ubuntu>
References: <521493.30745.qm@web36606.mail.mud.yahoo.com> <alpine.LFD.1.00.0803041009210.12253@woody.linux-foundation.org> <Xine.LNX.4.64.0803051154180.7427@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0803051154180.7427@us.intercode.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 11:58:08AM +1100, James Morris wrote:
> On Tue, 4 Mar 2008, Linus Torvalds wrote:
> 
> > 
> > 
> > On Tue, 4 Mar 2008, Casey Schaufler wrote:
> > > 
> > > One solution would be to tighten the smackfs code so that it
> > > handles the uninitialized LSM case properly.
> > 
> > I really would tend to prefer that.
> 
> Can you simply call init_smk_fs() from smack_init() prior to 
> register_security() ?
> 

After analysing below oops:

[    0.072989] Call Trace:
[    0.072989]  [<c017d4a4>] alloc_vfsmnt+0x24/0xd0
[    0.072989]  [<c0168ee1>] vfs_kern_mount+0x31/0x120
[    0.072989]  [<c0168fe2>] kern_mount_data+0x12/0x20
[    0.072989]  [<c038a73c>] init_smk_fs+0x4c/0x80
[    0.072989]  [<c038a6ce>] smack_init+0xae/0xd0
[    0.072989]  [<c038a192>] security_init+0x52/0x70
[    0.072989]  [<c037aaa5>] start_kernel+0x1e5/0x290
[    0.072989]  [<c037a380>] unknown_bootoption+0x0/0x1f0
[    0.072989]  =======================

I've found that vfs_caches_init() got called after calling 
security_init() in the main kernel init path. 

This leads to kern_mount() Oopsing cause of Null dereferencing 
of mnt_cache  in the alloc_vfsmnt(mnt_cache, GFP_KERNEL) step.

I was thinking about exporting the current chosen_lsm[] string,
but I don't know if this maybe seen by Linus as another global
that arises from bad design. It may not also scale well if the
LSM needs to check if it's enabled in various places (lots of
strcmp()s).

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

