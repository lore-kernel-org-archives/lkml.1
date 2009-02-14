Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZBNNUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZBNNUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 08:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBNNT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 08:19:59 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55092 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZBNNT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 08:19:59 -0500
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Fernando Luis Vazquez Cao <fernando@kic.ac.jp>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>
In-Reply-To: <1234616633.19783.91.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com>
	 <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
	 <49951121.80807@redhat.com> <20090213122051.GX8830@disturbed>
	 <1234542568.9916.183.camel@bladerunner>  <20090214112443.GY8830@disturbed>
	 <1234616633.19783.91.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Sat, 14 Feb 2009 22:19:57 +0900
Message-Id: <1234617597.19783.110.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 22:03 +0900, Fernando Luis Vázquez Cao wrote:
> > > 2- Modify file_fsync() so that it checks whether FLUSHONFSYNC is set and
> > > flushes the underlying device accordingly. With this we would cover all
> > > filesystems that use the vfs-provided file_fsync() as their fsync method
> > > (commonly used filesystems such as fat fall in this group).
> > 
> > Just make it flush the block device.
> 
> I wrote a patch that does exactly that but, in addition, it checks
> whether FLUSHONFSYNC is set to avoid sending unnecessary flushes down
> the block layer (this patch is not included in this patch-set, but I
> will add it in the next iteration).

I probably should have mentioned in my proposal all filesystems would
just call the helper function block_flush_device() to flush the
underlying block device, unconditionally.

This helper function looks like this:

+/* Issue flush of write caches on the block device */
+int block_flush_device(struct super_block *sb)
+{
+       int ret = 0;
+
+       if (!(sb->s_flags & MS_FLUSHONFSYNC))
+               return ret;
+
+       ret = blkdev_issue_flush(sb->s_bdev, NULL);
+
+       if (ret == -EOPNOTSUPP)
+               return 0;
+
+       return ret;
+}

As you can see the check for flushonfsync is done here, so changing my
patches along the lines you suggest would be a trivial two lines patch.

- Fernando

> As I mentioned above, if everyone thinks this small optimization not
> elegant or an undesirable layering violation I will remove it.



