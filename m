Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZFTUjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZFTUjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZFTUjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:39:33 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45765 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZFTUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:39:32 -0400
Date: Sat, 20 Jun 2009 13:39:35 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH 17/21] ceph: nfs re-export support
In-Reply-To: <4A3CA7FB.60707@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0906201332410.2932@cobra.newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
 <1245450702-31343-3-git-send-email-sage@newdream.net>
 <1245450702-31343-4-git-send-email-sage@newdream.net>
 <1245450702-31343-5-git-send-email-sage@newdream.net>
 <1245450702-31343-6-git-send-email-sage@newdream.net>
 <1245450702-31343-7-git-send-email-sage@newdream.net>
 <1245450702-31343-8-git-send-email-sage@newdream.net>
 <1245450702-31343-9-git-send-email-sage@newdream.net>
 <1245450702-31343-10-git-send-email-sage@newdream.net>
 <1245450702-31343-11-git-send-email-sage@newdream.net>
 <1245450702-31343-12-git-send-email-sage@newdream.net>
 <1245450702-31343-13-git-send-email-sage@newdream.net>
 <1245450702-31343-14-git-send-email-sage@newdream.net>
 <1245450702-31343-15-git-send-email-sage@newdream.net>
 <1245450702-31343-16-git-send-email-sage@newdream.net>
 <1245450702-31343-17-git-send-email-sage@newdream.net>
 <1245450702-31343-18-git-send-email-sage@newdream.n! et> <4A3CA7FB.60707@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Stefan Richter wrote:
> Sage Weil wrote:
> > +++ b/fs/staging/ceph/export.c
> ...
> > +static struct dentry *ceph_fh_to_parent(struct super_block *sb, struct fid
> > *fid,
> > +				 int fh_len, int fh_type)
> > +{
> > +	u32 *fh = fid->raw;
> > +	u64 ino = *(u64 *)fh;
> > +	u32 hash = fh[2];
> > +
> > +	derr(10, "fh_to_parent %llx.%x\n", ino, hash);
> > +
> > +	if (fh_len < 6)
> > +		return ERR_PTR(-ESTALE);
> > +
> > +	return __fh_to_dentry(sb, (struct ceph_export_item *)fh + 1,
> > +			      fh_len/IPSZ - 1);
> > +}
> 
> fid->raw could be 32-bit aligned, couldn't it?
> 
> #include <asm/unaligned.h>
> 
> 	u64 ino = get_unaligned((u64 *)fh);

Hmm, yeah.  I've done the same thing in a bunch of other places, too, the 
big offender being decode.h, where e.g.

		v = le64_to_cpu(*(__le64 *)*(p));	\
                *(p) += sizeof(u64);                    \

should be

                v = le64_to_cpu(get_unaligned((__le64 *)*(p)));       \
                *(p) += sizeof(u64);                    \

I'll do a full audit to clean these up.

> 	derr(10, "fh_to_parent %llx.%x\n",
> 	     (unsigned long long)ino, hash);

I've been secretly hoping someone will add printk format specifiers for 
fixed size u32 and u64 so I can avoid sprinkling hundreds of (unsigned 
long long)'s throughout.  Is an explicit cast really the cleanest way to 
fix this?

Thanks!
sage
