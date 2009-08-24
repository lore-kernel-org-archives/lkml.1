Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZHXVUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZHXVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZHXVUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:20:20 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50799
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZHXVUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:20:19 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 17:20:18 EDT
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Mon, 24 Aug 2009 16:11:08 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
References: <20090312092114.GC6949@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz>
In-Reply-To: <20090824093143.GD25591@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908241611.10400.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009 04:31:43 Pavel Machek wrote:
> Running journaling filesystem such as ext3 over flashdisk or degraded
> RAID array is a bad idea: journaling guarantees no longer apply and
> you will get data corruption on powerfail.
>
> We can't solve it easily, but we should certainly warn the users. I
> actually lost data because I did not understand these limitations...
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Rob Landley <rob@landley.net>

With a couple comments:

> +* write caching is disabled. ext2 does not know how to issue barriers
> +  as of 2.6.28. hdparm -W0 disables it on SATA disks.

It's coming up on 2.6.31, has it learned anything since or should that version 
number be bumped?

> +	(Thrash may get written into sectors during powerfail.  And
> +	ext3 handles this surprisingly well at least in the
> +	catastrophic case of garbage getting written into the inode
> +	table, since the journal replay often will "repair" the
> +	garbage that was written into the filesystem metadata blocks.
> +	It won't do a bit of good for the data blocks, of course
> +	(unless you are using data=journal mode).  But this means that
> +	in fact, ext3 is more resistant to suriving failures to the
> +	first problem (powerfail while writing can damage old data on
> +	a failed write) but fortunately, hard drives generally don't
> +	cause collateral damage on a failed write.

Possible rewording of this paragraph:

  Ext3 handles trash getting written into sectors during powerfail
  surprisingly well.  It's not foolproof, but it is resilient.  Incomplete
  journal entries are ignored, and journal replay of complete entries will
  often "repair" garbage written into the inode table.  The data=journal
  option extends this behavior to file and directory data blocks as well
  (without which your dentries can still be badly corrupted by a power fail
  during a write).

(I'm not entirely sure about that last bit, but clarifying it one way or the 
other would be nice because I can't tell from reading it which it is.  My 
_guess_ is that directories are just treated as files with an attitude and an 
extra cacheing layer...?)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
